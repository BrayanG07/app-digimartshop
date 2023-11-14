import { Controller, Post, Body, Get, Param } from '@nestjs/common';
import { AuthService } from './auth.service';
import { SignInGoogleDto, LoginUserDto, CreateUserDto } from '../users/dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  async loginUser(@Body() loginUserDto: LoginUserDto) {
    const loginResponse = await this.authService.loginUser(loginUserDto);
    return { data: { ...loginResponse } };
  }

  @Post('signin-google')
  async signInGoogle(@Body() signInGoogleDto: SignInGoogleDto) {
    const response = await this.authService.signInWithGoogle(signInGoogleDto);

    return { message: 'Inicio de sesion exitoso', data: { ...response } };
  }

  @Post()
  async create(@Body() createUserDto: CreateUserDto) {
    const userToCreate = await this.authService.createUser(createUserDto);
    return { message: 'Usuario creado correctamente', data: userToCreate };
  }

  @Get('verify-email/:email')
  async verifyEmail(@Param('email') email: string) {
    const code: string = await this.authService.verifyEmail(email);
    return {
      message: 'Código de verificación enviado correctamente',
      data: { code },
    };
  }
}
