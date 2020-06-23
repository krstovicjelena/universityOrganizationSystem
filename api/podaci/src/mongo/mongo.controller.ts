import { Controller, Get, Param } from '@nestjs/common';
import { MongoService } from './mongo.service';


@Controller('mongo')
export class MongoController {
    constructor(
        private readonly mongo: MongoService,
        ) {

         }

    @Get('transform1:id/')
    transform1(@Param('id') id: string ) : string{
        let bool = this.mongo.transform1(id);
        if(bool){
            return "{type: 'success'}";
        }
        return "{type: 'false'}"; 
        
    }

    @Get('transform2')
    transform2(){
        
    }

    @Get('transform3')
    transform3(){
        
    }

}
