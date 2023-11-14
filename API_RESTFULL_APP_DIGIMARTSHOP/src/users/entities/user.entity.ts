import {
  Column,
  Entity,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';

import { BaseEntity } from '../../config/base.entity';
import { STATUS_USER } from '../../constants/status/status.user';
import { ROLE_USER } from '../../constants/status/role.user';
import { Ubication } from '../../ubication/entities/ubication.entity';
import { Order } from '../../order/entities/order.entity';
import { REGISTRATION_TYPE } from '../../constants/status/registration-type.user';
import { Delivery } from './delivery.entity';
import { Commission } from '../../commission/entities/commission.entity';

@Entity({ name: 'dm_users' })
export class User extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  idUser: string;

  @Column({ length: 80, nullable: true })
  firstName: string;

  @Column({ length: 80, nullable: true })
  lastName: string;

  @Column({ nullable: true, length: 20, unique: true })
  dni: string;

  @Column({ unique: true, length: 100 })
  email: string;

  @Column({ nullable: true, length: 20 })
  phone: string;

  @Column({ length: 150, nullable: true })
  image: string;

  @Column({ length: 128, select: false, nullable: true })
  password: string;

  @Column('enum', { enum: STATUS_USER, default: STATUS_USER.ACTIVE })
  status: STATUS_USER;

  @Column('enum', { enum: ROLE_USER, default: ROLE_USER.CLIENT })
  role: ROLE_USER;

  @OneToMany(() => Ubication, (ubication) => ubication.user)
  ubication: Ubication[];

  @OneToMany(() => Order, (order) => order.supermarket)
  order: Order[];

  // Aquí definimos la relación con el usuario que invitó a este usuario
  @ManyToOne(() => User, (user) => user.invitedUsers)
  parentUser: User;

  // Aquí definimos la relación con los usuarios que este usuario ha invitado
  @OneToMany(() => User, (user) => user.parentUser)
  invitedUsers: User[];

  @Column('enum', { enum: REGISTRATION_TYPE })
  registrationType: REGISTRATION_TYPE;

  // ? RELACIONES PARA LAS COMISIONES DEL USUARIO
  @OneToMany(() => Commission, (commission) => commission.userGenerating)
  commissionGenerating: Commission[];

  // * RELACION CON LAS COMISIONES GENERADAS POR DIGIMARTBOX
  @OneToMany(() => Commission, (commission) => commission.userReceiving)
  commissionReceiving: Commission[];

  @OneToOne(() => Delivery, (delivery) => delivery.user)
  delivery: Delivery;
}
