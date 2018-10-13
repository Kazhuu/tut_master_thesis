%title Sähköaseman älykkään elektroniikkalaitteen viestien tilaus ja prosessointi
%author Mauri Mustonen
%date 2018-09-04

-> # Diplomityön aihe <-

Toteutettu Alsus Oy:lle

Tarkoituksena suunnitella ja toteuttaa ohjelmistokomponentti
osaksi isompaa järjestelmää

Sähköasemien etäohjaukseen ja monitorointiin käytetty järjestelmä

-> +--------------------------+ <-
-> |       järjestelmä        | <-
-> |                          | <-
-> +-------------+            | <-
-> | komponentti |            | <-
-> +-------------+------------+ <-

---

-> # Komponentin tehtävä <-

Tilata ja prosessoida tietoa verkon yli sähköaseman älykkäältä
elektroniikkalaitteelta

Mittausdataa tai laitteen sen hetkistä tilaa

Tieto saatavaksi järjestelmän muille komponenteille

-> +----------+       viestejä       +-----------+ <-
-> |sähköasema| -------------------> |komponentti| <-
-> +----------+                      +-----------+ <-

---

-> # Lähtötilanne <-

Demoversio toteutettu ennen työn aloitusta, (proof of concept)

Ongelmia:
* muistivuoto
* suorityskyky
* säädettävyys
* epävarmuus

Uusi versio, jossa ei olisi ongelmia toiminnan kanssa

---

-> # Tutkimuskysymykset <-

Mitkä ohjelmiston arkkitehtuurin suunnittelumallit olisivat
sopivia tämän kaltaisen ongelman ratkaisemiseen?

Kuinka järjestelmä hajautetaan ja viestien tieto saadaan
järjestelmän muille komponenteille?

Järjestelmän hajautuksessa, mikä olisi sopiva tiedon jakamisen
muoto eri osapuolten välillä?

---

-> # Älykäs elektroniikkalaite? <-

Sähköaseman ohjaukseen ja suojaukseen käytetty automaatiolaite,
josta käytetään myös nimitystä suojarele

Intelligent Electronic Device, *IED*

Monitoroi ja suojaa sähköverkkoa ja laitteita vikatilanteissa

Verkkoon kytketty laite ja voivat kommunikoida keskenään

Sähkölinjan vikatilanteessa katkaisee linjasta virrat

---

-> # Standardi yhteiseen kommunikointiin <-

Maailmanlaajuinen *IEC 61850* -standardi aseman kommunikoinnin
määrityksiin

Abstrahoida funktiot ja laitteet kommunikointia varten

-> +----------------------------------+             <-
-> |           Sähköasema             |             <-
-> |                                  |             <-
-> | +---+      IEC 61850     +---+   | IEC 61850   <-
-> | |IED| <----------------> |IED| <-------------> <-
-> | +---+                    +---+   |             <-
-> +----------------------------------+             <-

---

-> # Työn prosessi <-

Työ koostui seuraavista työvaiheista:
* Standardi opiskella ja ymmärtää
* Demon ongelmat analysoida ja ymmärtää mistä johtuvat
* Suunnitella ja pohtia eri toteutus vaihtoehtoja
* Pohtia kuinka tieto saadaan järjestelmän eri komponenteille
* Miettiä jaetun tiedon lopullinen muoto
* Komponentin toteutus ja testaus
* Raportin kirjoitus

---

-> # Demon arkkitehtuuri <-

->                                              +-----------+ <-
->                                      +-----> |komponentti| <-
->                                      |       +-----------+ <-
->                                      |                     <-
->      IEC 61850                       v                     <-
-> +---+        +----+       +----------+       +-----------+ <-
-> |IED| +----> |demo| +---> |tietokanta| <---> |komponentti| <-
-> +---+        +----+       +----------+       +-----------+ <-
->                                      ^                     <-
->                                      |                     <-
->                                      |       +-----------+ <-
->                                      +-----> |komponentti| <-
->                                              +-----------+ <-

---

-> # Toteutuksen arkkitehtuuri <-

->                                            JSON   +-----------+ <-
->                                             +---> |komponentti| <-
->                                             |     +-----------+ <-
->                                             |                   <-
->      IEC 61850          JSON                |                   <-
-> +---+        +-------+         +--------+   |     +-----------+ <-
-> |IED| +----> |rcb_sub| +-----> |RabbitMQ| +-+---> |komponentti| <-
-> +---+        +-------+         +--------+   |     +-----------+ <-
->                                             |                   <-
->                                             |                   <-
->                                             |     +-----------+ <-
->                                             +---> |komponentti| <-
->                                                   +-----------+ <-

---

-> # rcb_sub <-

Komentorivi-pohjainen ohjelmisto C-kielellä
Linux-käyttöjärjestelmälle

Käytetyt kirjastot:        Numeroita:
* libiec61850              +- 1666 LOC
* jansson                  +- 9 .h tiedostoa
* rabbitmq-c               +- 10 .c tiedostoa
* Argp

Ottaa kaikki tiedot komentoriviparametreinä, ei tarvita erillistä
tietokantaa

---

-> # Haasteet <-

Standardin ymmärtäminen ja määritysten toiminta

Hajautuksen pohtiminen, ei aikaisempaa kokemusta

Todella paljon uutta asiaa ja opittavaa

---

-> # Tulokset <-

Tuloksena toimiva ohjelmisto

Osaksi tuotantoa ja isompaa järjestelmää

Demon ongelmat analysoitu ja tieto käytetty ratkaisemaan ne
uudessa toteutuksessa

JSON-muoto helposti luettavissa muilla ohjelmointikielillä

Tieto saatavissa muille komponenteille
RabbitMQ-välittäjäpalvelimen ansiosta

---

-> # Parannettavaa <-

Testausympäristö ja yksikkötestit

Projektin kääntäminen toteuttaminen CMake-ohjelmistolla
Make-ohjelmiston sijaan

Lisätä toiminnallisuutta joustavuutta varten

---

-> # Linkit <-

-> Tämä esitys toteutettu mdp-ohjelmalla <-
-> *https://github.com/visit1985/mdp* <-

-> Tekijän GitHub-tili <-
-> *https://github.com/kazooiebombchu* <-

-> Diplomityö ja tämä esitys saatavissa GitHub:sissa <-

---

-> # Kiitos mielenkiinnostanne! <-


-> GitHub: _*kazooiebombchu*_ <-
