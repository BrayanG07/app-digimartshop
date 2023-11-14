import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';
import { BaseEntity } from '../../config/base.entity';

@Entity({ name: 'dm_pixelpay_response' })
export class PixelpayResponse extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  idPixelpayResponse: string;

  @Column()
  message: string;

  @Column()
  success: boolean;

  @Column()
  code: string;

  @Column()
  textStatus: string;

  @Column()
  paymentUUID: string;
}
