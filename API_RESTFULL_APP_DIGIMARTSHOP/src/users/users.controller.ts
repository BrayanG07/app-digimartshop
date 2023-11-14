import {
  Controller,
  Get,
  Body,
  Patch,
  Param,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  ParseUUIDPipe,
  HttpStatus,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { FileInterceptor } from '@nestjs/platform-express';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { fileFilter } from '../utils/fileFilter.helper';
import { UpdateLocationDeliveryDto } from './dto';

@Controller('users')
@UseGuards(AuthGuard())
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  findAll() {
    return this.usersService.findAll();
  }

  @Patch(':id')
  @UseInterceptors(
    FileInterceptor('image', {
      fileFilter: fileFilter,
      limits: { fileSize: 1000000 },
    }),
  )
  async update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateUserDto: UpdateUserDto,
    @UploadedFile() image: Express.Multer.File,
  ) {
    const response = await this.usersService.update(id, updateUserDto, image);

    return { data: { ...response } };
  }

  @Get('guest-users/:idUser')
  async guestUsersInvited(@Param('idUser', ParseUUIDPipe) id: string) {
    return await this.usersService.guestUsersInvited(id);
  }

  @Patch('location-delivery/:idUser')
  async updateLocationDelivery(
    @Param(
      'idUser',
      new ParseUUIDPipe({ errorHttpStatusCode: HttpStatus.NOT_ACCEPTABLE }),
    )
    idUser: string,
    @Body() updateLocation: UpdateLocationDeliveryDto,
  ) {
    return await this.usersService.updateLocationDelivery(
      idUser,
      updateLocation,
    );
  }
}
