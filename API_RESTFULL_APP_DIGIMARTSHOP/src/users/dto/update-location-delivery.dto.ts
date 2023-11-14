import { IsNotEmpty } from 'class-validator';

export class UpdateLocationDeliveryDto {
  @IsNotEmpty({ message: 'Latitud es requerido' })
  latitude: string;

  @IsNotEmpty({ message: 'Longitud es requerido' })
  longitude: string;
}
