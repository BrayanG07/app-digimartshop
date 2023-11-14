import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  UseGuards,
  ParseUUIDPipe,
} from '@nestjs/common';
import { UbicationService } from './ubication.service';
import { CreateUbicationDto } from './dto/create-ubication.dto';
import { UpdateUbicationDto } from './dto/update-ubication.dto';
import { AuthGuard } from '@nestjs/passport';

@Controller('ubication')
@UseGuards(AuthGuard())
export class UbicationController {
  constructor(private readonly ubicationService: UbicationService) {}

  @Post()
  async create(@Body() createUbicationDto: CreateUbicationDto) {
    const ubicationToCreated = await this.ubicationService.create(
      createUbicationDto,
    );
    return {
      message: 'Ubicacion creada correctamente',
      data: { ...ubicationToCreated },
    };
  }

  @Get(':idUser')
  async findAll(@Param('idUser', ParseUUIDPipe) idUser: string) {
    return await this.ubicationService.findAllByIdUser(idUser);
  }

  @Patch(':id')
  update(
    @Param('id') id: string,
    @Body() updateUbicationDto: UpdateUbicationDto,
  ) {
    return this.ubicationService.update(+id, updateUbicationDto);
  }
}
