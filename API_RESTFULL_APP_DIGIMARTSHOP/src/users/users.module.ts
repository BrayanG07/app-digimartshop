import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PassportModule } from '@nestjs/passport';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { User } from './entities/user.entity';
import { CommonModule } from '../common/common.module';
import { Delivery } from './entities/delivery.entity';

@Module({
  controllers: [UsersController],
  providers: [UsersService],
  imports: [
    TypeOrmModule.forFeature([User, Delivery]),
    PassportModule.register({ defaultStrategy: 'jwt' }),
    ConfigModule,
    CommonModule,
  ],
  exports: [UsersService],
})
export class UsersModule {}
