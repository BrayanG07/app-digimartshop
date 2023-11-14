import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { BaseEntity } from '../../config/base.entity';
import { STATUS_DEPARTMENT } from '../../constants/status/status.department';
import { Supermarket } from './supermarket.entity';

@Entity({ name: 'dm_department' })
export class Department extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  idDepartment: string;

  @Column({ type: 'varchar', length: 100 })
  name: string;

  @Column({ length: 255, nullable: true })
  description: string;

  @Column({
    type: 'enum',
    enum: STATUS_DEPARTMENT,
    default: STATUS_DEPARTMENT.ACTIVE,
  })
  status: STATUS_DEPARTMENT;

  @OneToMany(() => Supermarket, (supermarket) => supermarket.department)
  supermarket: Supermarket[];
}
