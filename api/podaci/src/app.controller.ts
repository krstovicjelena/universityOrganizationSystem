import { Controller, Get, Param, Post, Body } from '@nestjs/common';
import { DatabaseService } from './database/database.service';
import NewVsuDto from './database/dto/new.vsu.dto';
import { MongoService } from './mongo/mongo.service';
import { createSecureContext } from 'tls';
import { connectableObservableDescriptor } from 'rxjs/internal/observable/ConnectableObservable';
import { NeoService } from './neo/neo.service';
import NewVsuOJDto from './database/dto/new.vsu.oj.dto';

@Controller()
export class AppController {
  constructor(
    private readonly mysql: DatabaseService,
    private readonly mongo: MongoService,
    private readonly neo: NeoService,
  ) { }

  @Get()
  index(): string {
    return "Radi API";
  }

  @Get('vsu')
  getAllVSU() {
    let results = this.mysql.query('SELECT * FROM visokoskolska_ustanova ORDER BY VU_IDENTIFIKATOR DESC;', []);

    let vsus = [];

    for (let result of results) {
      let vsu = {
        id: result.VU_IDENTIFIKATOR,
        naziv: result.VU_NAZIV,
        tip: result.TIP_UST,
        drzava: result.DR_IDENTIFIKATOR,
        datumOsnivanja: result.VU_OSNOVANA,
        adresa: result.VU_ADRESA,
        tipVlasnistva: result.VV_OZNAKA,
        www: result.VU_WEB_ADRESA,
        email: result.VU_E_MAIL,
      };

      vsus.push(vsu);
    }

    return vsus;
  }

  @Get('vsu/:id/')
  getVSUById(@Param('id') id: string) {
    let results = this.mysql.query('SELECT * FROM visokoskolska_ustanova WHERE VU_IDENTIFIKATOR = ?;', [id]);

    if (results.length === 0) {
      return null;
    }

    let result = results[0];

    return {
      id: result.VU_IDENTIFIKATOR,
      naziv: result.VU_NAZIV,
      tip: result.TIP_UST,
      drzava: result.DR_IDENTIFIKATOR,
      datumOsnivanja: result.VU_OSNOVANA.substring(0, 10),
      adresa: result.VU_ADRESA,
      tipVlasnistva: result.VV_OZNAKA,
      www: result.VU_WEB_ADRESA,
      email: result.VU_E_MAIL,
    };
  }

  @Get('vsu/:id/organizacione-jedinice/')
  getVSUOrganizacioneJediniceById(@Param('id') id: string) {
    return this.mysql.query(`
      SELECT
        organizacione_jedinice.*,
        naseljeno_mesto.NM_NAZIV
      FROM
        organizacione_jedinice
        INNER JOIN naseljeno_mesto ON organizacione_jedinice.NM_IDENTIFIKATOR = naseljeno_mesto.NM_IDENTIFIKATOR
      WHERE
        organizacione_jedinice.VU_IDENTIFIKATOR = ?
      ORDER BY
        organizacione_jedinice.OJ_NAZIV;`, [id]);
  }

  //brisanje vsu i iz mysql i iz grafa

  @Get('vsu/:id/delete')
  deleteVSUById(@Param('id') id: string) {
    let result = this.mysql.query('DELETE FROM visokoskolska_ustanova WHERE VU_IDENTIFIKATOR = ?;', [id]);

    //neo4j
    this.neo.getSession().run(`MATCH(v:VSU{id: $id}) DELETE v;`, {
      id: Number(id)
    });

    return result;
  }

  @Get('mesta/')
  getAllMesta() {
    return this.mysql.query('SELECT * FROM naseljeno_mesto ORDER BY NM_NAZIV;', []);
  }

  //dodavanje oj
  @Post('vsuoj/add')
  addVSUOJ(@Body() data: NewVsuOJDto) {
    let storeData = [ data.TIP_UST, data.VU_IDENTIFIKATOR, Number((Math.random() * 100000).toFixed(0)), data.OJ_NAZIV, data.NM_IDENTIFIKATOR, data.OJ_ADRESA ];

    let result = this.mysql.query(`
      INSERT INTO organizacione_jedinice
      SET
        TIP_UST = ?,
        VU_IDENTIFIKATOR = ?,
        OJ_IDENTIFIKATOR = ?,
        OJ_NAZIV = ?,
        NM_IDENTIFIKATOR = ?,
        OJ_ADRESA = ?
      `, storeData);

      let vsuojid = this.mysql.query(`
        SELECT
          MAX(OJ_IDENTIFIKATOR) AS ID
        FROM
          organizacione_jedinice
        WHERE
          TIP_UST = ? AND VU_IDENTIFIKATOR = ? AND OJ_NAZIV = ? AND NM_IDENTIFIKATOR = ? AND OJ_ADRESA = ?`, [
          data.TIP_UST, data.VU_IDENTIFIKATOR, data.OJ_NAZIV, data.NM_IDENTIFIKATOR, data.OJ_ADRESA
      ])[0].ID;
      //kreiranje node-a  oj
      this.neo.getSession().run(`CREATE (oj:OJ{id: $id, naziv: $naziv, adresa: $adresa, mesto: $mesto})`, {
        id: vsuojid,
        naziv: data.OJ_NAZIV,
        adresa: data.OJ_ADRESA,
        mesto: this.mysql.query(`SELECT NM_NAZIV FROM naseljeno_mesto WHERE NM_IDENTIFIKATOR = ?`, [data.NM_IDENTIFIKATOR])[0].NM_NAZIV
      }).then(res => {
        //kreiranje veze u neo4j izmedju node-ova 
        this.neo.getSession().run(`MATCH (vsu:VSU), (oj:OJ) WHERE vsu.id = $vsuId AND oj.id = $ojId CREATE (oj)-[p:PRIPADA]->(vsu) RETURN vsu, p, oj;`, {
          vsuId: data.VU_IDENTIFIKATOR,
          ojId: vsuojid
        });
      });                         //MATCH x=(:OJ)-[:PRIPADA]->(:VSU) RETURN x

      return result;
  }
//brisanje oj
  @Get('vsuoj/:id/delete/')
  deleteVSUOJ(@Param('id') id: string) {
    let result = this.mysql.query(`DELETE FROM organizacione_jedinice WHERE OJ_IDENTIFIKATOR = ?;`, [id]);
  
    this.neo.getSession().run(`MATCH (o:OJ{id: $id}) DETACH DELETE o;`, { id: Number(id) });

    return result;
  }

  //dodavanje vsu
  @Post('vsu/add')
  addVSU(@Body() data: NewVsuDto) {
    // MySQL
    let result = this.mysql.query(`
      INSERT INTO visokoskolska_ustanova SET
        TIP_UST = ?,
        VU_NAZIV = ?,
        DR_IDENTIFIKATOR = ?,
        VU_OSNOVANA = ?,
        VU_ADRESA = ?,
        VV_OZNAKA = ?,
        VU_WEB_ADRESA = ?,
        VU_E_MAIL = ?
    `, [ data.tip, data.naziv, data.drzava, data.datumOsnivanja, data.adresa, data.tipVlasnistva, data.www, data.email ]);

    let id = this.mysql.query(`
      SELECT MAX(VU_IDENTIFIKATOR) AS ID
      FROM visokoskolska_ustanova
      WHERE
        TIP_UST = ? AND VU_NAZIV = ?;`, [ data.tip, data.naziv ])[0].ID;

    // Neo4J
    let v = {
      id: id,
      naziv: data.naziv,
      tip: data.tip,
      drzava: data.drzava,
      datumOsnivanja: data.datumOsnivanja,
      adresa: data.adresa,
      tipVlasnistva: data.tipVlasnistva,
      www: data.www,
      email: data.email,
      drzavaNaziv: this.mysql.query(`SELECT DR_NAZIV FROM drzava WHERE DR_IDENTIFIKATOR = ?`, [data.drzava])[0].DR_NAZIV,
      tipNaziv: this.mysql.query(`SELECT TIP_NAZIV FROM tipovi_ustanova WHERE TIP_UST = ?`, [data.tip])[0].TIP_NAZIV,
      tipVlasnistvaNaziv: this.mysql.query(`SELECT VV_NAZIV FROM vrsta_vlasnistva WHERE VV_OZNAKA = ?`, [data.tipVlasnistva])[0].VV_NAZIV,
    }
    //kreiranje node-a vsu
    this.neo.getSession().run(`CREATE(v:VSU{id: $id, tip: $tip, tipNaziv: $tipNaziv, naziv: $naziv, drzava: $drzava, drzavaNaziv: $drzavaNaziv, datumOsnivanja: $datumOsnivanja, adresa: $adresa, tipVlasnistva: $tipVlasnistva, tipVlasnistvaNaziv: $tipVlasnistvaNaziv, www: $www, email: $email}) RETURN v`, v)
    .then(res => {
    })
    .catch(error => {
    });

    return result;
  }

  //editovanje vsu 
  //body nam je body od responce-a jer se tako prenose podaci preko post metode
  @Post('vsu/:id')
  editVSU(@Body() data: NewVsuDto, @Param('id') id: string) {
    let result = this.mysql.query(`
      UPDATE visokoskolska_ustanova SET
        TIP_UST = ?,
        VU_NAZIV = ?,
        DR_IDENTIFIKATOR = ?,
        VU_OSNOVANA = ?,
        VU_ADRESA = ?,
        VV_OZNAKA = ?,
        VU_WEB_ADRESA = ?,
        VU_E_MAIL = ?
      WHERE VU_IDENTIFIKATOR = ?;
    `, [ data.tip, data.naziv, data.drzava, data.datumOsnivanja, data.adresa, data.tipVlasnistva, data.www, data.email, id ]);

   //neo4j spremanje podataka
    let v = {
      id: Number(id),
      naziv: data.naziv,
      tip: data.tip,
      drzava: data.drzava,
      datumOsnivanja: data.datumOsnivanja,
      adresa: data.adresa,
      tipVlasnistva: data.tipVlasnistva,
      www: data.www,
      email: data.email,
      drzavaNaziv: this.mysql.query(`SELECT DR_NAZIV FROM drzava WHERE DR_IDENTIFIKATOR = ?`, [data.drzava])[0].DR_NAZIV,
      tipNaziv: this.mysql.query(`SELECT TIP_NAZIV FROM tipovi_ustanova WHERE TIP_UST = ?`, [data.tip])[0].TIP_NAZIV,
      tipVlasnistvaNaziv: this.mysql.query(`SELECT VV_NAZIV FROM vrsta_vlasnistva WHERE VV_OZNAKA = ?`, [data.tipVlasnistva])[0].VV_NAZIV,
    }
  //editovanje odredjenog node-a po idju
    this.neo.getSession().run(`MATCH (v:VSU{id: $id}) SET v.tip = $tip, v.tipNaziv = $tipNaziv, v.naziv = $naziv, v.drzava = $drzava, v.drzavaNaziv = $drzavaNaziv, v.datumOsnivanja = $datumOsnivanja, v.adresa = $adresa, v.tipVlasnistva = $tipVlasnistva, v.tipVlasnistvaNaziv = $tipVlasnistvaNaziv, v.www = $www, v.email = $email RETURN v;`, v)
    .then(res => {

    })
    .catch(error => {

    });

    return result;
  }

  //pretraga vsu
  @Get('vsu/search/:id')
  searchVSU(@Param('id') id: string) {
    let param = '%' + id + '%';
    let results = this.mysql.query(`
    SELECT * FROM visokoskolska_ustanova
    WHERE 
      TIP_UST LIKE ? OR
      VU_IDENTIFIKATOR LIKE ? OR
      VU_NAZIV LIKE ? OR
      DR_IDENTIFIKATOR LIKE ? OR
      VU_OSNOVANA LIKE ? OR
      NM_IDENTIFIKATOR LIKE ? OR
      VU_ADRESA LIKE ? OR
      VU_WEB_ADRESA LIKE ? OR
      VU_E_MAIL LIKE ? OR
      VV_OZNAKA LIKE ? OR
      VU_PIB LIKE ? OR
      VU_MATICNI_BROJ LIKE ? OR
      VU_GRB LIKE ? OR
      VU_MEMORANDUM LIKE ?`, [ param, param, param, param, param, param, param, param, param, param, param, param, param, param ]);

      let vsus = [];

      for (let result of results) {
        let vsu = {
          id: result.VU_IDENTIFIKATOR,
          naziv: result.VU_NAZIV,
          tip: result.TIP_UST,
          drzava: result.DR_IDENTIFIKATOR,
          datumOsnivanja: result.VU_OSNOVANA,
          adresa: result.VU_ADRESA,
          tipVlasnistva: result.VV_OZNAKA,
          www: result.VU_WEB_ADRESA,
          email: result.VU_E_MAIL,
        };
  
        vsus.push(vsu);
      }
      return vsus;
  }
//ovo je za prvi dokument da se izlista lista drzava koje su u bazi tj biramo srbija/bosna
  @Get('drzave')
  listaDrzava(){
    return this.mysql.query("SELECT drzava.DR_NAZIV as naziv FROM drzava", []);
  }


  //ovo je za drugi dokument da se izlista lista vlasnistva koja su u bazi
  @Get('vv')
  listaVlasnistva(){
    return this.mysql.query("SELECT vrsta_vlasnistva.VV_NAZIV as naziv FROM vrsta_vlasnistva", []);
  }


   //ovo je za treci dokument da se izlista lista tipova koji su u bazi
   @Get('tu')
   listaTipova(){
     return this.mysql.query("SELECT tipovi_ustanova.TIP_NAZIV as naziv FROM tipovi_ustanova", []);
   }
 

  //prikaz drzava u tabeli - mysql deo
  @Get('drzava')
  getAllDrzave(){
    let results= this.mysql.query("SELECT * FROM drzava", []);
    let tipovi = [];

    for (let result of results) {
      let tip = {
        oznaka: result.DR_IDENTIFIKATOR,
        nazivDrzave: result.DR_NAZIV,
      };

      tipovi.push(tip);
    }

    return tipovi;
  }

//prikaz tabele tipovi
  @Get('tip')
  getAlltip() {
    let results = this.mysql.query('SELECT * FROM tipovi_ustanova;', []);

    let tipovi = [];

    for (let result of results) {
      let tip = {
        tip: result.TIP_UST,
        nazivTipa: result.TIP_NAZIV,
      };

      tipovi.push(tip);
    }

    return tipovi;
  }

  //prikaz tabele vlasnistvo
  //prikaz tabele tipovi
  @Get('vlasnistvo')
  getAllVlasnistvo() {
    let results = this.mysql.query('SELECT * FROM vrsta_vlasnistva;', []);

    let vl = [];

    for (let result of results) {
      let v = {
        oznaka: result.VV_OZNAKA,
        nazivOznake: result.VV_NAZIV,
      };

      vl.push(v);
    }

    return vl;
  }

  /* ********************************************************************************************

    MONGO DB 

  ******************************************************************************************** */
//za prvi dok verzije i transformacija
 @Get('transform1/:id')
 transform1(@Param('id') id: string ) : string{
     let bool = this.mongo.transform1(id);
     return "";
     
 }

 @Get('verzije1/')
 verzije_mongo1( ) : any{
   let lista = this.mongo.verzija1();
   return lista;
 }


//za drugi v i t
 @Get('transform2/:id')
 transform2(@Param('id') id: string ) : string{
     let bool = this.mongo.transform2(id);
     return "";
     
 }

 @Get('verzije2/')
  verzije_mongo2( ) : any{
    let lista = this.mongo.verzija2();
    return lista;
      
  }


//za treci v i t
 @Get('transform3/:id')
 transform3(@Param('id') id: string ) : string{
  let bool = this.mongo.transform3(id);
  return "";
     
 }
 @Get('verzije3/')
 verzije_mongo3() : any{
  let lista = this.mongo.verzija3();
  return lista;
     
 }



 @Get('read_mongo1/:id')
 read_mongo1(@Param('id') id: string ) : any{
   let lista = this.mongo.read1(id);
   return lista;
 }
 
 @Get('read_mongo2/:id')
 read_mongo2(@Param('id') id: string ) : any{
   let lista = this.mongo.read2(id);
   return lista;
 }

 @Get('read_mongo3/:id')
 read_mongo3(@Param('id') id: string ) : any{
   let lista = this.mongo.read3(id);
   return lista;
 }


}
