import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { CreateUbicationDto } from './dto/create-ubication.dto';
import { UpdateUbicationDto } from './dto/update-ubication.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Ubication } from './entities/ubication.entity';
import { UsersService } from '../users/users.service';
import { STATUS_UBICATION } from '../constants/status/status.ubication';

@Injectable()
export class UbicationService {
  constructor(
    @InjectRepository(Ubication)
    private readonly ubicationRepository: Repository<Ubication>,
    private readonly userService: UsersService,
  ) {}

  async create(createUbicationDto: CreateUbicationDto) {
    const user = await this.userService.findOne(createUbicationDto.idUser);

    delete createUbicationDto.idUser;
    const ubication = await this.ubicationRepository.save({
      ...createUbicationDto,
      user,
    });

    if (!ubication)
      throw new InternalServerErrorException('Error al crear la ubicacion');

    delete ubication.user;
    return ubication;
  }

  async findAllByIdUser(idUser: string) {
    return await this.ubicationRepository.find({
      select: {
        idUbication: true,
        address: true,
        neighborhood: true,
        refPoint: true,
        latitude: true,
        longitude: true,
        status: true,
      },
      where: {
        user: { idUser },
        status: STATUS_UBICATION.ACTIVE,
      },
      order: {
        createdAt: 'DESC',
      },
    });
  }

  findOne(id: number) {
    return `This action returns a #${id} ubication`;
  }

  update(id: number, updateUbicationDto: UpdateUbicationDto) {
    return `This action updates a #${id} ubication ${updateUbicationDto}`;
  }

  remove(id: number) {
    return `This action removes a #${id} ubication`;
  }
}
