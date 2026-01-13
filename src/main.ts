import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // Enable CORS
  app.enableCors();

  // API prefix
  app.setGlobalPrefix('api/v1');

  // Swagger setup
  const config = new DocumentBuilder()
    .setTitle('Nizron Marketplace API')
    .setDescription('B2B & B2C E-Commerce Marketplace API')
    .setVersion('1.0')
    .addTag('Users', 'User management endpoints')
    .addTag('Companies', 'B2B company management')
    .addTag('Categories', 'Product categories')
    .addTag('Listings', 'Product listings')
    .addTag('Orders', 'Order management')
    .addTag('Payments', 'Payment processing')
    .addTag('Shipping', 'Shipping management')
    .addTag('Disputes', 'Dispute resolution')
    .addTag('Reviews', 'Reviews and ratings')
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port);

  console.log(`Nizron Marketplace API running on: http://localhost:${port}`);
  console.log(`Swagger UI available at: http://localhost:${port}/api`);
}

bootstrap();