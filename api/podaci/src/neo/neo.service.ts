import { Injectable } from '@nestjs/common';
const neo4j = require('neo4j-driver')
import { Session, Driver } from 'neo4j-driver';

@Injectable()
export class NeoService {
    private neo: Driver;

    constructor() {
        this.neo = neo4j.driver(
            // 'neo4j://localhost:7687',
            'bolt://localhost:7687',
            neo4j.auth.basic('neo4j', 'neo4j1')
        );
    }

    getSession(): any {
        return this.neo.session();
    }
}
