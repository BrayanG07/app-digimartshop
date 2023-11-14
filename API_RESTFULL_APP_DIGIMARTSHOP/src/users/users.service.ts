import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import * as bcrypt from 'bcrypt';
import { Repository } from 'typeorm';
import { UploadApiOptions } from 'cloudinary';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { User } from './entities/user.entity';
import { LoginUserDto } from './dto/login-user.dto';
import { RESOURCES_CLOUDINARY } from '../constants/resources.cloudinary';
import { CloudinaryService } from '../common/services/cloudinary.service';
import { CloudinaryResponse } from '../common/type/cloudinary-response';
import { REGISTRATION_TYPE, STATUS_USER } from '../constants';
import { SignInGoogleDto, UpdateLocationDeliveryDto } from './dto';
import { Delivery } from './entities/delivery.entity';

@Injectable()
export class UsersService {
  constructor(
    private readonly configService: ConfigService,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Delivery)
    private readonly deliveryRepository: Repository<Delivery>,
    private readonly cloudinaryService: CloudinaryService,
  ) {}

  async create(createUserDto: CreateUserDto) {
    const { email, password, emailSponsor } = createUserDto;
    let parentUser: User = null;

    if (emailSponsor) {
      parentUser = await this.findOneByEmail(emailSponsor);
    }

    await this.existEmail(email);

    const passwordEncrypt = bcrypt.hashSync(
      password,
      +this.configService.get('HASH_SALT'),
    );

    delete createUserDto.password;
    delete createUserDto.emailSponsor;

    const user = await this.userRepository.save({
      password: passwordEncrypt,
      parentUser,
      ...createUserDto,
      registrationType: REGISTRATION_TYPE.BASIC,
    });

    if (!user) {
      throw new InternalServerErrorException(
        'Se produjo un error al crear el usuario.',
      );
    }

    delete user.password;
    return user;
  }

  private async saveImageCloudinary(file: Express.Multer.File) {
    const options: UploadApiOptions = {
      folder: RESOURCES_CLOUDINARY.FOLDER_USER,
      resource_type: 'image',
      format: 'jpg',
    };

    const cloudinaryResponse: CloudinaryResponse =
      await this.cloudinaryService.uploadFile(file, options);

    return cloudinaryResponse;
  }

  async findOneByEmail(email: string) {
    const emailToFind = email.split(' ').join('').toLocaleLowerCase();

    const user = await this.userRepository.findOne({
      where: { email: emailToFind },
      select: {
        idUser: true,
        password: true,
        status: true,
        firstName: true,
        lastName: true,
        email: true,
        dni: true,
        image: true,
        phone: true,
        role: true,
        registrationType: true,
        parentUser: {
          idUser: true,
          firstName: true,
          lastName: true,
          email: true,
          phone: true,
        },
      },
      relations: {
        parentUser: true,
      },
    });

    return user;
  }

  async loginUser(loginUserDto: LoginUserDto) {
    const { email, password } = loginUserDto;
    const user = await this.findOneByEmail(email);

    if (!user) {
      throw new NotFoundException('Correo electrónico incorrecto.');
    }

    if (user.registrationType !== REGISTRATION_TYPE.BASIC) {
      throw new NotFoundException('Correo electrónico incorrecto.');
    }

    if (user.status === STATUS_USER.INACTIVE)
      throw new UnauthorizedException(
        'Tu usuario esta deshabilitado, comunicate con nuestro equipo de atención al cliente.',
      );

    if (!bcrypt.compareSync(password, user.password))
      throw new UnauthorizedException('Contraseña incorrecta.');

    delete user.password;
    return user;
  }

  async signInWithGoogle(signInGoogleDto: SignInGoogleDto) {
    const user = await this.findOneByEmail(signInGoogleDto.email);

    if (user && user.registrationType === REGISTRATION_TYPE.GOOGLE) {
      // ? Regenerar el token y devolver la informacion del usuario
      delete user.password;
      return user;
    } else if (!user) {
      // ? Crear el usuario
      const userCreated = await this.userRepository.save({
        email: signInGoogleDto.email.split(' ').join('').toLocaleLowerCase(),
        phone: signInGoogleDto.phoneNumber,
        firstName: signInGoogleDto.displayName.split(' ')[0] ?? '',
        lastName: signInGoogleDto.displayName.split(' ')[1] ?? '',
        registrationType: REGISTRATION_TYPE.GOOGLE,
        image: signInGoogleDto.photoUrl,
      });

      if (!userCreated) {
        throw new InternalServerErrorException(
          'Se produjo un error al crear el usuario.',
        );
      }

      delete userCreated.password;
      return userCreated;
    }

    throw new InternalServerErrorException(
      'Se produjo un error con el usuario.',
    );
  }

  async existEmail(email: string): Promise<void> {
    const emailFind: string = email.trim().toLocaleLowerCase();
    const count: number = await this.userRepository.count({
      where: {
        email: emailFind,
      },
    });

    if (count > 0)
      throw new BadRequestException(
        `El correo electronico ${emailFind} ya pertenece a otro usuario.`,
      );
  }

  async existDni(dni: string): Promise<void> {
    const dniFind: string = dni.trim();
    const count: number = await this.userRepository.count({
      where: {
        dni: dniFind,
      },
    });

    if (count > 0)
      throw new BadRequestException(
        `El DNI ${dniFind} ya pertenece a otro usuario.`,
      );
  }

  async existUser(id: string): Promise<void> {
    const count: number = await this.userRepository.count({
      where: {
        idUser: id,
      },
    });

    if (count === 0)
      throw new BadRequestException(`El usuario con id ${id} no existe.`);
  }

  async findAll() {
    return await this.userRepository.find();
  }

  async findOne(idUser: string) {
    const userFound = await this.userRepository.findOne({
      select: {
        idUser: true,
        status: true,
        firstName: true,
        lastName: true,
        email: true,
        image: true,
        phone: true,
        dni: true,
        role: true,
        parentUser: { idUser: true },
      },
      relations: { parentUser: true },
      where: { idUser },
    });

    if (!userFound)
      throw new BadRequestException(`El usuario con ID: ${idUser} no existe.`);

    return userFound;
  }

  async findOneDelivery(idDelivery: string) {
    const deliveryFound = await this.userRepository.findOne({
      select: {
        idUser: true,
        status: true,
        firstName: true,
        lastName: true,
        email: true,
        image: true,
        phone: true,
        dni: true,
        role: true,
      },
      relations: {
        delivery: true,
      },
      where: { delivery: { idDelivery } },
    });

    if (!deliveryFound) {
      throw new NotFoundException(
        `El delivery con ID: ${idDelivery} no existe.`,
      );
    }

    return deliveryFound;
  }

  async findUserAuthById(idUser: string) {
    const userFound: User = await this.userRepository.findOne({
      select: { idUser: true, status: true, email: true },
      where: { idUser },
    });

    return userFound;
  }

  async update(
    id: string,
    updateUserDto: UpdateUserDto,
    image: Express.Multer.File,
  ) {
    const user = await this.findOne(id);
    let imageToUpdate = user.image;

    if (updateUserDto.dni && updateUserDto.dni !== user.dni)
      await this.existDni(updateUserDto.dni);

    if (image) {
      // Guardar la imagen en cloudinary
      const { secure_url }: CloudinaryResponse = await this.saveImageCloudinary(
        image,
      );

      imageToUpdate = secure_url;
    }

    const userUpdated = await this.userRepository.update(id, {
      firstName: updateUserDto.firstName,
      lastName: updateUserDto.lastName,
      dni: updateUserDto.dni,
      phone: updateUserDto.phone,
      image: imageToUpdate,
    });

    if (userUpdated.affected === 0)
      throw new InternalServerErrorException(
        'Se produjo un error al actualizar el usuario.',
      );

    user.firstName = updateUserDto.firstName ?? user.firstName;
    user.lastName = updateUserDto.lastName ?? user.lastName;
    user.dni = updateUserDto.dni ?? user.dni;
    user.phone = updateUserDto.phone ?? user.dni;
    user.image = imageToUpdate;
    return user;
  }

  async guestUsersInvited(idUser: string): Promise<User[]> {
    return await this.userRepository.find({
      select: {
        firstName: true,
        lastName: true,
        email: true,
        image: true,
      },
      where: { parentUser: { idUser } },
      order: {
        createdAt: 'DESC',
      },
    });
  }

  async updateLocationDelivery(
    idUser: string,
    updateLocation: UpdateLocationDeliveryDto,
  ) {
    await this.deliveryRepository.update(
      { user: { idUser } },
      {
        latitude: updateLocation.latitude,
        longitude: updateLocation.longitude,
      },
    );
  }
}
