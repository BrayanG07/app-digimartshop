import { PartialType } from '@nestjs/mapped-types';
import { CreateUserDto } from './create-user.dto';
import { IsNotEmpty, IsOptional, MaxLength } from 'class-validator';

export class UpdateUserDto extends PartialType(CreateUserDto) {
  @IsOptional()
  @MaxLength(20, {
    message: 'El DNI debe ser menor o igual a 20 caracteres.',
  })
  dni: string;

  @IsOptional()
  @IsNotEmpty({ message: 'El nombre no debe estar vacío.' })
  @MaxLength(80, {
    message: 'El nombre debe ser menor o igual a 80 caracteres.',
  })
  firstName: string;

  @IsOptional()
  @IsNotEmpty({ message: 'El apellido no debe estar vacío.' })
  @MaxLength(80, {
    message: 'El apellido debe ser menor o igual a 80 caracteres.',
  })
  lastName: string;
}
