import { env } from './config/env';
import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as compression from 'compression';
import helmet from 'helmet';
import { AppModule } from './app.module';
import { AllExceptionsFilter } from './common/filters/all-exceptions.filter';

// Les montants sont des BigInt (entiers) en base ; ils sont sérialisés en nombre JSON.
// Les montants en FCFA restent très en dessous de Number.MAX_SAFE_INTEGER.
(BigInt.prototype as unknown as { toJSON: () => number }).toJSON = function (this: bigint) {
  return Number(this);
};

async function bootstrap() {
  // rawBody : nécessaire pour vérifier la signature des webhooks de paiement.
  const app = await NestFactory.create<NestExpressApplication>(AppModule, { rawBody: true });

  app.set('trust proxy', 1);
  app.use(helmet());
  app.use(compression());
  app.useGlobalFilters(new AllExceptionsFilter());
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
      transformOptions: { enableImplicitConversion: true },
    }),
  );

  app.enableCors({
    origin: env.isProd ? env.corsOrigins : true,
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    allowedHeaders: 'Content-Type,Authorization,Idempotency-Key,Accept-Language',
  });

  if (!env.isProd) {
    const config = new DocumentBuilder()
      .setTitle('UniParent AFRAM — API')
      .setDescription('API de suivi de la vie universitaire (parents, étudiants, administration)')
      .setVersion('1.0')
      .addBearerAuth()
      .build();
    SwaggerModule.setup('api/docs', app, SwaggerModule.createDocument(app, config));
  }

  app.enableShutdownHooks();
  await app.listen(env.port, '0.0.0.0');
  console.log(`[UniParent] API prête sur le port ${env.port} (${env.nodeEnv})`);
  if (!env.isProd) console.log(`[UniParent] Swagger : http://localhost:${env.port}/api/docs`);
}

bootstrap();
