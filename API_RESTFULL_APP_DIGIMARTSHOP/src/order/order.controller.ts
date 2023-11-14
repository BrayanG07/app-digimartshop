import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  ParseUUIDPipe,
  BadRequestException,
} from '@nestjs/common';
import { OrderService } from './order.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { STATUS_ORDER } from '../constants/status/status.order';

@Controller('order')
export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  @Post()
  async create(@Body() createOrderDto: CreateOrderDto) {
    return await this.orderService.create(createOrderDto);
  }

  @Get()
  async findAll() {
    return await this.orderService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return await this.orderService.findOne(id);
  }

  // Funciones de consultas de ordenes nuevas

  // Funcion que lista todas las ordenes de un usuario cliente
  @Get('all-orders-pending/:idUser')
  async findAllOrders(@Param('idUser') idUser: string) {
    return await this.orderService.getAllOrdersByUser(idUser);
  }

  // Funcion que lista todas las ordenes de un usuario cliente por un status
  @Get('all-orders/:idUser/:status')
  async findAllOrdersAndStatus(
    @Param('idUser') idUser: string,
    @Param('status') status: string,
  ) {
    status = status.toUpperCase();

    if (!Object.values(STATUS_ORDER).includes(status as STATUS_ORDER)) {
      throw new BadRequestException('El status no existe');
    }
    return await this.orderService.getAllOrdersByUserAndStatus(idUser, status);
  }

  // Funcion que lista todas las ordenes de un repartidor completadas
  @Get('/completed/:idUser')
  async findAllOrdersCompleted(@Param('idUser') idUser: string) {
    return await this.orderService.getAllOrdersCompleted(idUser);
  }

  // Funcion que lista todas las ordenes de un repartidor que estan sin completadas
  @Get('/delivered/:idUser')
  async findAllOrdersSend(@Param('idUser') idUser: string) {
    return await this.orderService.getAllOrdersSend(idUser);
  }

  /*************************************************************************/
  // Funcion para cambiar la status de una orden a prepando
  @Get('prepare/:idOrder')
  async changeToPreparing(@Param('idOrder', ParseUUIDPipe) idOrder: string) {
    return await this.orderService.changeToPreparing(idOrder);
  }

  // Funcion para finalizar una orden, EJECUTAR ESTE CUANDO EL REPARTIDOR CLICK EN FINALIZAR PEDIDO
  @Get('end-orden/:idOrder')
  async endOrder(@Param('idOrder', ParseUUIDPipe) idOrder: string) {
    const resp = await this.orderService.deliverOrder(idOrder);

    this.orderService.assignDelivery();

    return resp;
  }

  // Funcion para cambiar la status de una orden a enviada
  @Get('send/:idOrder')
  async changeToSend(@Param('idOrder', ParseUUIDPipe) idOrder: string) {
    return await this.orderService.changeToSend(idOrder);
  }

  //Funcion para cancelar una orden
  @Get('cancel/:idOrder')
  async cancelOrder(@Param('idOrder', ParseUUIDPipe) idOrder: string) {
    const resp = await this.orderService.cancelOrder(idOrder);

    this.orderService.assignDelivery();

    return resp;
  }
}
