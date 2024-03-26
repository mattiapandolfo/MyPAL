#include <cstdio>
#include <iostream>
#include <iomanip>
#include <string>
#include "./dependencies/include/libpq-fe.h"

using namespace std;

#define PG_HOST  "localhost"    
#define PG_USER  "postgres"     //il vostro nome utente
#define PG_DB    "DB_MyPAL"       //il nome che verrà dato database, qui diamo DB_MyPAL
#define PG_PASS  "password"     //la vostra password 
#define PG_PORT  5432

void checkResults(PGresult* res, const PGconn* conn) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << "------------ERROR------------\nRisultati inconsistenti!" << PQerrorMessage(conn) << endl;
        cout << "-----------------------------\n";
        PQclear(res);
        exit(1);	
    } else {
        cout << "------------OK------------\nRisultati senza problemi \n--------------------------\n";
    }
}

void print(PGresult * res)
	{
		if(res==0) return;
		
		int tuple = PQntuples(res);
		int campi = PQnfields(res);
		
		cout << "\nOUTPUT: \n\n";
		
		for (int i=0; i<campi; ++i) {
			cout << left << setw(20) << PQfname(res, i);
		}
		cout << "\n\n"; 
		for(int i=0; i<tuple; ++i) {
			for (int n=0; n<campi; ++n) {
				cout << left << setw(20) << PQgetvalue(res, i, n);
			}
			cout << '\n';
		}
		cout<<'\n'<< endl;
        PQclear ( res );
	}

int main(int argc, char** argv) {
    //Setup connessione a DB

    cout << "Setup connessione a DB ...\n";
    char conninfo[250];
    sprintf(conninfo, "user=%s password=%s dbname=%s host=%s port=%d",
            PG_USER, PG_PASS, PG_DB, PG_HOST, PG_PORT);

    PGconn * conn = PQconnectdb (conninfo); 
    
    if(PQstatus(conn) != CONNECTION_OK) {
        cerr<<"     ...ERROR :: Errore di connessione\n" << PQerrorMessage(conn);
        PQfinish(conn);
        exit(1);
    } 
    cout <<"    ...OK :: Connessione avvenuta correttamente\n";

    bool ESC = true;
    PGresult *res;

    while(ESC) {
        cout<<endl;
        cout << "BENVENUTI, le seguenti sono le query attualmente visualizzabili:\n\n";
        cout << "1) Mostrare informazioni dei Dipendenti che sono Trainer Interni o Esterni che hanno \n";
        cout << "   uno stipendio minore di 1500 e hanno o ottenuto il certificato di PrimoSoccorso o che \n";
        cout << "   hanno piu' di 5 anni di Esperienza\n";
        cout << "2) Mostrare tutte le recensioni di una palestra che hanno valutazione maggiore della sua MediaVoto\n";
        cout << "   e che contengono anche valutazione di un corso o che sono state lasciate su piattaforma “Google”, \n";
        cout << "   indicando a fianco il nome del cliente che l’ha scritta.\n";
        cout << "3) Mostrare i dati dei 5 clienti piu' attivi (maggior numero di sessioni prenotate + iscrizioni a corsi)\n";
        cout << "   mostrando informazioni tra cui anche la palestra frequentata (n parametro)\n";
        cout << "4) Mostrare per ogni palestra il primo cliente che ha prenotato una sessione\n";
        cout << "5) Mostrare in ordine decrescente le Palestre in base a quanto sono attrezzate\n";
        cout << "   (cioe' in base al numero di attrezzi nelle sale della Palestra)\n";
        cout << "6) Mostrare le Palestre che hanno uno stipendio medio < 1500 con CF e cognome del manager \n\n";

        cout << "=====>INSERIRE numero della query che si vuole visualizzare [0 per uscire]: ";
        int the_chosen_one = 0;
        cin >> the_chosen_one;

        while(the_chosen_one < 0 || the_chosen_one > 6) {
            cout << "--------------------------------OUT OF RANGE--------------------------------\nNumero scelto e' OUT_OF_RANGE, si prega di REINSERIRE un numero tra 1->6 \n";
            cout << "----------------------------------------------------------------------------\n\n";
            cout << "=====>INSERIRE numero della query che si vuole visualizzare [0 per uscire]: ";
            cin >> the_chosen_one;
        }

        if(the_chosen_one == 0) ESC = false;
        else {
            switch (the_chosen_one) {
                case 1:
                        res = PQexec(conn, "SELECT * \
                                            FROM	(	(SELECT Nome, Cognome, Stipendio, PrimoSoccorso, AnniEsperienza, Palestra \
			                                             FROM Dipendente d JOIN Interno i ON d.CF = i.Dipendente \
			                                             WHERE i.PrimoSoccorso = TRUE OR i.AnniEsperienza >= 5) \
		                                            union \
			                                            (SELECT Nome, Cognome, Stipendio, PrimoSoccorso,AnniEsperienza, Palestra \
			                                             FROM Dipendente d JOIN Esterno e ON d.CF = e.Dipendente \
			                                             WHERE e.PrimoSoccorso = TRUE OR e.AnniEsperienza >= 5) \
		                                            ) AS tq \
                                            WHERE tq.Stipendio <= 1400 \
                                            ORDER BY tq.Palestra, tq.Stipendio" );
                        checkResults(res, conn);
                        print(res);
                        break;
                case 2:
                        res = PQexec(conn, "SELECT c.Nome, r.Stelle, p.Città AS filiale, r.StelleCorso, r.Corso, r.Piattaforma \
                                            FROM (rec_complete r JOIN cliente c ON c.numerotelefono=r.cliente) \
 	                                        JOIN Palestra p ON r.Palestra = p.Codice \
                                            WHERE r.Stelle > p.MediaVoto \
                                            ORDER BY r.Palestra" );
                        checkResults(res, conn);
                        print(res);
                        break;
                case 3:
                        res = PQexec(conn, "SELECT c.Nome, c.Cognome, c.Palestra, a.tot_attivita, a.iscr_corsi AS Di_cui_Corsi \
                                            FROM Cliente c Join att_cliente a ON c.NumeroTelefono = a.Cliente \
                                            ORDER BY a.tot_attivita DESC limit 5;" );
                        checkResults(res, conn);
                        print(res);
                        break;
                case 4:
                        res = PQexec(conn, "SELECT cs.NumeroTelefono, cs.Palestra, cs.Nome, cs.Cognome, cs.data, cs.orainizio \
                                            FROM clienti_e_loro_sess cs JOIN pal_prima_sess pps ON cs.Palestra = pps.palestra \
                                            WHERE  cs.data = pps.primo_giorno_prnt AND cs.orainizio = pps.primo_orario_prnt \
                                            ORDER BY cs.data, cs.orainizio" );
                        checkResults(res, conn);
                        print(res);
                        break;
                case 5:
                        res = PQexec(conn, "SELECT p.Codice, p.Città, p.MediaVoto, nap.att_pal as Num_Attrezzi_Totale \
                                            FROM Palestra p JOIN natt_palestra nap ON p.Codice = nap.Codice \
                                            ORDER BY nap.att_pal DESC" );
                        checkResults(res, conn);
                        print(res);
                        break;
                case 6: 
                        res = PQexec(conn, "SELECT s.cod_pal, s.manager, m.Cognome, s.stip_medio \
                                            FROM sotto_media s JOIN manager m on s.manager = m.cf" );
                        checkResults(res, conn);
                        print(res);
                        break;
            }
        }
        system("pause");
    }
    PQfinish(conn);
}


// g++ AccessoDB.cpp -L dependencies\lib -lpq -o AccessoDB
