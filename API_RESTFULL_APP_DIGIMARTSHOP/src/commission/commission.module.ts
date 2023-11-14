import { Module } from '@nestjs/common';
import { CommissionService } from './commission.service';
import { CommissionController } from './commission.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Commission } from './entities';

@Module({
  controllers: [CommissionController],
  providers: [CommissionService],
  imports: [TypeOrmModule.forFeature([Commission])],
})
export class CommissionModule {}
