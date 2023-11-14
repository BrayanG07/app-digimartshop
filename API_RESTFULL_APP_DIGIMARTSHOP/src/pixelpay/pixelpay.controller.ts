import { Controller } from '@nestjs/common';
import { PixelpayService } from './pixelpay.service';

@Controller('pixelpay')
export class PixelpayController {
  constructor(private readonly pixelpayService: PixelpayService) {}
}
