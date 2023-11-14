import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Ubication } from './entities/ubication.entity';
import { PassportModule } from '@nestjs/passport';
import { UbicationService } from './ubication.service';
import { UbicationController } from './ubication.controller';
import { UsersModule } from '../users/users.module';

@Module({
  controllers: [UbicationController],
  providers: [UbicationService],
  imports: [
    TypeOrmModule.forFeature([Ubication]),
    PassportModule.register({ defaultStrategy: 'jwt' }),
    UsersModule,
  ],
})
export class UbicationModule {}
