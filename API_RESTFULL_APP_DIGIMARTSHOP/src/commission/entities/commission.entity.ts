import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { BaseEntity } from '../../config/base.entity';
import { STATUS_COMMISSION } from '../../constants/status/status.commission';
import { Order } from '../../order/entities/order.entity';
import { User } from '../../users/entities/user.entity';

@Entity('commission')
export class Commission extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  idCommission: string;

  @Column('decimal', { precision: 10, scale: 2 })
  percentage: number;

  @Column('decimal', { precision: 10, scale: 2 })
  totalCommission: number;

  @Column('decimal', { precision: 10, scale: 2, default: 0 })
  totalRemaining: number;

  @Column('enum', {
    enum: STATUS_COMMISSION,
    default: STATUS_COMMISSION.EARNEAD,
  })
  statusCommission: STATUS_COMMISSION;

  // ? RELACIONES
  @ManyToOne(() => Order, (order) => order.commission)
  @JoinColumn({ name: 'id_order' })
  order: Order;

  @ManyToOne(() => User, (user) => user.commissionGenerating)
  @JoinColumn({ name: 'id_user_generating' })
  userGenerating: User;

  @ManyToOne(() => User, (user) => user.commissionReceiving)
  @JoinColumn({ name: 'id_user_receiving' })
  userReceiving: User;
}
