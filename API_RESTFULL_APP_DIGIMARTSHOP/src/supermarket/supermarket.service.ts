import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Department } from './entities/department.entity';
import { STATUS_SUPERMARKET } from '../constants/status/status.supermarket';

@Injectable()
export class SupermarketService {
  constructor(
    @InjectRepository(Department)
    private readonly departmentRepository: Repository<Department>,
  ) {}

  async findAllDepartmentAndSupermarket() {
    return await this.departmentRepository.find({
      select: {
        idDepartment: true,
        name: true,
        supermarket: {
          idSupermarket: true,
          name: true,
          latitude: true,
          longitude: true,
        },
      },
      relations: {
        supermarket: true,
      },
      order: {
        name: 'ASC',
      },
      where: {
        supermarket: { status: STATUS_SUPERMARKET.ACTIVE },
      },
    });
  }

  findOne(id: string) {
    return `This action returns a #${id} supermarket`;
  }
}
