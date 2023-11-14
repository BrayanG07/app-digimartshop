import {
  HttpException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';
import { PixelPayBody } from './interface/pixelpayBody.interface';
import { InjectRepository } from '@nestjs/typeorm';
import { PixelpayResponse } from './entities/pixelpayResponse.entity';
import { Repository } from 'typeorm';

@Injectable()
export class PixelpayService {
  private readonly axios: AxiosInstance = axios;

  private readonly PIXELPAY_URL: string;
  private readonly API_KEY: string;
  private readonly API_SECRET: string;
  private readonly PIXELPAY_ENV: string;

  constructor(
    private readonly configService: ConfigService,
    @InjectRepository(PixelpayResponse)
    private readonly pixelpayResponseRepository: Repository<PixelpayResponse>,
  ) {
    this.PIXELPAY_URL = this.configService.get('URL_PIXEL_PAY_API');
    this.API_KEY = this.configService.get('X_AUTH_KEY_PIXEL_PAY');
    this.API_SECRET = this.configService.get('X_AUTH_HASH_PIXEL_PAY');
    this.PIXELPAY_ENV = this.configService.get('PIXELPAY_ENV');
  }

  async executePayment(body: PixelPayBody): Promise<boolean> {
    const headers = {
      'Content-Type': 'application/json',
      'x-auth-key': this.API_KEY,
      'x-auth-hash': this.API_SECRET,
    };

    body.env = this.PIXELPAY_ENV;
    body.order_amount = '1';

    // console.log(this);

    try {
      const response = await this.axios.post(this.PIXELPAY_URL, body, {
        headers,
      });

      // guardo la respuesta en la base de datos
      await this.saveResponse(response);

      if (response.status >= 300 || response.status < 200) {
        throw new InternalServerErrorException(response);
      }
    } catch (error) {
      // console.log(error.response.status, error.response.data);

      await this.saveResponse(error.response);

      // guardo la respuesta en la base de datos

      throw new HttpException(
        {
          message: 'Error en la realizacion del pago',
          data: error.response.data,
        },
        error.response.status,
      );
    }

    return true;
  }

  async saveResponse(response) {
    // console.log(response);

    try {
      const { status, statusText, data } = response;

      // console.log(data);

      const pixelpayResponse = {
        success: data.success,
        message: data.message,
        code: status,
        paymentUUID: '',
        textStatus: statusText,
      };

      if (response.data.data) {
        pixelpayResponse.paymentUUID = response.data.data.payment_uuid;
      }

      // const reps = await this.pixelpayResponseRepository.save(pixelpayResponse);
      await this.pixelpayResponseRepository.save(pixelpayResponse);

      // console.log(reps);
    } catch (error) {
      console.log(error);
    }
  }
}
