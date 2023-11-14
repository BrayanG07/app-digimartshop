import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { BaseEntity } from '../../config/base.entity';
import { Category } from './category.entity';
import { Stock } from './stock.entity';
import { OrderDetail } from '../../order/entities/orderDetail.entity';

@Entity({ name: 'dm_product' })
export class Product extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  idProduct: string;

  @Column({ type: 'varchar', length: 100 })
  name: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  price: number;

  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  discount: number;

  @Column('varchar', { length: 150, nullable: true })
  image: string;

  @Column({ length: 255, nullable: true })
  description: string;

  @ManyToOne(() => Category, (category) => category.product)
  @JoinColumn({ name: 'id_category' })
  category: Category;

  @OneToMany(() => Stock, (stock) => stock.product)
  stock: Stock[];

  @OneToMany(() => OrderDetail, (orderDetail) => orderDetail.product)
  orderDetail: OrderDetail[];
}
