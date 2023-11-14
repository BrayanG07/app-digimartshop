import {
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ProductsService } from './products.service';

@Controller('products')
@UseGuards(AuthGuard())
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Get()
  async findAllCategories() {
    return await this.productsService.findAllCategories();
  }

  @Get('/supermarket/:idSupermarket/:idCategory')
  async findAllProductsBySupermarket(
    @Param('idSupermarket', ParseUUIDPipe) idSupermarket: string,
    @Param('idCategory', ParseUUIDPipe) idCategory: string,
  ) {
    return await this.productsService.finAllProductsBySupermarket(
      idSupermarket,
      idCategory,
    );
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.productsService.findOne(id);
  }

  @Post('seed-product')
  async executeSeed() {
    await this.productsService.seedProducts();
    return 'Creado correctamente';
  }
}
