import { Injectable } from '@nestjs/common';
import * as mongoose from 'mongoose';
import { DatabaseService } from '../database/database.service';


@Injectable()
export class MongoService {
    private db;
    //sema prvog dokumenta
    private mongo1 = new mongoose.Schema({
        id:     String, 
        naziv:  String,
        verzija: Number,
        visoko_skolska_ustanova: [{
                naziv       : String,
                tip_naziv   : String,
                tip_vlasnistva: String,
                adresa      : String,
                www         : String,
                email       : String,
                datumOsnivanja :String
        }]
    });

    //sema drugog dokumenta
    private mongo2 = new mongoose.Schema({
            id:     String, 
            naziv:  String,
            verzija: Number,
            visoko_skolska_ustanova: [{
                naziv       : String,
                tip_naziv   : String,
                drzava_naziv: String,
                adresa      : String,
                www         : String,
                email       : String,
                datumOsnivanja :String
            }]
        
    });
//seema treceg dokument
    private mongo3 = new mongoose.Schema({
        id:     String, 
        naziv:  String,
        verzija: Number,
        visoko_skolska_ustanova: [{
            naziv       : String,
            tip_vlasnistva: String,
            drzava_naziv: String,
            adresa      : String,
            www         : String,
            email       : String,
            datumOsnivanja :String
        }]
        
    });

    private model1 = mongoose.model('doc1', this.mongo1);
    private model2 = mongoose.model('doc2', this.mongo2);
    private model3 = mongoose.model('doc3', this.mongo3);

    constructor( private mysql : DatabaseService ) {
        mongoose.connect('mongodb://localhost:27017/test', {useNewUrlParser: true});
        this.db = mongoose.connection;
        this.db.on('error', console.error.bind(console, 'connection error:'));
    }

    transform1( input : string){
        let verzija = new Date().getTime(); //uzimamo timestemp za verziju
        // ucitaj prvu tabelu iz mysql
        let results = this.mysql.query('SELECT drzava.DR_IDENTIFIKATOR AS id, drzava.DR_NAZIV as naziv FROM drzava WHERE drzava.DR_NAZIV  = ?', [input]);
        if (results.length === 0) {
            return false;
          }
          for (let element of results) {
            // nadji sve elemente sa povezanom tabelom - prodji kroz njih LOOP
            // uzimaj njihove podatke iz MySql-a i napravi listu
            let sql_q = `
            SELECT 
            visokoskolska_ustanova.VU_NAZIV as naziv,
            tipovi_ustanova.TIP_NAZIV as tip_naziv,
            vrsta_vlasnistva.VV_NAZIV as tip_vlasnistva,
            visokoskolska_ustanova.VU_ADRESA as adresa,
            visokoskolska_ustanova.VU_WEB_ADRESA as www,
            visokoskolska_ustanova.VU_E_MAIL as email,
            visokoskolska_ustanova.VU_OSNOVANA as datumOsnivanja

            FROM visokoskolska_ustanova
            INNER JOIN drzava ON visokoskolska_ustanova.DR_IDENTIFIKATOR = drzava.DR_IDENTIFIKATOR
            INNER JOIN tipovi_ustanova ON visokoskolska_ustanova.TIP_UST = tipovi_ustanova.TIP_UST
            INNER JOIN vrsta_vlasnistva ON visokoskolska_ustanova.VV_OZNAKA = vrsta_vlasnistva.VV_OZNAKA
            
            WHERE drzava.DR_IDENTIFIKATOR = ? ;
            `;

            let res_sub = this.mysql.query( sql_q, [element.id]);
            if(res_sub.length > 0 ){               
                let elem = new this.model1(
                    {
                        id: element.id,
                        naziv : element.naziv,
                        visoko_skolska_ustanova : res_sub,
                        verzija : verzija
                    }
                )
                 // dodaj elemenat u mongo
               elem.save((err, succ) =>{
                   if(err){console.log(err); return false; }
                   return true;
               })
            }
            
        };        
        //
        /*
        {
            podatak1_1 : "",
            podatak1_2 : ""
            podatak1_2 : "",
            verzija : 1
            ugnjezdeni : [
                {
                podatak2_1 : "",
                podatak2_2 : "",
                podatak2_3 : "",
                podatak2_4 : "",
                }
            ]
        }
         */
    }

    transform2( input : string){
        let verzija = new Date().getTime(); 
        // ucitaj prvu tabelu iz mysql
        let results = this.mysql.query('SELECT vrsta_vlasnistva.VV_OZNAKA AS id, vrsta_vlasnistva.VV_NAZIV as naziv FROM vrsta_vlasnistva WHERE vrsta_vlasnistva.VV_NAZIV  = ?', [input]);
        if (results.length === 0) {
            return false;
          }
          for (let element of results) {
            // nadji sve elemente sa povezanom tabelom - prodji kroz njih LOOP
            // uzimaj njihove podatke iz MySql-a i napravi listu
            let sql_q = `
            SELECT 
            visokoskolska_ustanova.VU_NAZIV as naziv,
            tipovi_ustanova.TIP_NAZIV as tip_naziv,
            drzava.DR_NAZIV as drzava_naziv,
            visokoskolska_ustanova.VU_ADRESA as adresa,
            visokoskolska_ustanova.VU_WEB_ADRESA as www,
            visokoskolska_ustanova.VU_E_MAIL as email,
            visokoskolska_ustanova.VU_OSNOVANA as datumOsnivanja

            FROM visokoskolska_ustanova
            INNER JOIN drzava ON visokoskolska_ustanova.DR_IDENTIFIKATOR = drzava.DR_IDENTIFIKATOR
            INNER JOIN tipovi_ustanova ON visokoskolska_ustanova.TIP_UST = tipovi_ustanova.TIP_UST
            INNER JOIN vrsta_vlasnistva ON visokoskolska_ustanova.VV_OZNAKA = vrsta_vlasnistva.VV_OZNAKA
            
            WHERE vrsta_vlasnistva.VV_OZNAKA= ? ;
            `;

            let res_sub = this.mysql.query( sql_q, [element.id]);
            if(res_sub.length > 0 ){               
                let elem = new this.model2(
                    {
                        id: element.id,
                        naziv : element.naziv,
                        visoko_skolska_ustanova : res_sub,
                        verzija : verzija
                    }
                )
                 // dodaj elemenat u mongo
               elem.save((err, succ) =>{
                   if(err){console.log(err); return false; }
                   return true;
               })
            }
            
        }; }

    transform3( input : string){

        let verzija = new Date().getTime(); 
        // ucitaj prvu tabelu iz mysql
        let results = this.mysql.query('SELECT tipovi_ustanova.TIP_UST AS id, tipovi_ustanova.TIP_NAZIV as naziv FROM tipovi_ustanova WHERE tipovi_ustanova.TIP_NAZIV  = ?', [input]);
        if (results.length === 0) {
            return false;
          }
          for (let element of results) {
            // nadji sve elemente sa povezanom tabelom - prodji kroz njih LOOP
            // uzimaj njihove podatke iz MySql-a i napravi listu
            let sql_q = `
            SELECT 
            visokoskolska_ustanova.VU_NAZIV as naziv,
            vrsta_vlasnistva.VV_NAZIV as tip_vlasnistva,
            drzava.DR_NAZIV as drzava_naziv,
            visokoskolska_ustanova.VU_ADRESA as adresa,
            visokoskolska_ustanova.VU_WEB_ADRESA as www,
            visokoskolska_ustanova.VU_E_MAIL as email,
            visokoskolska_ustanova.VU_OSNOVANA as datumOsnivanja

            FROM visokoskolska_ustanova
            INNER JOIN drzava ON visokoskolska_ustanova.DR_IDENTIFIKATOR = drzava.DR_IDENTIFIKATOR
            INNER JOIN tipovi_ustanova ON visokoskolska_ustanova.TIP_UST = tipovi_ustanova.TIP_UST
            INNER JOIN vrsta_vlasnistva ON visokoskolska_ustanova.VV_OZNAKA = vrsta_vlasnistva.VV_OZNAKA
            
            WHERE tipovi_ustanova.TIP_UST= ? ;
            `;

            let res_sub = this.mysql.query( sql_q, [element.id]);
            if(res_sub.length > 0 ){               
                let elem = new this.model3(
                    {
                        id: element.id,
                        naziv : element.naziv,
                        visoko_skolska_ustanova : res_sub,
                        verzija : verzija
                    }
                )
                 // dodaj elemenat u mongo
               elem.save((err, succ) =>{
                   if(err){console.log(err); return false; }
                   return true;
               })
            }
            
        };
    }
    //izvuci iz monga sve verzije
    verzija1() : any{
       return this.model1.find().distinct('verzija');

    }

    verzija2() : string{
        return this.model2.find().distinct('verzija');
    }

    verzija3() : string{
        return this.model3.find().distinct('verzija');
    }

    read1(input: string): any{
        return this.model1.find({verzija: Number(input)})
    }

    read2(input: string): any{
        return this.model2.find({verzija: Number(input)})
    }


    read3(input: string): any{
        return this.model3.find({verzija: Number(input)})
    }

}
