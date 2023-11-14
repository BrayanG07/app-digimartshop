import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ServeStaticModule } from '@nestjs/serve-static';
import { CommonModule } from './common/common.module';
import { join } from 'path';
import { DataSourceConfig } from './config/data.source';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { ProductsModule } from './products/products.module';
import { SupermarketModule } from './supermarket/supermarket.module';
import { UbicationModule } from './ubication/ubication.module';
import { OrderModule } from './order/order.module';
import { PixelpayModule } from './pixelpay/pixelpay.module';
import { EmailModule } from './email/email.module';
import { CommissionModule } from './commission/commission.module';
import { WebsocketModule } from './websocket/websocket.module';
import { SeedModule } from './seed/seed.module';

@Module({
  imports: [
    ConfigModule.forRoot(),
    TypeOrmModule.forRoot({ ...DataSourceConfig }),
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'public'),
    }),
    AuthModule,
    UsersModule,
    CommonModule,
    ProductsModule,
    SupermarketModule,
    UbicationModule,
    OrderModule,
    PixelpayModule,
    EmailModule,
    CommissionModule,
    WebsocketModule,
    SeedModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
