import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SupermarketService } from './supermarket.service';
import { SupermarketController } from './supermarket.controller';
import { Supermarket } from './entities/supermarket.entity';
import { Department } from './entities/department.entity';

@Module({
  controllers: [SupermarketController],
  providers: [SupermarketService],
  imports: [
    TypeOrmModule.forFeature([Supermarket, Department]),
    PassportModule.register({ defaultStrategy: 'jwt' }),
  ],
})
export class SupermarketModule {}
