import {
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  UseGuards,
} from '@nestjs/common';
import { SupermarketService } from './supermarket.service';
import { AuthGuard } from '@nestjs/passport';

@Controller('supermarket')
@UseGuards(AuthGuard())
export class SupermarketController {
  constructor(private readonly supermarketService: SupermarketService) {}
  @Get('departments')
  async findAll() {
    return await this.supermarketService.findAllDepartmentAndSupermarket();
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.supermarketService.findOne(id);
  }
}
