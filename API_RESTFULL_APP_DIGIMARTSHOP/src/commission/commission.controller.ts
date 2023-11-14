import { Controller, Get, Param, ParseUUIDPipe } from '@nestjs/common';
import { CommissionService } from './commission.service';

@Controller('commission')
export class CommissionController {
  constructor(private readonly commissionService: CommissionService) {}

  @Get('/:idUser')
  async findCommissionByUserId(@Param('idUser', ParseUUIDPipe) idUser: string) {
    return await this.commissionService.findCommissionByUserId(idUser);
  }
}
