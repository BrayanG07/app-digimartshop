import { PassportStrategy } from '@nestjs/passport';
import { ConfigService } from '@nestjs/config';
import { Injectable } from '@nestjs/common';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { AuthService } from '../auth.service';
import { UserRequest, JwtPayload } from '../interfaces';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    private readonly authService: AuthService,
    configService: ConfigService,
  ) {
    super({
      secretOrKey: configService.get('JWT_SECRET'),
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    });
  }

  // ? Este metodo se invoca si el JWT no ha expirado y si la firma hace match con el payload.
  async validate(payload: JwtPayload): Promise<UserRequest> {
    const { idUser } = payload;

    const userResult = await this.authService.isAuthorizedUser(idUser);

    return userResult; // * Todo lo que retornemos se agregara a la Request
  }
}
