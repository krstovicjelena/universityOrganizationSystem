import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors(); // Dopusti zahteve sa drugih domena i portova u odnosu na ovaj gde je api
  await app.listen(8080);
}
bootstrap();
