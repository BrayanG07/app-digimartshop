<h2 align="center">
  REST API DigimartShop
</h2>


## Description

[Nest](https://github.com/nestjs/nest) framework TypeScript starter repository.

## Installation
1. Si aun no tienes instalada la CLI de Nest JS, entonces ejecuta el siguiente comando:
```
npm i -g @nestjs/cli
```

2. Instalar las dependencias
```bash
yarn install
```

3. Crear el archivo .env y llenarlo, importante que el nombre de la base de datos debe coincidir con el nombre de base de datos del archivo ```API_RESTFULL_APP_DIGIMARTSHOP\db\init.sql```
```
cp .env.develop .env
```

5. Ejecutar el archivo de docker
```bash
# Window
docker-compose up

# Linux
docker compose up
```

4. Ejecutar las migraciones
```
yarn m:run
```

5. Ejecutar el proyecto
```
yarn start:dev
```

6. Ejecutar el seed para que la base de datos este llena con los requerimientos necesarios de uso de la aplicacion, ejecuta el siguiente endpoint de tipo GET.
```
METHOD: GET

http://localhost:3069/api/v1/seed
```

8. Listooo.

## Running the app

```bash
# development
yarn run start

# watch mode
yarn run start:dev

# production mode
yarn run start:prod
```

## Test

```bash
# unit tests
yarn run test

# e2e tests
yarn run test:e2e

# test coverage
yarn run test:cov
```

## Stay in touch
- Author - Brayan Alvarez
