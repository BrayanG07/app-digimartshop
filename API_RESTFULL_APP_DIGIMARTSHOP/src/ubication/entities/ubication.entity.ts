import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { BaseEntity } from '../../config/base.entity';
import { STATUS_UBICATION } from '../../constants/status/status.ubication';
import { User } from '../../users/entities/user.entity';

@Entity({ name: 'dm_ubication' })
export class Ubication extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  idUbication: string;

  @Column({ type: 'varchar', length: 200 })
  address: string;

  @Column({ type: 'varchar', length: 200 })
  neighborhood: string;

  @Column({ type: 'varchar', length: 255 })
  refPoint: string;

  @Column({ type: 'varchar', length: 20 })
  latitude: string;

  @Column({ type: 'varchar', length: 20 })
  longitude: string;

  @Column({
    type: 'enum',
    enum: STATUS_UBICATION,
    default: STATUS_UBICATION.ACTIVE,
  })
  status: STATUS_UBICATION;

  @ManyToOne(() => User, (user) => user.ubication)
  @JoinColumn({ name: 'id_user' })
  user: User;
}
