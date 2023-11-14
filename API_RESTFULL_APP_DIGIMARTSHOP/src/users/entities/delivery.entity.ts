import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { BaseEntity } from '../../config/base.entity';
import { User } from './user.entity';
import { Supermarket } from '../../supermarket/entities/supermarket.entity';
import { STATUS_DELIVERY } from '../../constants/delivery.constants';
import { Order } from '../../order/entities/order.entity';

@Entity('dm_delivery')
export class Delivery extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  idDelivery: string;

  @Column('nvarchar', { nullable: true })
  latitude: string;

  @Column('varchar', { nullable: true })
  longitude: string;

  @Column('enum', { enum: STATUS_DELIVERY, default: STATUS_DELIVERY.FREE })
  status: STATUS_DELIVERY;

  @OneToOne(() => User, (user) => user.delivery)
  @JoinColumn({ name: 'id_user' })
  user: User;

  @OneToMany(() => Order, (order) => order.userDelivery)
  deliveryOrder: Order[];

  @ManyToOne(() => Supermarket, (supermarket) => supermarket.deliveries)
  @JoinColumn({ name: 'id_supermarket' })
  supermarket: Supermarket;
}
