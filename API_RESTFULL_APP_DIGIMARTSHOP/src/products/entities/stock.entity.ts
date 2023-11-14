import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { BaseEntity } from '../../config/base.entity';
import { Product } from './product.entity';
import { STATUS_STOCK } from '../../constants/status/status.stock';
import { Supermarket } from '../../supermarket/entities/supermarket.entity';

@Entity({ name: 'dm_stock' })
export class Stock extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  idStock: string;

  @Column({ type: 'int' })
  stock: number;

  @Column({
    type: 'enum',
    enum: STATUS_STOCK,
    default: STATUS_STOCK.ACTIVE,
  })
  status: STATUS_STOCK;

  @ManyToOne(() => Product, (product) => product.stock)
  @JoinColumn({ name: 'id_product' })
  product: Product;

  @ManyToOne(() => Supermarket, (supermarket) => supermarket.stock)
  @JoinColumn({ name: 'id_supermarket' })
  supermarket: Supermarket;
}
