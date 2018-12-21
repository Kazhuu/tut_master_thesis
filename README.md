# Master thesis

My master thesis written for the Tampere University of Technology in LaTeX.
Thesis language is Finnish. DPud release can be found
[here](http://URN.fi/URN:NBN:fi:tty-201811212705).

## Substation’s intelligent electronic device messages subscription and
processing

Electric grids are an important part of society today. It consists of power
plants, power lines and substations. These components allow delivering
electricity from power plants to the end users. Substations and their automation
play an important role in guaranteeing power grid safety and functionality. The
focus of this master thesis is to plan and implement a software component that
utilizes distributed system architecture. The component is intended to be a part
of a larger system related to the substations. It subscribes information from
the substation and shares it with other parts of the system. The information
from the substation can include different types of data, such as measurement
data which is shown on the user interface.

The information is subscribed from an Intelligent Electronic Device (IED) in
substations. An IED is an automation device which controls the other physical
devices of the substation. IEDs are connected to the substation's local network.
IED can also be referred to as "protection relay". The International
Electrotechnical Commission has defined a worldwide standard called IEC 61850
that defines the rules for how IED-devices and software outside of the
substation need to communicate with each other over the network.

A proof of concept software component had already been developed before the
start of this thesis. However, this component had many problems which did not
encourage its further development. Analyzing these problems is a part of this
thesis. The new information is then used to design the new software.

The result of this thesis is a software component that utilizes a distributed
system architecture. The component can subscribe to information from the IED
according to the IEC 61850 standard and share it with the other parts of the
system.

## Sähköaseman älykkään elektroniikkalaitteen viestien tilaus ja prosessointi

Sähkönjakeluverkot ovat tärkeä osa nykyistä yhteiskuntaa ja sen päivittäistä
toimintaa. Sähköverkko koostuu sähköntuotantolaitoksista, sähkölinjoista ja
sähköasemista. Sähköverkon eri komponenttien avulla sähkö toimitetaan
tuotantolaitoksista kuluttajille. Sähköasemat ja niiden automatisointi ovat
tärkeässä osassa verkon yleisen toiminnan ja turvallisuuden takaamiseksi. Tässä
diplomityössä keskitytään suunnittelemaan ja toteuttamaan hajautetun
järjestelmän arkkitehtuuria hyödyntävä ohjelmistokomponentti. Komponentin on
tarkoitus olla osa isompaa sähköasemiin liittyvää järjestelmää. Se tilaa tietoa
sähköasemalta verkon yli ja jakaa sen järjestelmän muiden komponenttien kanssa.
Sähköasemalta tuleva tieto sisältää esimerkiksi mittaustietoa, jota näytetään
käyttöliittymässä.

Sähköasemilta tieto tilataan älykkäiltä elektroniikkalaitteilta (Intelligent
Electronic Device, IED). IED:t ovat sähköaseman verkkoon kytkettyjä
automaatiolaitteita, joista käytetään myös nimitystä suojarele. IED-laitteiden
kommunikointiin liittyy maailmanlaajuinen IEC 61850 -standardi (International
Electrotechnical Commission). Standardi määrittää kuinka IED-laitteet ja niihin
yhteydessä olevat ohjelmat kommunikoivat verkon yli.

Ohjelmasta oli toteutettu demo ennen työn aloitusta, joka todisti osien
toimivuuden. Demototeutuksessa oli ongelmia, jotka haittasivat sen
jatkokehitystä. Tässä työssä demoa käytetään pohjana uuden version
suunnittelulle. Demosta analysoidaan sen ongelmia ja mistä ne johtuivat. Näitä
tietoja käytetään uuden komponentin tekniikan suunnitteluun.

Tuloksena on hajautetun järjestelmän arkkitehtuuria hyödyntävä
ohjelmistokomponentti, joka kykenee tilaamaan viestejä IED-laitteelta IEC 61850
-standardin mukaisesti. Komponentti kykenee prosessoimaan ja jakamaan tilatut
viestit järjestelmän muiden komponenttien kanssa.

## Softwares used

Thesis tex files are written with [TexStudio](https://www.texstudio.org/).
Pictures are done with [Inkscape](https://inkscape.org/en/) and are located
under pictures folder. All pictures have original svg files associated with
them. UML diagrams under uml folder are written and drawn using
[PlantUML](http://plantuml.com/). Presentation under presentation folder is a
command-line based markdown presentation with ASCII pictures and it's done with
[mdp](https://github.com/visit1985/mdp).

## Copyright

This publication is copyrighted. You may download, display and print it for Your
own personal use. Commercial use is prohibited. Exception to this are original
svg, picture and uml files. These can be freely used and modified by anyone.
