import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { PixelpayService } from './pixelpay.service';
import { PixelpayController } from './pixelpay.controller';
import { PixelpayResponse } from './entities/pixelpayResponse.entity';

@Module({
  controllers: [PixelpayController],
  providers: [PixelpayService],
  exports: [PixelpayService],
  imports: [ConfigModule, TypeOrmModule.forFeature([PixelpayResponse])],
})
export class PixelpayModule {}
