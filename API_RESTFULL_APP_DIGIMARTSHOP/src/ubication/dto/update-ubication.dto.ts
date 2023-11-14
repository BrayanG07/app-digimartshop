import { PartialType } from '@nestjs/mapped-types';
import { CreateUbicationDto } from './create-ubication.dto';

export class UpdateUbicationDto extends PartialType(CreateUbicationDto) {}
