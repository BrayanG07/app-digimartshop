import {
  IsEmail,
  IsNotEmpty,
  Length,
  Matches,
  MaxLength,
} from 'class-validator';

export class LoginUserDto {
  @IsNotEmpty({ message: 'El correo electronico no debe estar vacío.' })
  @MaxLength(100, {
    message: 'El correo electronico debe ser menor o igual a 100 caracteres.',
  })
  @IsEmail()
  email: string;

  @IsNotEmpty({ message: 'La contraseña no debe estar vacío.' })
  @Length(6, 50, {
    message: 'La contraseña debe ser mayor a 6 y menor a 50 caracteres.',
  })
  @Matches(/(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
    message:
      'La contraseña debe tener una letra mayúscula, minúscula y un número.',
  })
  password: string;
}
