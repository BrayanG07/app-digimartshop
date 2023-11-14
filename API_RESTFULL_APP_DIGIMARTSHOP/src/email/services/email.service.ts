import { Injectable } from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer';
import { EmailParameters } from '../interfaces/email-parameters.interface';

@Injectable()
export class EmailService {
  constructor(private mailerService: MailerService) {}

  sendEmail(parameters: EmailParameters): void {
    const { to, subject, template, context } = parameters;
    this.mailerService.sendMail({ to, subject, context, template });
  }
}
