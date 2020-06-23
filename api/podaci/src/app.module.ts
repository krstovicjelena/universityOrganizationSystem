import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { DatabaseService } from './database/database.service';
import { MongoService } from './mongo/mongo.service';
import { NeoService } from './neo/neo.service';

@Module({
  imports: [],
  controllers: [AppController],
  providers: [DatabaseService, MongoService, NeoService],
})
export class AppModule {}
