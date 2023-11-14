import { BaseEntity } from '../../config/base.entity';
import { Supermarket } from '../../supermarket/entities/supermarket.entity';
import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { STATUS_ORDER } from '../../constants/status/status.order';
import { OrderDetail } from './orderDetail.entity';
import { PAYMENT_TYPE } from '../../constants/type.payment';
import { Delivery } from '../../users/entities/delivery.entity';
import { Commission } from '../../commission/entities/commission.entity';

@Entity({ name: 'dm_order' })
export class Order extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  idOrder: string;

  @Column()
  total: number;

  @Column()
  totalDiscount: number;

  @Column()
  totalIsv: number;

  @Column({
    type: 'enum',
    enum: PAYMENT_TYPE,
    default: PAYMENT_TYPE.CREDIT_DEBIT_CARD,
  })
  paymentType: string;

  @Column({ length: 20 })
  start_number_cai: string;

  @Column({ length: 20 })
  end_number_cai: string;

  @Column({ length: 20 })
  vaucher_number: string;

  @Column({ length: 128, default: 'Sin comentarios', nullable: true })
  comment: string;

  @Column({ length: 30 })
  latitude: string;

  @Column({ length: 30 })
  longitude: string;

  @Column({ type: 'varchar', length: 200 })
  address: string;

  @Column({ type: 'varchar', length: 255 })
  addressDetail: string;

  @Column({ type: 'decimal', nullable: true, precision: 10, scale: 2 })
  moneyToPay: number;

  @Column({ type: 'enum', enum: STATUS_ORDER, default: STATUS_ORDER.PREPARING })
  status: string;

  // Estas son los id de las otras tablas
  @ManyToOne(() => Supermarket, (supermarket) => supermarket.order)
  @JoinColumn({ name: 'id_supermarket' })
  supermarket: Supermarket;

  @ManyToOne(() => User, (user) => user.order)
  @JoinColumn({ name: 'id_user' })
  user: User;

  @ManyToOne(() => Delivery, (delivery) => delivery.deliveryOrder)
  @JoinColumn({ name: 'id_delivery' })
  userDelivery: Delivery;

  // Estas son las relaciones de las otras tablas
  @OneToMany(() => OrderDetail, (orderDetail) => orderDetail.order)
  orderDetail: OrderDetail[];

  @OneToMany(() => Commission, (commission) => commission.order)
  commission: Commission;
}
