import { IsNotEmpty, IsUUID, MaxLength } from 'class-validator';

export class CreateUbicationDto {
  @IsNotEmpty({ message: 'La direccion no debe estar vacía.' })
  @IsUUID('4', { message: 'El idUser debe ser de tipo UUID()' })
  idUser: string;

  @IsNotEmpty({ message: 'La direccion no debe estar vacía.' })
  @MaxLength(200, {
    message: 'La direccion debe ser menor o igual a 200 caracteres.',
  })
  address: string;

  @IsNotEmpty({ message: 'El vecindario no debe estar vacío.' })
  @MaxLength(200, {
    message: 'El vecindario debe ser menor o igual a 200 caracteres.',
  })
  neighborhood: string;

  @IsNotEmpty({ message: 'El punto de referencia no debe estar vacío.' })
  @MaxLength(255, {
    message: 'El punto de referencia debe ser menor o igual a 255 caracteres.',
  })
  refPoint: string;

  @IsNotEmpty({ message: 'La latitud no debe estar vacia.' })
  latitude: string;

  @IsNotEmpty({ message: 'La longitud no debe estar vacia.' })
  longitude: string;
}
