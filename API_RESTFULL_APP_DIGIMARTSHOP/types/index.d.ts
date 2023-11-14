// * index.d.ts   -> la .d. significa que es un archivo de declaracion.
// ? Gracias a que proccess.env es de tipo NodeJS.ProcessEnv esta clase ayuda a declarar
// ? nuestras propias variables de entorno en las enviroments

declare namespace NodeJS {
  interface ProcessEnv {
    PORT: number;
    DB_HOST: string;
    DB_PORT: number;
    DB_USER: string;
    DB_PASSWORD: string;
    DB_NAME: string;
    HASH_SALT: number;
    JWT_SECRET: string;
  }
}
