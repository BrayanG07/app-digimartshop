import { Type } from 'class-transformer';
import {
  ArrayNotEmpty,
  IsArray,
  IsDecimal,
  IsEmail,
  IsEnum,
  IsNotEmpty,
  IsOptional,
  IsUUID,
  MaxLength,
  ValidateIf,
  ValidateNested,
} from 'class-validator';
import { CreateProductDto } from '../../products/dto/order/create-product.dto';
import { PAYMENT_TYPE } from '../../constants/type.payment';

export class CreateOrderDto {
  @IsUUID('4', { message: 'El idUser debe ser un uuid' })
  @IsNotEmpty({ message: 'El id del usuario es requerido' })
  idUser: string;

  @IsNotEmpty({ message: 'El tipo de pago es requerido' })
  @IsEnum(PAYMENT_TYPE)
  paymentType: string;

  @ValidateIf((order) => order.paymentType === PAYMENT_TYPE.CREDIT_DEBIT_CARD)
  @IsNotEmpty({ message: 'El nombre del titular de la tarjeta es requerido' })
  cardName: string;

  @ValidateIf((order) => order.paymentType === PAYMENT_TYPE.CREDIT_DEBIT_CARD)
  @IsNotEmpty({ message: 'El número de tarjeta es requerido' })
  cardNumber: string;

  @ValidateIf((order) => order.paymentType === PAYMENT_TYPE.CREDIT_DEBIT_CARD)
  @IsNotEmpty({ message: 'El cvv es requerido' })
  cardCvv: string;

  @ValidateIf((order) => order.paymentType === PAYMENT_TYPE.CREDIT_DEBIT_CARD)
  @IsNotEmpty({ message: 'El mes de la tarjeta es requerido' })
  @MaxLength(2, {
    message: 'El mes de la tarjeta debe tener un máximo de 2 dígitos',
  })
  monthCard: string;

  @ValidateIf((order) => order.paymentType === PAYMENT_TYPE.CREDIT_DEBIT_CARD)
  @IsNotEmpty({ message: 'El año es requerido' })
  @MaxLength(2, {
    message: 'El año de la tarjeta debe tener un máximo de 2 dígitos',
  })
  yearCard: string;

  @IsOptional()
  @IsEmail({}, { message: 'El email no tiene un formato válido' })
  email: string;

  @IsOptional()
  @MaxLength(255, {
    message: 'El comentario no debe tener más de 255 caracteres',
  })
  comment: string;

  @IsDecimal()
  @IsNotEmpty({ message: 'La latitud es requerida' })
  latitude: string;

  @IsDecimal()
  @IsNotEmpty({ message: 'La longitud es requerida' })
  longitude: string;

  @IsNotEmpty({ message: 'La direccion es requerida' })
  @MaxLength(200, {
    message: 'La direccion no debe tener más de 200 caracteres',
  })
  address: string;

  @IsNotEmpty({ message: 'El detalle de la direccion es requerida' })
  @MaxLength(200, {
    message: 'El detalle de la direccion no debe tener más de 200 caracteres',
  })
  addressDetail: string;

  @IsOptional()
  // @IsDecimal({}, { message: 'El dinero a pagar debe ser un numero decimal.' })
  @Type(() => Number)
  moneyToPay: number;

  @IsArray()
  @ArrayNotEmpty({ message: 'El carrito de productos es requerido' })
  @ValidateNested({ each: true })
  @Type(() => CreateProductDto)
  products: CreateProductDto[];
}
