import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtPayload, UserRequest } from './interfaces';
import { STATUS_USER } from '../constants';
import { UsersService } from '../users/users.service';
import { CreateUserDto, SignInGoogleDto, LoginUserDto } from '../users/dto';
import { RandomDataManager } from '../utils/random-data.manager';
import { PinEmail } from './entities/pin-email.entity';
import { EmailService } from '../email/services/email.service';
import { EmailParameters } from '../email/interfaces/email-parameters.interface';

@Injectable()
export class AuthService {
  constructor(
    private readonly userService: UsersService,
    private readonly jwtService: JwtService,
    private readonly emailService: EmailService,
    @InjectRepository(PinEmail)
    private readonly pinEmailRepository: Repository<PinEmail>,
  ) {}

  async isAuthorizedUser(idUser: string): Promise<UserRequest> {
    const user = await this.userService.findUserAuthById(idUser);

    if (!user) throw new UnauthorizedException('Token no valido.');

    if (user.status === STATUS_USER.INACTIVE)
      throw new UnauthorizedException(
        'El usuario está inactivo, comunicate con un administrador.',
      );

    return {
      idUser: user.idUser,
      email: user.email,
      status: user.status,
    };
  }

  async createUser(createUserDto: CreateUserDto) {
    const user = await this.userService.create(createUserDto);
    return {
      ...user,
      token: this.getJwtToken({
        idUser: user.idUser,
      }),
    };
  }

  async loginUser(loginUserDto: LoginUserDto) {
    const userLogin = await this.userService.loginUser(loginUserDto);

    return {
      ...userLogin,
      token: this.getJwtToken({
        idUser: userLogin.idUser,
      }),
    };
  }

  async signInWithGoogle(signInGoogleDto: SignInGoogleDto) {
    const userSignIn = await this.userService.signInWithGoogle(signInGoogleDto);

    return {
      ...userSignIn,
      token: this.getJwtToken({
        idUser: userSignIn.idUser,
      }),
    };
  }

  private getJwtToken(payload: JwtPayload) {
    const token = this.jwtService.sign(payload);
    return token;
  }

  async verifyCode(email: string, code: string): Promise<void> {
    const emailFind: string = email.trim();
    const count: number = await this.pinEmailRepository.count({
      where: {
        email: emailFind,
        code,
      },
    });

    if (count === 0)
      throw new BadRequestException(
        `El código de verificación ${code} es incorrecto.`,
      );
  }

  async verifyEmail(email: string): Promise<string> {
    const codeVerification = RandomDataManager.randomNumber(4).toString();
    await this.registerPinByEmailUser(codeVerification, email);
    const parametersEmail: EmailParameters = {
      to: email,
      subject: 'Verifica tu cuenta',
      context: {
        codeVerification,
      },
      template: 'verify-email',
    };

    this.emailService.sendEmail(parametersEmail);

    return codeVerification;
  }

  async registerPinByEmailUser(code: string, email: string): Promise<void> {
    try {
      await this.pinEmailRepository.upsert([{ email, code }], ['email']);
    } catch (error) {
      throw new InternalServerErrorException(
        'Se produjo un error al crear el pin de verificacion',
      );
    }
  }
}
