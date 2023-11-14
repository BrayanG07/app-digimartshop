import { IsEmail, IsNotEmpty, IsOptional, IsUrl } from 'class-validator';

export class SignInGoogleDto {
  @IsNotEmpty({ message: 'El correo electrónico es requerido' })
  @IsEmail({}, { message: 'Correo electrónico inválido' })
  email: string;

  @IsNotEmpty({ message: 'El nombre de la persona es requerido ' })
  displayName: string;

  @IsNotEmpty({ message: 'La foto de perfil es requerida' })
  @IsUrl({}, { message: 'La foto de perfil debe ser una URL' })
  photoUrl: string;

  @IsOptional()
  phoneNumber: string;
}
