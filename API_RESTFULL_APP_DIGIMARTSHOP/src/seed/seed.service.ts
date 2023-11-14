import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { Department } from '../supermarket/entities/department.entity';
import { Delivery } from '../users/entities/delivery.entity';
import { Product } from '../products/entities/product.entity';
import { Supermarket } from '../supermarket/entities/supermarket.entity';
import { Stock } from '../products/entities/stock.entity';
import { Category } from '../products/entities/category.entity';
import { DataSource } from 'typeorm';
import { departments } from './data/department.data';
import { supermarkets } from './data/supermarket.data';
import { categories } from './data/category.data';
import { products } from './data/product.data';
import { stocks } from './data/stock.data';
import { User } from '../users/entities/user.entity';
import { users } from './data/user.data';
import { deliveries } from './data/delivery.data';

@Injectable()
export class SeedService {
  constructor(private readonly dataSource: DataSource) {}

  async runSeed() {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      await queryRunner.manager.getRepository(Department).save(departments);
      await queryRunner.manager.getRepository(Supermarket).save(supermarkets);
      await queryRunner.manager.getRepository(Category).save(categories);
      await queryRunner.manager.getRepository(Product).save(products);
      await queryRunner.manager.getRepository(Stock).save(stocks);
      await queryRunner.manager.getRepository(User).save(users);
      await queryRunner.manager.getRepository(Delivery).save(deliveries);

      await queryRunner.commitTransaction();

      return { message: 'Seed executed successfully.' };
    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw new InternalServerErrorException(
        `Se produjo un error al ejecutar el seed ${error}.`,
      );
    } finally {
      await queryRunner.release();
    }
  }
}
