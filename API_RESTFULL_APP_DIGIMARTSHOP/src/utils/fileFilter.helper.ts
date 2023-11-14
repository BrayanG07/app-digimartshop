import { Request } from 'express';
import { BadRequestException } from '@nestjs/common';

export const fileFilter = (
  req: Request,
  file: Express.Multer.File,
  // eslint-disable-next-line @typescript-eslint/ban-types
  callback: Function,
) => {
  if (!file) return callback(new BadRequestException('File is empty'), false);

  const fileExtension = file.originalname.split('.');
  const validExtensions = ['jpg', 'png', 'jpeg', 'gif'];

  if (validExtensions.includes(fileExtension[fileExtension.length - 1]))
    return callback(null, true);

  callback(new BadRequestException('Extension de archivo no valida.'), false);
};
