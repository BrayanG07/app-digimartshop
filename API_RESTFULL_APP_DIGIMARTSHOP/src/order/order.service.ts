import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { DataSource, In, Not, QueryRunner, Repository } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import { InjectDataSource, InjectRepository } from '@nestjs/typeorm';
import { CreateOrderDto } from './dto/create-order.dto';
import { UsersService } from '../users/users.service';
import { Order } from './entities/order.entity';
import { OrderDetail } from './entities/orderDetail.entity';
import { PixelpayService } from '../pixelpay/pixelpay.service';
import { ProductsService } from '../products/products.service';
import { PixelPayBody } from '../pixelpay/interface/pixelpayBody.interface';
import { Stock } from '../products/entities/stock.entity';
import { PAYMENT_TYPE } from '../constants/type.payment';
import { STATUS_ORDER } from '../constants/status/status.order';
import { STATUS_DELIVERY } from 'src/constants';
import { Delivery } from '../users/entities/delivery.entity';
import { User } from '../users/entities/user.entity';
import { Commission } from '../commission/entities/commission.entity';

@Injectable()
export class OrderService {
  constructor(
    private readonly userService: UsersService,
    private readonly pixelpayService: PixelpayService,
    private readonly productService: ProductsService,
    private readonly configService: ConfigService,
    @InjectRepository(Order)
    private readonly orderRepository: Repository<Order>,
    @InjectDataSource()
    private dataSource: DataSource,
  ) {}

  async create(createOrderDto: CreateOrderDto) {
    // Verifico que el usuario exista
    const user = await this.userService.findOne(createOrderDto.idUser);

    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      let total = 0;
      let totalDiscount = 0;
      let totalIsv = 0;

      const isv = 15; // Este impuesto lo tomariamos desde la base de datos

      const arrayOrderDetail = [];

      // En la teoria este arreglo nunca va a estar vacio ni con otro formato
      for (const element of createOrderDto.products) {
        const product = await this.productService.findOne(element.idProduct);

        total += product.price * element.quantity;

        totalDiscount += product.discount * element.quantity;

        totalIsv += product.price * element.quantity * (isv / 100);

        const orderDetail = {
          nameProduct: product.name,
          imageProduct: product.image,
          isvProduct: product.price * element.quantity * (isv / 100),
          discountProduct: product.discount * element.quantity,
          priceProduct: product.price * element.quantity,
          quantity: element.quantity,
          product: product,
        };

        // bajo la cantidad de stock del producto'

        const stock = await queryRunner.manager
          .getRepository(Stock)
          .findOne({ where: { idStock: element.idStock } });

        if (stock.stock < element.quantity) {
          throw new InternalServerErrorException('Stock insuficiente');
        }

        await queryRunner.manager
          .getRepository(Stock)
          .decrement({ idStock: element.idStock }, 'stock', element.quantity);

        arrayOrderDetail.push(orderDetail);
      }

      const delivers = await queryRunner.manager.getRepository(Delivery).find({
        select: { idDelivery: true },
        where: {
          status: STATUS_DELIVERY.FREE,
          supermarket: {
            idSupermarket: createOrderDto.products[0].idSupermarket,
          },
        },
      });

      // En esto haria un subtotal donde no va nada solo el precio por la cantidad
      // y luego el total final donde se suma y resta todo

      let orderTemp = {
        total,
        totalDiscount,
        totalIsv,
        paymentType: createOrderDto.paymentType,
        comment: createOrderDto.comment,
        latitude: createOrderDto.latitude,
        longitude: createOrderDto.longitude,
        address: createOrderDto.address,
        addressDetail: createOrderDto.addressDetail,
        moneyToPay: createOrderDto.moneyToPay,
        supermarket: {
          idSupermarket: createOrderDto.products[0].idSupermarket,
        },
        user,
        userDelivery: null,
        start_number_cai: '',
        end_number_cai: '',
        vaucher_number: '',
        status: STATUS_ORDER.PREPARING,
      };

      if (delivers.length > 0) {
        orderTemp = {
          ...orderTemp,
          userDelivery: delivers[0],
          // status: STATUS_ORDER.PREPARING,
        };

        const isAsing = await queryRunner.manager
          .getRepository(Delivery)
          .update(
            { idDelivery: delivers[0].idDelivery },
            {
              status: STATUS_DELIVERY.OCCUPIED,
            },
          );

        if (isAsing.affected === 0) {
          throw new InternalServerErrorException(
            'Error al asignar el delivery',
          );
        }
      } else {
        orderTemp.status = STATUS_ORDER.PENDIENT;
      }

      const order = await queryRunner.manager
        .getRepository(Order)
        .save(orderTemp);

      arrayOrderDetail.map((orderDetail) => {
        orderDetail.order = order.idOrder;
        return orderDetail;
      });

      const orderDetail = await queryRunner.manager
        .getRepository(OrderDetail)
        .save(arrayOrderDetail);

      if (!order) {
        throw new InternalServerErrorException('Error al crear la orden');
      }

      // * ALMACENAR LAS COMISIONES
      await this.saveCommissions(queryRunner, { total, user, order });

      if (createOrderDto.paymentType === PAYMENT_TYPE.CREDIT_DEBIT_CARD) {
        const body: PixelPayBody = {
          customer_name: createOrderDto.cardName,
          card_number: createOrderDto.cardNumber,
          card_holder: createOrderDto.cardName,
          card_expire: `${createOrderDto.yearCard}${createOrderDto.monthCard}`, //'2512',
          card_cvv: createOrderDto.cardCvv,
          customer_email: createOrderDto.email,
          billing_address: 'Calle 1',
          billing_city: 'Sula',
          billing_country: 'HN',
          billing_state: 'HN-CR',
          billing_phone: '5581998855',
          order_id: order.idOrder,
          order_currency: 'HNL',
          // order_amount: String(total),
          order_amount: '1',
          env: 'sandbox',
          lang: 'es',
        };

        const respPixelpay = await this.pixelpayService.executePayment(body);

        if (!respPixelpay) {
          throw new InternalServerErrorException(
            'Error en la realizacion del pago',
          );
        }
      }

      await queryRunner.commitTransaction();

      //Retorno la order creada
      return {
        success: true,
        order: {
          ...order,
          orderDetail,
        },
        message: 'Orden creada correctamente',
      };
    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await queryRunner.release();
    }
  }

  async saveCommissions(
    queryRunner: QueryRunner,
    values: { total: number; user: User; order: Order },
  ) {
    const { total, user, order } = values;
    const commissionDirect = +this.configService.get('COMMISSION_DIRECT');
    const commissionInvited = +this.configService.get('COMMISSION_INVITED');

    const totalDirect = +((commissionDirect / 100) * total).toFixed(2);
    await queryRunner.manager.getRepository(Commission).save({
      percentage: commissionDirect,
      totalCommission: totalDirect,
      order,
      userGenerating: user,
      userReceiving: user,
    });

    // ? Si tiene un padre
    if (user.parentUser) {
      const totalInvited = +((commissionInvited / 100) * total).toFixed(2);
      await queryRunner.manager.getRepository(Commission).save({
        percentage: commissionInvited,
        totalCommission: totalInvited,
        order,
        userGenerating: user,
        userReceiving: user.parentUser,
      });
    }
  }

  async findAll() {
    return await this.orderRepository.find({
      relations: {
        orderDetail: true,
        userDelivery: true,
      },
    });
  }

  async findOne(id: string) {
    const order = await this.orderRepository.findOne({
      where: { idOrder: id },
      relations: {
        orderDetail: true,
        userDelivery: true,
      },
    });

    return order;
  }

  async updateUserDelivery(idOrder: string, idDelivery: string) {
    await this.findOne(idOrder);

    const user = await this.userService.findOneDelivery(idDelivery);

    const isUpdate = await this.orderRepository.update(
      { idOrder },
      { userDelivery: user.delivery },
    );

    return isUpdate;
  }

  // funciones de listado de ordenes
  async getAllOrdersByUser(idUser: string) {
    return await this.orderRepository.find({
      select: {
        userDelivery: {
          idDelivery: true,
          latitude: true,
          longitude: true,
          status: true,
          user: {
            idUser: true,
            firstName: true,
            lastName: true,
            image: true,
            phone: true,
            email: true,
          },
        },
      },
      relations: {
        orderDetail: true,
        userDelivery: { user: true },
        supermarket: true,
      },
      where: {
        user: { idUser },
        status: Not(STATUS_ORDER.DELIVERED),
      },
      order: {
        idOrder: 'ASC',
      },
    });
  }

  async getAllOrdersCompleted(idUser: string) {
    return await this.orderRepository.find({
      where: {
        userDelivery: { user: { idUser } },
        status: STATUS_ORDER.DELIVERED,
      },
      relations: {
        orderDetail: true,
        user: true,
        supermarket: true,
        userDelivery: { user: true },
      },
      order: {
        idOrder: 'ASC',
      },
    });
  }

  async getAllOrdersByUserAndStatus(idUser: string, status: string) {
    return await this.orderRepository.find({
      where: {
        user: { idUser },
        status,
      },
      relations: {
        orderDetail: true,
        userDelivery: { user: true },
        supermarket: true,
      },
      order: {
        idOrder: 'ASC',
      },
    });
  }

  async getAllOrdersSend(idUser: string) {
    return await this.orderRepository.find({
      where: {
        userDelivery: { user: { idUser } },
        status: In([STATUS_ORDER.PREPARING, STATUS_ORDER.SEND]),
      },
      relations: {
        orderDetail: true,
        user: true,
        supermarket: true,
      },
      order: {
        idOrder: 'ASC',
      },
    });
  }

  /*************************************************************************/

  // Funcion para asignar los deliverys a los ordenes
  async assignDelivery() {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const orders = await queryRunner.manager.getRepository(Order).find({
        where: {
          status: STATUS_ORDER.PENDIENT,
          userDelivery: null,
        },
        relations: {
          supermarket: true,
        },
      });

      for (const order of orders) {
        const deliverys = await queryRunner.manager
          .getRepository(Delivery)
          .findOne({
            where: {
              status: STATUS_DELIVERY.FREE,
              supermarket: {
                idSupermarket: order.supermarket.idSupermarket,
              },
            },
          });

        if (deliverys) {
          order.userDelivery = deliverys;
          order.status = STATUS_ORDER.PREPARING;
        }

        await queryRunner.manager
          .getRepository(Order)
          .update({ idOrder: order.idOrder }, order);
      }

      await queryRunner.commitTransaction();
    } catch (error) {
      await queryRunner.rollbackTransaction();

      throw error;
    } finally {
      await queryRunner.release();
    }
  }

  /*************************************************************************/

  // Dar por entregada la orden
  async deliverOrder(idOrder: string) {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    const orderExist = await this.orderRepository.findOne({
      where: { idOrder },
      relations: {
        supermarket: true,
        userDelivery: true,
      },
    });

    if (!orderExist) {
      throw new NotFoundException('Orden no encontrada');
    }

    if (orderExist.status === STATUS_ORDER.DELIVERED) {
      throw new BadRequestException('Orden ya entregada');
    }

    try {
      orderExist.status = STATUS_ORDER.DELIVERED;

      const order = await queryRunner.manager
        .getRepository(Order)
        .update({ idOrder }, orderExist);

      if (order.affected === 0) {
        throw new InternalServerErrorException('Error al finalizar la orden');
      }

      // El mismo supermarket de la orden anterior porque cuando secrea el usuario se asigna
      // a un supermarket y solo le pueden caer ordenes de alli
      const newOrderAsing = await queryRunner.manager
        .getRepository(Order)
        .findOne({
          where: {
            status: STATUS_ORDER.PENDIENT,
            userDelivery: null,
            supermarket: {
              idSupermarket: orderExist.supermarket.idSupermarket,
            },
          },
          relations: {
            supermarket: true,
          },
        });

      if (newOrderAsing) {
        newOrderAsing.userDelivery = orderExist.userDelivery;
        newOrderAsing.status = STATUS_ORDER.PREPARING;

        await queryRunner.manager
          .getRepository(Order)
          .update({ idOrder: newOrderAsing.idOrder }, newOrderAsing);
      } else {
        const user = await queryRunner.manager
          .getRepository(Delivery)
          .update(
            { idDelivery: orderExist.userDelivery.idDelivery },
            { status: STATUS_DELIVERY.FREE },
          );

        if (user.affected === 0) {
          throw new InternalServerErrorException('Error al finalizar la orden');
        }

        return orderExist;
      }

      await queryRunner.commitTransaction();

      return newOrderAsing;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await queryRunner.release();
    }
  }

  async changeToPreparing(idOrder: string) {
    const order = await this.orderRepository.findOne({
      where: { idOrder },
    });

    if (!order) {
      throw new NotFoundException('Orden no encontrada');
    }

    if (order.status === STATUS_ORDER.PREPARING) {
      throw new BadRequestException('Orden ya preparada');
    }

    return await this.orderRepository.update(
      { idOrder },
      { status: STATUS_ORDER.PREPARING },
    );
  }

  async changeToSend(idOrder: string) {
    const order = await this.orderRepository.findOne({
      where: { idOrder },
    });

    if (!order) {
      throw new NotFoundException('Orden no encontrada');
    }

    if (order.status === STATUS_ORDER.SEND) {
      throw new BadRequestException('Orden ya enviada');
    }

    return await this.orderRepository.update(
      { idOrder },
      { status: STATUS_ORDER.SEND },
    );
  }

  async cancelOrder(idOrder: string) {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    const orderExist = await this.orderRepository.findOne({
      where: { idOrder },
      relations: {
        userDelivery: true,
        supermarket: true,
      },
    });

    if (!orderExist) {
      throw new NotFoundException('Orden no encontrada');
    }

    if (orderExist.status === STATUS_ORDER.CANCELED) {
      throw new BadRequestException('Orden ya cancelada');
    }

    try {
      orderExist.status = STATUS_ORDER.CANCELED;

      const order = await queryRunner.manager
        .getRepository(Order)
        .update({ idOrder }, orderExist);

      if (orderExist.userDelivery) {
        const user = await queryRunner.manager
          .getRepository(Delivery)
          .update(
            { idDelivery: orderExist.userDelivery.idDelivery },
            { status: STATUS_DELIVERY.FREE },
          );

        if (user.affected === 0) {
          throw new InternalServerErrorException('Error al cancelar la orden');
        }
      }

      if (order.affected === 0) {
        throw new InternalServerErrorException('Error al cancelar la orden');
      }

      await queryRunner.commitTransaction();
    } catch (error) {
      await queryRunner.rollbackTransaction();
    } finally {
      await queryRunner.release();
    }

    return await this.orderRepository.update(
      { idOrder },
      { status: STATUS_ORDER.DELIVERED },
    );
  }
}
