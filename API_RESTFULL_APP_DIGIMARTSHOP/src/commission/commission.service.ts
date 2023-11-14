import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Not, Repository } from 'typeorm';
import { Commission } from './entities';

@Injectable()
export class CommissionService {
  constructor(
    @InjectRepository(Commission)
    private readonly commissionRepository: Repository<Commission>,
  ) {}

  async findCommissionByUserId(idUser: string) {
    const totalDirect = await this.findTotalCommissionDirect(idUser);
    const totalInvited = await this.findTotalCommissionInvited(idUser);

    return {
      totalDirect,
      totalInvited,
      total: +(totalDirect + totalInvited).toFixed(2),
    };
  }

  async findTotalCommissionDirect(idUser: string) {
    const commissionTotals = await this.commissionRepository.find({
      select: { idCommission: true, totalCommission: true },
      where: { userReceiving: { idUser }, userGenerating: { idUser } },
    });

    const totalDirect = commissionTotals.reduce(
      (accumulator: number, commission) =>
        Number(accumulator) + Number(commission.totalCommission),
      0,
    );

    return totalDirect ?? 0;
  }

  async findTotalCommissionInvited(idUser: string) {
    const commissionTotals = await this.commissionRepository.find({
      select: { idCommission: true, totalCommission: true },
      where: {
        userReceiving: { idUser },
        userGenerating: { idUser: Not(idUser) },
      },
    });

    const totalInvited = commissionTotals.reduce(
      (accumulator: number, commission) =>
        Number(accumulator) + Number(commission.totalCommission),
      0,
    );

    return totalInvited ?? 0;
  }
}
