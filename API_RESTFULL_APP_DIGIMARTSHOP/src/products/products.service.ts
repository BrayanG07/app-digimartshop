import { Injectable, NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Category } from './entities/category.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Product } from './entities/product.entity';
import { arraySeedProducts } from './data/product-seed';

@Injectable()
export class ProductsService {
  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
  ) {}

  async seedProducts() {
    try {
      for (const iterator of arraySeedProducts) {
        await this.productRepository.save({ ...iterator });
      }
    } catch (error) {
      // console.log({ error });
    }
  }

  async finAllProductsBySupermarket(idSupermarket: string, idCategory: string) {
    const products = await this.productRepository.find({
      select: {
        idProduct: true,
        name: true,
        description: true,
        price: true,
        image: true,
        stock: { idStock: true, stock: true },
      },
      relations: { stock: true },
      where: {
        stock: { supermarket: { idSupermarket } },
        category: { idCategory },
      },
    });

    return products;
  }

  async findAllCategories() {
    return await this.categoryRepository.find({
      select: {
        idCategory: true,
        name: true,
        description: true,
        image: true,
      },
      order: {
        name: 'ASC',
      },
    });
  }

  async findOne(id: string) {
    const product = await this.productRepository.findOne({
      where: {
        idProduct: id,
      },
    });

    if (!product) {
      throw new NotFoundException(`Product with id ${id} not found`);
    }

    return product;
  }
}
