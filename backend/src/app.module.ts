import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from '@thallesp/nestjs-better-auth';
import { auth } from './lib/auth';
import { DatabaseModule } from './database/database.module';
import { UsersModule } from './modules/users/users.module';
import { CompaniesModule } from './modules/companies/companies.module';
import { CategoriesModule } from './modules/categories/categories.module';
import { ListingsModule } from './modules/listings/listings.module';
import { OrdersModule } from './modules/orders/orders.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { ShippingModule } from './modules/shipping/shipping.module';
import { DisputesModule } from './modules/disputes/disputes.module';
import { ReviewsModule } from './modules/reviews/reviews.module';
import { ChatModule } from './modules/chat/chat.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    // Better Auth Module - provides global AuthGuard
    AuthModule.forRoot({ auth }),
    DatabaseModule,
    UsersModule,
    CompaniesModule,
    CategoriesModule,
    ListingsModule,
    OrdersModule,
    PaymentsModule,
    ShippingModule,
    DisputesModule,
    ReviewsModule,
    ChatModule,
  ],
})
export class AppModule { }
