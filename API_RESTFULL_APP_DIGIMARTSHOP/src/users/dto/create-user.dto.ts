import {
  IsNotEmpty,
  Length,
  Matches,
  Validate,
  IsOptional,
  MaxLength,
  IsEmail,
} from 'class-validator';
import { MatchPasswords } from './match-password.dto';

export class CreateUserDto {
  @IsEmail({}, { message: 'El correo electrónico no es valido.' })
  @MaxLength(100, {
    message: 'El correo electrónico debe ser menor o igual a 100 caracteres.',
  })
  email: string;

  @IsOptional()
  @MaxLength(20, {
    message: 'El numero de celular debe ser menor o igual a 20 caracteres.',
  })
  phone: string;

  @IsOptional()
  @IsEmail({}, { message: 'El correo electrónico del sponsor no es valido.' })
  @MaxLength(100, {
    message: 'El numero de celular debe ser menor o igual a 20 caracteres.',
  })
  emailSponsor: string;

  @IsNotEmpty({ message: 'La contraseña no debe estar vacío.' })
  @Length(6, 50, {
    message: 'La contraseña debe ser mayor a 6 y menor a 50 caracteres.',
  })
  @Matches(/(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
    message:
      'La contraseña debe tener una letra mayúscula, minúscula y un número.',
  })
  password: string;

  @IsNotEmpty({ message: 'La confirmacion de contraseña no debe estar vacío.' })
  @Validate(MatchPasswords, ['password'])
  confirmationPassword: string;
}
