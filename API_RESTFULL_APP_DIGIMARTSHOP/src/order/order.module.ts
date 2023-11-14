import { Module } from '@nestjs/common';
import { OrderService } from './order.service';
import { OrderController } from './order.controller';
import { UsersModule } from '../users/users.module';
import { Order } from './entities/order.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { OrderDetail } from './entities/orderDetail.entity';
import { PixelpayModule } from '../pixelpay/pixelpay.module';
import { ProductsModule } from 'src/products/products.module';
import { Stock } from '../products/entities/stock.entity';
import { ConfigModule } from '@nestjs/config';

@Module({
  controllers: [OrderController],
  providers: [OrderService],
  imports: [
    ConfigModule,
    TypeOrmModule.forFeature([Order, OrderDetail, Stock]),
    UsersModule,
    PixelpayModule,
    ProductsModule,
  ],
})
export class OrderModule {}
