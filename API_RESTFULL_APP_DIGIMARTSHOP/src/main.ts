import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  const apiVersion: string = 'api/v1';
  const port: number = configService.get('PORT');

  app.setGlobalPrefix(apiVersion);

  // Configuration Pipes
  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      whitelist: true,
      forbidNonWhitelisted: false, // Si se establece en true, en lugar de quitar las propiedades que no están en la lista blanca, el validador generará una excepción.
    }),
  );

  await app.listen(port);
}

bootstrap();
