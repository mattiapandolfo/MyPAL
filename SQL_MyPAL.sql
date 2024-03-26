drop table if exists Manager;
drop table if exists Palestra;
drop table if exists Dipendente;
drop table if exists Esterno;
drop table if exists Interno;
drop table if exists Scheda;
drop table if exists Cliente;
drop table if exists Sessione;
drop table if exists PrenotazioneSessione;
drop table if exists Sala;
drop table if exists PrenotazioneSale;
drop table if exists Attrezzo;
drop table if exists Corso;
drop table if exists IscrizioneCorso;
drop table if exists Recensioni;

create table Manager (
        	CF                           char (16)              primary key,
       	Nome                      varchar (50)         not null,
        	Cognome                varchar (50)         not null
);



create table Palestra (
       	Codice                       	varchar (10)           	primary key,
Città                           	varchar (50)            	not null,
       	Via                              	varchar (50)            	not null,
     	Civico                         	varchar (50)            	not null,
       	NumeroTelefonico       varchar (10)            	not null,
      	OraApertura                time                        	not null,  
       	OraChiusura               time                        	not null, 
       	Mediavoto                   int   ,
	Manager		char (16),
       	foreign key (Manager) references Manager (CF) 
on update cascade 
on delete set null
);

create table Dipendente (
         	CF                    	char (16)             	primary key,
         	Nome                     	varchar (50)            	not null,
         	Cognome               	varchar (50)            	not null, 
         	Sesso              	varchar (10)             	not null,
         	Stipendio              	decimal (7,2)            	not null,
Palestra		varchar (10)	 	not null,
        	foreign key (Palestra) references Palestra (Codice) 
on update cascade 
on delete cascade    
);


create table Esterno (
Dipendente      		char (16)                	primary key,
AnniEsperienza                            	int         		not null, 
PrimoSoccorso                      	bool                        	not null, 
AmbitoSpecializzazione       	varchar (50)      	not null,
foreign key   (Dipendente) references Dipendente (CF) 
on update cascade
on delete cascade
);
create table Interno ( 
Dipendente           	char (16)       		primary key, 
AnniEsperienza         	int    			not null,
PrimoSoccorso        	bool                  	not null,  
NClientiSeguiti        	int             		not null,
EtaTarget                   	varchar (10)     	not null,
SessoTarget              	varchar (10)   		not null,
foreign key   (Dipendente) references Dipendente (CF) 
on update cascade
on delete cascade
);
      


 create table Scheda (
          	Codice          		int                     	primary key,
          	Durata                         varchar (10)      	not null,  
          	Difficoltà                      varchar (10)       	not null, 
          	Cardio                      	bool                     	not null, 
          	Gambe                 	bool                     	not null,
          	Addominali               	bool                    	not null, 
          	Petto                   	bool                    	not null,  
          	Dorsali               	bool                     	not null, 
          	Braccia                 	bool                     	not null,
Interno 		char (16)		not null,
         	foreign key  (Interno) references Interno (Dipendente) 
on update cascade
on delete cascade
);   


create table Cliente (
    	NumeroTelefono       	char (10)       		primary key,
    	Nome                 	varchar (50)    		not null,
    	Cognome              	varchar (50)    		not null,
    	Sesso                	varchar (10)       	not null,
    	Età                  		char (2)        		not null,
Palestra		varchar (10)		not null,
foreign key (Palestra) references Palestra (Codice) 
on update cascade
on delete cascade
);






create table Sessione ( 
            Codice                      	int                     	primary key,
            Data                        	date                            	not null, 
            OraInizio                     time                           	not null, 
            OraFine                     	time                           	not null
);



create table PrenotazioneSessione (
Cliente			char(10),	
Sessione 		int,		            
primary key (Cliente, Sessione),
            foreign key (Cliente) references Cliente (NumeroTelefono) 
on update cascade 
on delete cascade,
            foreign key (Sessione) references Sessione (Codice) 
on update cascade
on delete cascade
);


create table Sala ( 
          	ID                     	int                    	primary key, 
            Capienza                 	varchar (10)           	not null, 
           	Tipo                		varchar (20)           	not null,
Palestra		varchar (10)		not null,
         	foreign key (Palestra) references Palestra (Codice) 
on update cascade
on delete cascade
);


create table PrenotazioneSale ( 
           	Sale		int,
	Sessione	int,
primary key (Sale, Sessione),
            foreign key (Sale) references Sala (ID) 
on update cascade
on delete cascade,
          	foreign key (Sessione) references Sessione (Codice) 
on update cascade 
on delete cascade 
);




create table Attrezzo ( 
           	Codice       	varchar (100)           		primary key,       
           	Numero    	int                         		not null, 
            Peso    	varchar (10),
	Sala		int,			
           	foreign key (Sala) references Sala (ID) 
on update cascade
on delete set null	 
);


create table Corso ( 
         	Codice      	int         	primary key, 
            Nome      	varchar (50)         	not null, 
       	NIscritti       	int                     	not null, 
     	Data        	date                        	not null, 
       	OraInizio       	time            		not null,
       	OraFine       	time               		not null, 
	Esterno	char(16)		not null,
Sala		int			not null,
       	foreign key (Esterno) references Esterno (Dipendente) 
on update cascade
on delete cascade,
foreign key (Sala) references Sala (ID) 
on update cascade
on delete cascade
);



create  table IscrizioneCorso  (
	Corso		int,
	Cliente		char (10),
   	primary key (Corso, Cliente),
   	foreign key (Corso) references Corso (Codice) 
on  update cascade
on delete cascade,
   	foreign key (Cliente) references Cliente (NumeroTelefono) 
on update cascade
		on delete cascade
);








create table Recensioni ( 
         	Codice       		varchar (10)            	primary key, 
   	Stelle       		int                      	not null,
StelleCorso     	int  ,
Piattaforma         	varchar (10)           	not null ,
Cliente			char (10)		not null,
Palestra		varchar (10)		not null,
Corso			int,
foreign key (Cliente) references Cliente (NumeroTelefono) 
on update cascade
on delete cascade,
            foreign key (Palestra) references Palestra (Codice) 
on update cascade
on delete cascade,
foreign key (Corso) references Corso (Codice) 
on update cascade
on delete cascade
);


/*Popolamento tabelle */


insert into Manager (CF, Nome, Cognome) values
('dvdrss74m15f205c','davide','rossi'),
('mrcvrd86h12l219c','marco','verdi'),
('lssnre66a14g224j','alessio','neri'),
('brtlse95h56f839n','elisa','barutti'),
('crtmrc74m16l840s','marco','carta');




insert into Palestra ( Codice, Città, Via, Civico, NumeroTelefonico, OraApertura, OraChiusura, MediaVoto, Manager) values
(1,'padova','via spagna','118','3494569812','08:00:00','20:00:00',5,'dvdrss74m15f205c'),
(2,'milano','via garibaldi','149','3495563872','07:00:00','21:00:00',3,'crtmrc74m16l840s'),
(3,'torino','via verdi','44','3494269816','08:00:00','21:00:00',3,'brtlse95h56f839n'),
(4,'vicenza','via goldoni','7','3498569819','08:00:00','22:00:00',2,'mrcvrd86h12l219c'),
(5,'napoli','via ungaretti','168','3494569810','08:00:00','22:00:00',4,'lssnre66a14g224j');





insert into Dipendente ( CF, Nome, Cognome, Sesso, Stipendio, Palestra) values
('mttprt74m15f205c','matteo','pretto','m',1500,1),
('fdrrss74m15f205c','federico','rossi','m',2000,1),
('mttpnd74m15f205c','mattia','pandolfo','m',1500,1),
('ssntrt74m15f205c','alessandro','turetta','m',1600,1),
('mrccll74m15f205c','marco','colli','m',1400,1),
('nclmng74m15f205c','nicola','menegazzo','m',1500,2),
('smlscr74m15f205c','samuel','scarollo','m',1500,2),
('lsabll74f15f205c','alessia','bellucco','f',1300,2),
('crlpss74m15f205c','carlo','passuello','m',1000,2),
('mrccnz74m15f205c','marco','cenzi','m',1600,2),
('mttprc74m15f205c','mattoa','prucco','m',1400,3),
('ntnqlt74m15f205c','antonio','aquilotto','m',1200,3),
('frcbrt74m15f205c','franco','baretta','m',1600,3),
('stfmrt74m15f205c','stefano','martini','m',1600,3),
('mrtflt74m15f205c','martino','feltre','m',1200,3),
('dvdmnn74m15f205c','davide','manni','m',1800,4),
('vrgmls74f15f205c','virginia','malossi','f',1500,4),
('dvdpll74m15f205c','davide','pollio','m',1600,4),
('nccznc74m15f205c','niccolo','zancan','m',1300,4),
('mrcdnd74m15f205c','marco','donadello','m',1800,4),
('gnvclb74f15f205c','ginevra','colbacchini','f',1700,5),
('lssmnc74m15f205c','alessandro','monaco','m',1300,5),
('ldvsbl74m15f205c','ludovico','sibillia','m',1700,5),
('tmsrtt74m15f205c','tommaso','rotto','m',1500,5);







insert into Esterno ( Dipendente, AnniEsperienza, PrimoSoccorso, AmbitoSpecializzazione) values
('lssmnc74m15f205c',4,false,'judo'),
('dvdpll74m15f205c',3,false,'judo'),
('stfmrt74m15f205c',8,true,'judo'),
('ssntrt74m15f205c',5,false,'judo'),
('mrccnz74m15f205c',11,true,'judo'),
('mrccll74m15f205c',10,true,'calisthenics'),
('smlscr74m15f205c',8,false,'calisthenics'),
('mrtflt74m15f205c',6,true,'calisthenics'),
('nccznc74m15f205c',5,true,'calisthenics'),
('ldvsbl74m15f205c',3,false,'calisthenics'),
('fdrrss74m15f205c',15, false,'karate'),
('crlpss74m15f205c',13, true,'karate'),
('ntnqlt74m15f205c',11, false,'karate'),
('mrcdnd74m15f205c',8, false,'karate'),
('tmsrtt74m15f205c',6, false,'karate'),
('mttpnd74m15f205c',7, true,'crossfit'),
('vrgmls74f15f205c',12,true,'yoga');







insert into Interno( Dipendente, AnniEsperienza, PrimoSoccorso, NClientiSeguiti, EtaTarget, SessoTarget) values
('mttprt74m15f205c',6,true,42,'15-25','f'),
('lsabll74f15f205c',9,false,38,'25-35','f'),
('mttprc74m15f205c',3,true,25,'55-65','f'),
('dvdmnn74m15f205c',7,false,46,'35-50','m'),
('gnvclb74f15f205c',15,true,55,'20-35','m'),
('nclmng74m15f205c',10,false,40,'15-30','m'),
('frcbrt74m15f205c',8,true,37,'30-50','m');





insert into Scheda( Codice, Durata,  Difficoltà, Cardio, Gambe, Addominali, Petto, Dorsali, 
	Braccia, Interno) values
(1,'50 minuti','facile',true,false,true,true,false,true,'mttprc74m15f205c'),
(2,'60 minuti','facile',true,true,true,true,false,false,'lsabll74f15f205c'),
(3,'45 minuti','facile',false,false,true,true,true,true,'mttprc74m15f205c'),
(4,'40 minuti','facile',true,false,false,true,false,true,'gnvclb74f15f205c'),
(5,'50 minuti','media',true,true,true,false,false,true,'dvdmnn74m15f205c'),
(6,'50 minuti','media',false,true,true,false,true,true,'frcbrt74m15f205c'),
(7,'70 minuti','media',true,true,true,false,false,true,'nclmng74m15f205c'),
(8,'40 minuti','media',true,true,true,false,false,true,'nclmng74m15f205c'),
(9,'55 minuti','media',true,false,true,false,false,true,'gnvclb74f15f205c'),
(10,'65 minuti','media',false,true,true,false,false,true,'frcbrt74m15f205c'),
(11,'60 minuti','media',false,true,true,false,false,true,'dvdmnn74m15f205c'),
(12,'80 minuti','alta',true,true,true,true,true,true,'lsabll74f15f205c'),
(13,'75 minuti','alta',false,true,true,false,false,true,'dvdmnn74m15f205c'),
(14,'55 minuti','alta',false,true,true,false,false,true,'gnvclb74f15f205c'),
(15,'65 minuti','alta',true,true,true,false,false,true,'dvdmnn74m15f205c'),
(16,'55 minuti','alta',true,false,true,false,false,true,'mttprt74m15f205c'),
(17,'85 minuti','alta',true,true,true,true,false,true,'mttprt74m15f205c'),
(18,'70 minuti','alta',false,true,true,false,false,true,'mttprt74m15f205c'),
(19,'75 minuti','alta',true,true,true,false,false,true,'mttprt74m15f205c'),
(20,'80 minuti','alta',true,true,true,true,false,true,'mttprt74m15f205c'),
(21,'90 minuti','alta',true,true,true,false,true,true,'mttprt74m15f205c');








insert into Cliente( NumeroTelefono, Nome, Cognome, Sesso, Età, Palestra) values
('3494409876','giacomo','rossi','m','24',1),
('3494409877','giacomo','verdi','m','39',4),
('3494409878','paolo','rossi','m','30',5),
('3494409879','davide','neri','m','44',2),
('3494409880','giulia','neri','f','19',3),
('3494409887','luca','depaoli','m','34',1),
('3494409895','andrea','dendi','m','24',2),
('3494409906','denis','dosio','m','57',4),
('3494409676','alice','pavan','f','36',1),
('3494409506','giovanni','zaccaria','m','50',3),
('3494409086','giada','monti','f','17',4),
('3494409536','giacomo','pavan','m','60',5),
('3494409426','giacomo','pavan','m','43',1),
('3494409076','antonella','delisi','f','20',2),
('3494408676','luigi','rossi','m','29',3),
('3494400576','andrea','pollini','m','31',1),
('3494404176','alessio','pollini','m','38',4),
('3494487876','natasha','dallamuta','f','43',1),
('3494482876','carlotta','benco','f','43',3),
('3494129876','veronica','prendin','f','19',2),
('3494349876','alex','campagnaro','m','25',4),
('3771111111','mario','blu','m','45',1),
('3772222222','luigi','viola','m','35',1),
('3773333333','wario','giallo','m','25',1),
('3774444444','bred','panetto','m','63',1),
('3775555555','yoshi','verdi','m','33',1),
('3776666666','anna','ceranto','f','21',1),
('3777777777','marika','pertile','f','21',1),
('3778888888','annalisa','donetti','f','21',1),
('3777999999','marta','babbolin','f','21',1),
('3494679876','stefano','lattenero','m','24',5);




insert into Sessione ( Codice, Data, OraInizio, OraFine) values
(1,'2020-01-01','08:00','11:00'),
(2,'2020-02-10','08:00','11:00'),
(3,'2020-02-11','08:00','11:00'),
(4,'2020-02-13','08:00','11:00'),
(5,'2020-03-10','08:00','11:00'),
(6,'2020-03-10','12:00','15:30'),
(7,'2020-03-10','13:40','16:20'),
(8,'2020-03-10','14:50','18:00'),
(9,'2020-03-10','17:00','19:40'),
(10,'2020-05-10','08:10','11:00'),
(11,'2020-05-10','10:00','12:00'),
(12,'2020-05-10','14:20','16:10'),
(13,'2020-05-10','16:40','18:20'),
(14,'2020-05-10','17:30','19:10'),
(15,'2020-05-10','19:30','21:00'),
(16,'2020-05-11','08:50','11:00'),
(17,'2020-05-11','09:40','13:20'),
(18,'2020-05-11','10:40','12:30'),
(19,'2020-05-11','11:30','15:20'),
(20,'2020-05-11','12:30','16:20'),
(21,'2020-05-12','08:00','11:00'),
(22,'2020-05-12','12:20','16:20'),
(23,'2020-05-22','08:00','11:00'),
(24,'2020-05-22','13:10','15:21'),
(25,'2020-05-22','14:00','17:50'),
(26,'2020-05-22','17:50','20:00'),
(27,'2020-06-12','08:00','11:00'),
(28,'2020-06-12','14:00','17:50'),
(29,'2020-06-12','20:40','20:30'),
(30,'2020-06-12','08:30','18:00'),
(31,'2020-06-13','08:00','11:00'),
(32,'2020-06-13','11:50','15:40'),
(33,'2020-06-13','17:40','20:40'),
(34,'2020-06-13','12:40','16:40'),
(35,'2020-06-13','18:50','19:30'),
(36,'2020-06-14','08:00','11:00'),
(37,'2020-06-14','11:50','13:20'),
(38,'2020-06-14','17:00','20:40'),
(39,'2020-08-13','08:00','11:00'),
(40,'2020-08-13','11:50','18:50'),
(41,'2020-08-13','11:50','15:20'),
(42,'2020-08-13','17:00','20:40'),
(43,'2020-08-13','17:40','21:00'),
(44,'2020-09-15','08:00','11:00'),
(45,'2020-09-15','11:50','15:20'),
(46,'2020-09-15','17:00','18:40'),
(47,'2020-09-15','18:40','20:00'),
(48,'2020-09-15','19:00','20:50'),
(49,'2020-10-15','08:00','11:00'),
(50,'2020-10-15','11:50','14:50'),
(51,'2020-10-15','12:40','15:00'),
(52,'2020-10-15','16:50','19:50'),
(53,'2020-10-15','18:40','20:00'),
(54,'2020-11-15','08:00','11:00'),
(55,'2020-11-15','10:40','13:00'),
(56,'2020-11-15','12:50','15:50'),
(57,'2020-11-15','17:40','19:00'),
(58,'2020-11-15','19:50','21:00'),
(59,'2020-12-15','09:00','11:30'),
(60,'2020-12-15','14:00','16:30');



insert into PrenotazioneSessione ( Cliente, Sessione) values
('3494409876',17),
('3494409877',4),
('3494409878',5),
('3494409879',2),
('3494409880',3),
('3494409887',1),
('3494409895',22),
('3494409906',24),
('3494409676',27),
('3494409506',23),
('3494409086',25),
('3494409536',14),
('3494409426',11),
('3494409076',20),
('3494408676',13),
('3494400576',16),
('3494404176',40),
('3494487876',31),
('3494482876',27),
('3494129876',35),
('3494349876',36),
('3494679876',37),
('3494679876',38),
('3494679876',39),
('3494482876',39),
('3494129876',33),
('3494349876',33),
('3494679876',33),
('3494482876',33),
('3494129876',34),
('3494349876',35),
('3494679876',35),
('3494482876',35),
('3494129876',36),
('3494349876',37),
('3494679876',47),
('3494679876',30),
('3494409887',43),
('3494409887',33),
('3494409887',37),
('3494409887',45),
('3494409887',47),
('3494409887',48),
('3494409887',55),
('3494409887',56),
('3494409887',50),
('3494409887',58),
('3771111111',23),
('3771111111',24),
('3771111111',33),
('3771111111',45),
('3772222222',9),
('3772222222',13),
('3772222222',14),
('3772222222',23),
('3772222222',25),
('3772222222',57),
('3773333333',13),
('3773333333',14),
('3773333333',28),
('3773333333',45),
('3774444444',14),
('3774444444',13),
('3775555555',16),
('3775555555',57),
('3776666666',57),
('3776666666',58),
('3776666666',59),
('3494409887',60),
('3494409876',36),
('3494409877',36),
('3494409878',36),
('3494409879',36),
('3494409880',36),
('3494409887',36),
('3494409876',57),
('3494409877',57),
('3494409878',57),
('3494409879',57),
('3494409880',57),
('3494409887',57),
('3494409895',57),
('3494409906',57),
('3494409676',57),
('3494409506',57),
('3494409086',57),
('3494409536',57),
('3494409426',57),
('3494409076',57);






insert into Sala ( ID, Capienza, Tipo, Palestra) values
(1,'35','cardio',1),
(2,'40','pesi',1),
(3,'25','corpo libero',1),
(4,'41','cardio',2),
(5,'37','pesi',2),
(6,'30','corpo libero',2),
(7,'29','cardio',3),
(8,'38','pesi',3),
(9,'42','corpo libero',3),
(10,'34','cardio',4),
(11,'28','pesi',4),
(12,'33','corpo libero',4),
(13,'31','cardio',5),
(14,'46','pesi',5),
(15,'37','corpo libero',5);




insert into PrenotazioneSale ( Sale, Sessione) values
(1,1),(1,7),(1,34),(1,45),(1,50),(1,43),(1,23),(1,6),(1,13),(1,9),(1,18),(1,32),
(2,1),(2,4),(2,5),(2,7),(2,19),(2,24),(2,27),(2,31),(2,34),(2,37),(2,45),(2,51),(2,58),
(4,1),(4,2),(4,7),(4,8),(4,12),(4,33),(4,55),(4,32),
(5,1),(5,4),(5,13),(5,34),(5,40),(5,44),(5,55),
(7,2),(7,3),(7,14),(7,20),(7,26),(7,43),(7,47),
(8,3),(8,9),(8,18),(8,38),(8,56),
(10,3),(10,11),(10,13),(10,25),(10,33),
(11,2),(11,17),(11,35),(11,45),(11,57),
(13,6),(13,11),(13,12),(13,22),(13,28),(13,33),(13,35),(13,45),
(14,21),(14,46),(14,49),(14,29),(13,32),(13,36),(14,45),(14,57);




insert into Attrezzo ( Codice, Numero, Peso, Sala) values
('1TapiR',5,null,1),
('1Cyclet',3,null,1),
('1Mill',1,null,1),
('1Man5',4,'5 kg',2),
('1Man8',4,'8 kg',2),
('1Man10',8,'10kg',2),
('1Man12',4,'12kg',2),
('1Man14',4,'14kg',2),
('1Man16',4,'16kg',2),
('1Man18',4,'18kg',2),
('1Man20',4,'20kg',2),
('1Panca',4,null,2),
('1PancaP',3,null,2),
('1PancaR',1,null,2),
('2TapiR',8,null,4),
('2Cyclet',5,null,4),
('2Man8',6,'8 kg',5),
('2Man10',10,'10kg',5),
('2Man12',4,'12kg',5),
('2Man18',6,'18kg',5),
('2Man20',6,'20kg',5),
('2Panca',6,null,5),
('2PancaP',5,null,5),
('2PancaR',2,null,5),
('3TapiR',5,null,7),
('3Man5',4,'5 kg',8),
('3Man8',4,'8 kg',8),
('3Man10',8,'10kg',8),
('3Man12',4,'12kg',8),
('3Man14',4,'14kg',8),
('3Panca',4,null,8),
('3PancaP',3,null,8),
('4TapiR',4,null,10),
('4Cyclet',2,null,10),
('4Man5',4,'5 kg',11),
('4Man8',4,'8 kg',11),
('4Man10',8,'10kg',11),
('4Man12',4,'12kg',11),
('4Man14',4,'14kg',11),
('4Panca',4,null,11),
('4PancaP',3,null,11),
('4PancaR',1,null,11),
('5TapiR',5,null,13),
('5Man5',4,'5 kg',14),
('5Man10',8,'10kg',14),
('5Man14',4,'14kg',14),
('5Panca',2,null,14),
('5PancaP',1,null,14);




insert into Corso ( Codice, Nome, Niscritti, Data, OraInizio, OraFine, Esterno,Sala) values
(1,'karate',24,'2021-11-18','18:00','20:00','fdrrss74m15f205c',3),
(2,'karate',28,'2020-01-10','08:40','10:00','crlpss74m15f205c',6),
(3,'karate',30,'2021-05-10','13:20','17:50','ntnqlt74m15f205c',9),
(4,'karate',32,'2020-05-10','08:30','11:50','mrcdnd74m15f205c',12),
(5,'karate',34,'2020-03-10','16:20','18:00','tmsrtt74m15f205c',15),
(6,'judo',30,'2022-05-12','12:00','16:30','ssntrt74m15f205c',3),
(7,'judo',31,'2020-05-12','13:40','17:20','mrccnz74m15f205c',6),
(8,'judo',32,'2020-05-12','14:50','18:00','stfmrt74m15f205c',9),
(9,'judo',33,'2020-05-12','17:00','19:40','dvdpll74m15f205c',12),
(10,'judo',34,'2020-05-12','08:10','11:00','lssmnc74m15f205c',15),
(11,'calisthenics',22,'2020-05-11','14:30','18:30','mrccll74m15f205c',3),
(12,'calisthenics',23,'2020-05-11','09:20','12:10','smlscr74m15f205c',6),
(13,'calisthenics',24,'2020-05-11','14:40','18:20','mrtflt74m15f205c',9),
(14,'calisthenics',25,'2020-05-11','13:30','18:10','nccznc74m15f205c',12),
(15,'calisthenics',26,'2020-05-11','14:30','18:40','ldvsbl74m15f205c',15),
(16,'crossfit',39,'2020-05-13','08:50','11:00','mttpnd74m15f205c',3),
(17,'yoga',45,'2020-05-14','09:40','13:20','vrgmls74f15f205c',12);






insert into IscrizioneCorso (Corso, Cliente) values
(1,'3494409876'),
(6,'3494409876'),
(4,'3494409877'),
(14,'3494409877'),
(14,'3494409906'),
(17,'3494409906'),
(16,'3494409676'),
(5,'3494409536'),
(10,'3494409536'),
(1,'3494409426'),
(6,'3494409426'),
(11,'3494409426'),
(2,'3494409076'),
(3,'3494408676'),
(8,'3494408676'),
(6,'3494400576'),
(9,'3494404176'),
(1,'3494487876'),
(16,'3494487876'),
(3,'3494482876'),
(13,'3494482876'),
(2,'3494129876'),
(7,'3494129876'),
(12,'3494129876'),
(4,'3494349876'),
(9,'3494349876'),
(14,'3494349876'),
(17,'3494349876'),
(5,'3494679876'),
(11,'3494409876'),
(11,'3494409887'),
(11,'3494400576'),  
(11,'3494487876'),
(11,'3771111111'),
(11,'3772222222'),
(11,'3773333333'),
(11,'3774444444'),
(11,'3775555555'),
(11,'3776666666'),
(10,'3494679876'),
(6,'3774444444');





insert into Recensioni ( Codice, Stelle, StelleCorso, Piattaforma, Cliente,Palestra, Corso) values
(1,4,null,'trustpilot','3494409876',1,null),
(2,5,5,'google','3494409877',4,4),
(3,5,4,'google','3494409877',4,14),
(4,3,2,'trustpilot','3494409906',4,14),
(5,3,4,'trustpilot','3494409906',4,17),
(6,4,4,'yahoo','3494409676',1,16),
(7,5,null,'google','3494409536',5,null),
(8,4,4,'yahoo','3494409426',1,1),
(9,4,2,'google','3494408676',3,3),
(10,4,5,'google','3494408676',3,8),
(11,3,null,'yahoo','3494409076',2,null),
(12,4,4,'google','3494400576',1,6),
(13,5,null,'yahoo','3494404176',4,9),
(14,4,4,'google','3494487876',1,1),
(15,4,4,'google','3494487876',1,16),
(16,4,null,'trustpilot','3494482876',3,null),
(17,5,5,'trustpilot','3494482876',3,3),
(18,5,5,'trustpilot','3494482876',3,13),
(19,4,3,'google','3494129876',2,2),
(20,4,4,'google','3494129876',2,7),
(21,4,5,'google','3494129876',2,12),
(22,3,3,'yahoo','3494349876',4,4),
(23,3,2,'yahoo','3494349876',4,9),
(24,3,4,'yahoo','3494349876',4,14),
(25,3,3,'yahoo','3494349876',4,17),
(26,4,5,'google','3494679876',5,5),
(27,4,4,'google','3494679876',5,10),
(28,4,5,'google','3776666666',1,11),
(29,3,4,'google','3773333333',1,11),
(30,4,5,'google','3772222222',1,11),
(31,4,null,'google','3771111111',1,null),
(32,5,5,'google','3774444444',1,11),
(33,4,null,'trustpilot','3774444444',1,null),
(34,4,null,'google','3775555555',1,null),
(35,4,null,'yahoo','3775555555',1,null),
(36,5,5,'trustpilot','3774444444',1,6);


/* viste */
DROP view IF EXISTS rec_complete;
CREATE view rec_complete AS
             SELECT Stelle, StelleCorso ,Piattaforma, Palestra, Cliente, Corso
             FROM Recensioni
             WHERE  Piattaforma='google' OR StelleCorso IS NOT NULL;


DROP view IF EXISTS num_corsi_cliente;
CREATE view num_sessioni_cliente  AS 
	SELECT Cliente, COUNT(*) AS prnt_sessioni
	FROM PrenotazioneSessione
GROUP BY Cliente;


DROP view IF EXISTS num_corsi_cliente;
CREATE view num_corsi_cliente  AS 
	SELECT Cliente, COUNT(*) AS iscr_corsi
	FROM IscrizioneCorso
GROUP BY Cliente;


DROP view IF EXISTS att_cliente;
CREATE view att_cliente  AS 
SELECT c.cliente, c.iscr_corsi, s.prnt_sessioni, (c.iscr_corsi + s.prnt_sessioni) AS
 									tot_attivita
   	FROM num_corsi_cliente c JOIN num_sessioni_cliente s ON c.cliente = s.cliente;


DROP view IF EXISTS clienti_e_loro_sess ;
CREATE VIEW clienti_e_loro_sess AS
	SELECT c.NumeroTelefono, c.Nome, c.Cognome, c.Palestra, s.Data, s.orainizio
	FROM (Cliente c JOIN PrenotazioneSessione ps ON c.NumeroTelefono = ps.Cliente) 
		 JOIN Sessione s ON ps.Sessione = s.Codice; 


DROP view IF EXISTS pal_prima_sess ;
CREATE VIEW pal_prima_sess AS
SELECT Palestra, MIN(data) as primo_giorno_prnt, MIN(orainizio) as primo_orario_prnt
FROM clienti_e_loro_sess 
GROUP BY Palestra;


DROP view IF EXISTS natt_sala;
CREATE view natt_sala AS
	SELECT s.id AS cod_sala, s.tipo, s.palestra, sum(a.numero) AS att_sala
	FROM attrezzo a JOIN sala s ON a.sala = s.id
	GROUP BY s.id;


DROP view IF EXISTS natt_palestra;
CREATE view natt_palestra AS
		  SELECT p.Codice, sum(n.att_sala) AS att_pal
          FROM Palestra p JOIN natt_sala n ON p.Codice = n.Palestra
          GROUP BY p.Codice
          ORDER BY att_pal DESC;


DROP view IF EXISTS sotto_media;
CREATE view sotto_media AS
	SELECT q.città, q.Manager, q.codice AS cod_pal, 
           cast(avg(d.stipendio) as DECIMAL(10,2)) as stip_medio
	FROM palestra q JOIN dipendente d ON q.codice = d.palestra
            GROUP BY q.Codice
           HAVING avg(d.Stipendio)<1500;



/* Query */

/* 1. Mostrare informazioni dei Dipendenti che sono Trainer Interni o Esterni che hanno uno stipendio minore di 1500 e hanno o ottenuto il certificato di PrimoSoccorso o che hanno più di 5 anni di Esperienza */
 SELECT *
FROM	(	(SELECT Nome, Cognome, Stipendio, PrimoSoccorso, AnniEsperienza,
    Palestra
			FROM Dipendente d JOIN Interno i ON d.CF = i.Dipendente
			WHERE i.PrimoSoccorso = TRUE OR i.AnniEsperienza >= 5)
		union
			(SELECT Nome, Cognome, Stipendio, PrimoSoccorso,
     AnniEsperienza, Palestra
			FROM Dipendente d JOIN Esterno e ON d.CF = e.Dipendente
			WHERE e.PrimoSoccorso = TRUE OR e.AnniEsperienza >= 5) 
		) AS tq
WHERE tq.Stipendio <= 1400
ORDER BY tq.Palestra, tq.Stipendio;


/* 2. Mostrare tutte le recensioni di una palestra che hanno valutazione maggiore della sua MediaVoto e che contengono recensione anche valutazione di un corso o che sono state lasciate su piattaforma “Google” , indicando a fianco il nome del cliente che l’ha scritta. */

SELECT c.Nome, r.Stelle, p.Città AS filiale, r.StelleCorso, r.Corso, r.Piattaforma
 FROM (rec_complete r JOIN cliente c ON c.numerotelefono=r.cliente) 
 	  JOIN Palestra p ON r.Palestra = p.Codice
 WHERE r.Stelle > p.MediaVoto 
 ORDER BY r.Palestra;

 /* 3. Mostrare i dati dei 5 clienti più attivi( maggior numero di sessioni prenotate + iscrizioni a corsi) mostrando informazioni tra cui anche la palestra frequentata */

SELECT c.Nome, c.Cognome, c.Palestra, a.tot_attivita, a.iscr_corsi AS Di_cui_Corsi
FROM Cliente c Join att_cliente a ON c.NumeroTelefono = a.Cliente
ORDER BY a.tot_attivita DESC limit 5;


/* 4. Mostrare per ogni palestra il primo cliente che ha prenotato una sessione */
SELECT cs.NumeroTelefono, cs.Palestra, cs.Nome, cs.Cognome, cs.data, cs.orainizio
FROM clienti_e_loro_sess cs JOIN pal_prima_sess pps ON cs.Palestra = pps.palestra
WHERE  cs.data = pps.primo_giorno_prnt AND cs.orainizio = pps.primo_orario_prnt
ORDER BY cs.data, cs.orainizio;


/* 5. Mostrare in ordine decrescente le Palestre in base a quanto sono attrezzate (cioè in base al numero di attrezzi nelle sale della Palestra) */
SELECT p.Codice, p.Città, p.MediaVoto, nap.att_pal as Num_Attrezzi_Totale
FROM Palestra p JOIN natt_palestra nap ON p.Codice = nap.Codice
ORDER BY nap.att_pal DESC;

/* 6. Mostrare le Palestre che hanno uno stipendio medio < 1500 con CF e cognome del manager (qui valore = 1500) */
SELECT s.cod_pal, s.manager, m.Cognome, s.stip_medio
FROM sotto_media s JOIN manager m on s.manager = m.cf;

