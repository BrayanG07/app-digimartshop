import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { BaseEntity } from '../../config/base.entity';
import { STATUS_SUPERMARKET } from '../../constants/status/status.supermarket';
import { Department } from './department.entity';
import { Stock } from '../../products/entities/stock.entity';
import { Order } from '../../order/entities/order.entity';
import { Delivery } from '../../users/entities/delivery.entity';

@Entity({ name: 'dm_supermarket' })
export class Supermarket extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  idSupermarket: string;

  @Column({ type: 'varchar', length: 100 })
  name: string;

  @Column({ type: 'varchar', length: 80 })
  latitude: string;

  @Column({ type: 'varchar', length: 80 })
  longitude: string;

  @Column({
    type: 'enum',
    enum: STATUS_SUPERMARKET,
    default: STATUS_SUPERMARKET.ACTIVE,
  })
  status: STATUS_SUPERMARKET;

  @ManyToOne(() => Department, (department) => department.supermarket)
  @JoinColumn({ name: 'id_department' })
  department: Department;

  @OneToMany(() => Stock, (stock) => stock.supermarket)
  stock: Stock[];

  @OneToMany(() => Order, (order) => order.supermarket)
  order: Order[];

  @OneToMany(() => Delivery, (delivery) => delivery.supermarket)
  deliveries: Delivery[];
}
