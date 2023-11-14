import { BaseEntity } from '../../config/base.entity';
import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Order } from './order.entity';
import { Product } from '../../products/entities/product.entity';
import { STATUS_ORDER_DETAIL } from '../../constants/status/status.order.detail';

@Entity({ name: 'dm_order_detail' })
export class OrderDetail extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  idOrderDetail: string;

  @Column()
  nameProduct: string;

  @Column('varchar', { length: 150, nullable: true })
  imageProduct: string;

  @Column()
  isvProduct: number;

  @Column()
  discountProduct: number;

  @Column()
  priceProduct: number;

  @Column()
  quantity: number;

  @Column({
    type: 'enum',
    enum: STATUS_ORDER_DETAIL,
    default: STATUS_ORDER_DETAIL.ACTIVE,
  })
  status: string;

  @ManyToOne(() => Order, (order) => order.orderDetail)
  @JoinColumn({ name: 'id_order' })
  order: Order;

  @ManyToOne(() => Product, (product) => product.orderDetail)
  @JoinColumn({ name: 'id_product' })
  product: Product;
}
