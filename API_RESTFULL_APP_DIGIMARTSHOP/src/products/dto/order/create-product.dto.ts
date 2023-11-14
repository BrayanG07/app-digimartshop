import { IsNotEmpty, IsNumber, IsPositive, IsUUID } from 'class-validator';

export class CreateProductDto {
  @IsUUID()
  @IsNotEmpty({ message: 'El id del producto es requerido' })
  idProduct: string;

  @IsUUID()
  @IsNotEmpty({ message: 'El id del stock es requerido' })
  idStock: string;

  @IsUUID()
  @IsNotEmpty({ message: 'El id del supermarket es requerido' })
  idSupermarket: string;

  @IsNumber({}, { message: 'La cantidad debe ser un número' })
  @IsPositive({ message: 'La cantidad debe ser positiva' })
  @IsNotEmpty({ message: 'La cantidad es requerida' })
  quantity: number;
}
