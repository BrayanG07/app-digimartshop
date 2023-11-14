import {
  createParamDecorator,
  ExecutionContext,
  InternalServerErrorException,
} from '@nestjs/common';
import { UserRequest } from '../interfaces';

/**
 * ? Este decorador sirve para obtener el contenido del token (Payload) y se invoca en los controllers.
 */
export const GetUserToken = createParamDecorator(
  // ? data = contiene todos los parametros que se envien al decorador, por lo general son datos especificos que se solicitan
  (data: keyof UserRequest, ctx: ExecutionContext) => {
    const req = ctx.switchToHttp().getRequest(); // Obtenemos la request
    const user = req.user;

    if (!user)
      throw new InternalServerErrorException('User not found (request)');

    return !data ? user : user[data];
  },
);
