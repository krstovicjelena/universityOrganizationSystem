import { Injectable } from '@nestjs/common';
import * as mysql from 'sync-mysql';

@Injectable()
export class DatabaseService {
    private static connection: mysql;

    constructor() {
        DatabaseService.connection = new mysql({
            host: 'localhost', user: 'root', password: '', database: 'nosql'
        }); 
    }

    query(sql: string, args: any): any {
        return DatabaseService.connection.query(sql, args);
    }
}
