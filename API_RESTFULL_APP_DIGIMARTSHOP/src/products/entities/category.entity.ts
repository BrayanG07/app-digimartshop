import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { BaseEntity } from '../../config/base.entity';
import { STATUS_CATEGORY } from '../../constants/status/status.category';
import { Product } from './product.entity';

@Entity({ name: 'dm_category' })
export class Category extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  idCategory: string;

  @Column({ type: 'varchar', length: 100 })
  name: string;

  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  discount: number;

  @Column('varchar', { length: 150, nullable: true })
  image: string;

  @Column({ length: 255, nullable: true })
  description: string;

  @Column({
    type: 'enum',
    enum: STATUS_CATEGORY,
    default: STATUS_CATEGORY.ACTIVE,
  })
  status: STATUS_CATEGORY;

  @OneToMany(() => Product, (product) => product.category)
  product?: Product;
}
