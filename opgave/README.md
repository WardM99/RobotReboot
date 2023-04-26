# Opgave Project Logisch Programmeren

De opgave van dit jaar bestaat uit het implementeren van de [Robot Reboot](http://www.robotreboot.com/challenge) puzzel.
In dit document geven we een overzicht van de verwachte basis functionaliteit. Verder geven we de vereisten waaraan je project moet voldoen. Studenten worden aangemoedigd om zelf extra functionaliteit te voorzien.

## Robot Reboot

De laatste jaren werden dagelijkse puzzels zoals Wordle heel populair op het internet.
Zo is er ook de dagelijkse online puzzel [Robot Reboot](http://www.robotreboot.com/challenge) dat gebaseerd is op het bordspel Ricochet Robots.
Het spel bestaat uit een bord omringd door muren met een aantal gekleurde robots.
Op willekeurige plekken in het bord zijn muren geplaatst als obstakels voor de robots.
Het doel van het spel is om in zo weinig mogelijk zetten één specifieke robot naar een bepaald vakje te brengen.
In één zet, kan je één enkele robot bewegen.
Een robot beweegt steeds in een rechte lijn tot het een obstakel tegen komt, dat kan een muur of een andere robot zijn.

In dit project implementeer je een command-line interface om dit spel te spelen.
Je command-line spel moet een unicode representatie van het spelbord accepteren via standaard invoer om een spel te laden.
In de spelmodus, moet steeds het huidige bord weergegeven worden via standaard output.
Een speler dient via de command-line zetten te kunnen spelen.
Naast een interactieve modus, moet jouw programma ook de optimale oplossing kunnen berekenen en willekeurige puzzels genereren.

## Voorstelling invoer en uitvoer

Je programma hoort via standaard in- en uitvoer een puzzel in te lezen en uit te schrijven.
Een puzzel bestaat uit een aantal robots, een spelbord, en één doel.

Een puzzel wordt weergegeven door unicode karakters, hieronder tonen we een voorbeeld voor een 4-op-4 puzzel met 2 robots, ■ en ▣, en een doel ◎.
Merk op dat elk vakje steeds één karakter groot is, en er tussen elk vakje steeds ruimte gelaten is van exact één karakter voor het weergeven van mogelijke muren.

```
┏━━━┳━━━┓
┃■  ┃   ┃
┃      ━┫
┃    ▣  ┃
┃  ━┓   ┃
┃  ◎┃   ┃
┃       ┃
┃ ┃     ┃
┗━┻━━━━━┛
```

De muren worden voorgesteld door de karakters in onderstaande tabel, dit zijn [heavy box drawing characters](https://en.wikipedia.org/wiki/List_of_Unicode_characters#Box_Drawing).
Een robot wordt steeds voorgesteld door een enkel unicode karakter dat niet voorkomt in deze tabel.
Het karakter van een robot is ook steeds uniek.
Een puzzel heeft steeds een rechthoekig bord, waarbij er nooit gaten zijn in de buitenste muren.

| Type muur                   | Karakter  | Unicode |
| --------------------------- | --------- | ------- |
| Horizontal                  | ━         | U+2501  |
| Vertical                    | ┃         | U+2503  |
| Top left corner             | ┏         | U+250F  |
| Top right corner            | ┓         | U+2513  |
| Bottom left corner          | ┗         | U+2517  |
| Bottom right corner         | ┛         | U+251B  |
| Vertical connector left     | ┣         | U+2523  |
| Vertical connector right    | ┫         | U+252B  |
| Horizontal connector top    | ┳         | U+2533  |
| Horizontal connector bottom | ┻         | U+253B  |

De robots worden weergegeven door de unicode karakters in onderstaande tabel, en hebben elk een eigen volgnummer.
De robot met volgnummer 0, ▣, is steeds diegene die naar het doel moet.
Het doel wordt aangeduid door het *bullseye* unicode karakter, ◎ (U+25CE).

| Robot index | Karakter  | Unicode |
| ----------- | --------- | ------- |
| 0           | ▣         | U+25A3  |
| 1           | ■         | U+25A0  |
| 2           | ▲         | U+250F  |
| 3           | ◆         | U+25C6  |
| 4           | ◇         | U+25C7  |
| 5           | ◈         | U+25C8  |
| 6           | ◉         | U+25C9  |
| 7           | ◩         | U+25E9  |
| 8           | ◭         | U+25ED  |
| 9           | ◲         | U+25F2  |

Oplossingen voor de puzzels worden geëncodeerd als een lijst van bewegingen.
Een beweging bestaat uit het volgnummer van een robot, gevolgd door een richting: U (up), R (right), D (down), of L (left).

De optimale oplossing voor de voorbeeldpuzzel ziet er dan zo uit:

```
0D,0L,0U
```

Elke zet beweegt slechts 1 robot.

## Spelen van de puzzel (interactieve modus)

Je programma moet in staat zijn spelers de puzzel te laten spelen via de command-line.

Voor het spelen van het spel wordt jouw programma opgeroepen met de `--game` optie, en het bord ingelezen via een bestand.
We verwachten dat het programma op de volgende manier kan opgeroepen worden:

```bash
> swipl main.pl -- '--game=[{PAD}]'
```

Waarbij `{PAD}` vervangen moet worden met het pad naar het inputbestand met de bordvoorstelling.

Tijdens de interactieve modus, is het de bedoeling dat het volledige scherm hertekenend wordt als het bord bijgewerkt wordt.
Gebruik hiervoor de [ANSI X3.64 Escape sequences](https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797).
Gebruik steeds de hexadecimale representaties. In prolog voor `ESC` wordt dit dan: `"\x1B\"`.
Je kan de Escape sequences ook gebruiken om kleur aan je spel toe te voegen.
Je dient de ANSI Escape sequences enkel te gebruiken in de interactieve modus.

Tijdens een interactief spel geeft je programma steeds de huidige staat van het bord weer met de robots en het doel.
Je kiest zelf hoe je spel er uitziet.
Het printen van het bord op exact dezelfde manier als de invoer, wordt beschouwd als de meest minimaal aanvaardbare versie.
Je wordt dus aangemoedigd om je interactief spel zelf op te leuken.

We laten je ook vrij om zelf te kiezen hoe een speler robots beweegt tijdens het spel.
Zo kan je bijvoorbeeld spatie of tab gebruiken om robots te selecteren, en de pijltjestoetsen om te bewegen.

Als een speler de puzzel oplost, moet de puzzel verdwijnen en een overwinningsscherm getoond worden.
Dit scherm mag er uitzien zoals je zelf wilt, maar moet minstens een kleur accent bevatten.
Als de speler dan op enter duwt, moet het programma afsluiten.

## Oplossen van de puzzel

Als je programma de `--solve` optie meekrijgt, moet het de optimale oplossing uitschrijven naar standaard uitvoer.
We verwachten dat het programma dan op de volgende manier kan opgeroepen worden:

```bash
> cat input | swipl main.pl -- --solve
0D,0L,0U
```

We raden aan om de [optparse](https://www.swi-prolog.org/pldoc/doc/_SWI_/library/optparse.pl) library te gebruiken voor het parsen van de opties.

## Puzzels genereren

Als je programma de `'--gen=[{aantal robots},{breedte},{hoogte}]'` optie meekrijgt, dient het een random puzzel te genereren met een willekeurig doel en een rechthoekig bord van de gegeven hoogte en breedte, en met het gespecifieerde aantal robots.
Zowel de positie, als het aantal muren moet willekeurig zijn.
Ook de startposities van de robots dienen willekeurig gekozen te worden.
Naast het bord, moet het commando ook de optimale oplossing teruggeven.

Voorbeeld van het commando oproepen:

```bash
> swipl main.pl -- '--gen=[2,4,4]'
```

De output voor dit commando moet dezelfde voorstelling gebruiken als de invoer. (zie de uitleg over *Voorstelling invoer en uitvoer*)
Voor de robots gebruik je dus ook steeds dezelfde karakters als de test invoer, waarbij robot met volgnummer 0, ▣, steeds aanwezig moet zijn.
Het aanroepen van dit commando voor meer dan 10, of 0 robots, is niet geldig.

De optimale oplossing geef je terug op de eerste lijn na het bord.

## Test modus

Als je programma de `'--test=[{Robot index},{Direction}]'` optie meekrijgt, moet het via de standaard invoer een puzzel inlezen en de gegeven stap uitvoeren.

Als het een geldige stap ontvangt, dient het programma het geüpdatete bord naar standaard uitvoer uit te schrijven. Deze output moet dezelfde voorstelling gebruiken als de invoer. (zie de uitleg over *Voorstelling invoer en uitvoer*)

## Niet functionele eisen

Naast de basisfunctionaliteit vragen we enkele niet functionele eisen waar je
project aan dient te voldoen. Deze niet functionele eisen zijn even belangrijk
als de functionele eisen van het project.

- De code moet goed gedocumenteerd zijn, er moet commentaar geschreven zijn voor praktisch elk predicaat. Indien je de gestructureerde comments wilt volgen zoals die in de officiële documentatie gebruikt wordt, verwijzen we u naar [deze pagina](https://www.swi-prolog.org/pldoc/man?section=pldoc-comments).
- Je code moet getest zijn, dit wil zeggen dat je voor elk van de bewegingen zelf een test schrijft zodat je zeker bent dat de basis functionaliteit werkt. Gebruik hiervoor bijvoorbeeld [PLUnit](https://www.swi-prolog.org/pldoc/man?section=unitbox).
- Voor het vinden van de optimale oplossing gebruik je een variant van breadth first search of depth first search, zoals gezien in de hoorcolleges.

## Verslag

We verwachten een bondig verslag die de implementatie van je command-line puzzel beschrijft. Voeg aan je verslag je code toe met lijnnummers zodat je in de uitleg van je verslag kan verwijzen naar de relevante delen van je code. Je bent zelf vrij hoe je dit verslag organiseert, maar we verwachten op zijn minst de volgende onderdelen:

- Inleiding
- De besturing van je spel (beschrijf duidelijk hoe we je spel kunnen spelen)
- Interne bord voorstelling
- Algoritme voor zowel het oplossen als het genereren van puzzels (steeds met kort voorbeeld)
- Conclusie (wat heb je gerealiseerd en wat kan beter)

## Boilerplate

Via SubGIT kan je de opgave samen met boilerplate voor het project downloaden. (instructies vind je onder de sectie *Indienen*)

In de repository vind je onder de `opgave` folder nogmaals dit document.
Onder de `src` folder vind je al een minimaal skelet voor je project.
Deze code geeft je een idee van hoe in prolog een game lus kan geprogrammeerd worden.
De code voor het animeren van het scherm vind je in `animate.pl`.
In `main.pl` wordt de `animate` library gebruikt om een simpele teller te implementeren.

De voorziene code heeft nog niet het nodige niveau van abstractie, maar wordt gegeven zodat je vlot kan starten.
Het is met andere woorden, de bedoeling dat je ook de animate library aanpast op basis van de noden voor jouw project.

## Checklist

Je project is veel meer dan enkel de command-line interface, hieronder een
checklist om na te gaan of je alle onderdelen hebt afgewerkt.

- [ ] Interactieve modus voor het spelen van de puzzel
- [ ] Overwinningsscherm in de interactieve modus
- [ ] Oplossen van de puzzel (`--solve` argument)
- [ ] Genereren van puzzels (`--gen` argument)
- [ ] Test modus (`--test` argument)
- [ ] Code documentatie
- [ ] Testcode
- [ ] Verslag
- [ ] Alles pushen naar `master` op
      `git@subgit.ugent.be:2022-2023/LP/Project/{studentnr}`

# Indienen

## Bestandenstructuur

Je project moet volgende structuur hebben:

- `src/` bevat alle broncode (inclusief `main.pl`).
- `tests/` alle testcode.
- `extra/verslag.pdf` bevat de elektronische versie van je verslag. In deze map
  kun je ook eventueel extra bijlagen plaatsen.

Je directory structuur ziet er dus ongeveer zo uit:

```
|
|-- extra/
|   `-- verslag.pdf
|-- src/
|   |-- main.pl
|   `-- je broncode
`-- tests/
    `-- je testcode
```

## Compileren

De code zal bij het indienen getest worden met de opdracht `cat input | swipl src/main.pl -- '--solve'` door SubGIT met SWI Prolog versie 8.2.4. Het input bestand bevat het voorbeeld spelbord uit dit document.
De Dockerfile en bijhorende bronbestanden die SubGIT gebruikt om je code te compileren en minimale testen op uit te voeren vind je op `git@subgit.ugent.be:2022-2023/LP-dockerfile`.
Je kunt deze Docker ook onmiddellijk van Dockerhub halen met volgende commando's:

```bash
docker pull tolauwae/lp-project-2022-2023:latest
docker run -it --rm --mount type=bind,source={PAD},destination=/submission,readonly tolauwae/lp-project-2022-2023:latest
```

Waarbij `{PAD}` vervangen moet worden met het absolute pad naar je project.

## SubGIT

Het indienen gebeurt via het [SubGIT](https://subgit.ugent.be/) platform.
Als je hier nog geen account op hebt, dien je deze aan te maken.

### Repository afhalen

```bash
git clone git@subgit.ugent.be:2022-2023/LP/Project/{studentnr} reboot
```

### Opgave als upstream instellen

Je kunt de opgave en boilerplate voor het project afhalen door de opgave repository als upstream met volgende commando's in de `reboot` map:

```bash
git remote add upstream git@subgit.UGent.be:2022-2023/LP/Project-assignment
git pull upstream master
```

Je kunt de laatste versie van de opgave afhalen met `git pull upstream master`.
Als je geen wijzigingen hebt aangebracht aan de `opgave` map zou die pull steeds zonder problemen moeten verlopen.

### Feedback

Als je pusht naar SubGIT, zul je in je terminal te zien krijgen of je code voldoet aan de minimumvereisten.
In dat geval krijg je bij het pushen de melding dat het pushen geslaagd is:

```
remote: Acceptable submission
```

Je kunt geen code pushen naar de `master` branch als die niet compileert of niet aan de minimale IO vereisten voldoet.
Je kunt steeds pushen naar alle andere branches en daar zal je push aanvaard worden ongeacht het slagen van de testen.

### `master` branch

De `master` branch op SubGIT stelt jouw ingave voor.
Je kunt voor de deadline zoveel pushen als je wilt.
Zorg ervoor dat je voor de deadline zeker je finale versie naar de **`master`** branch hebt gepushed. (niet: `main`, wel: `master`)

### Controleren of je zeker goed hebt ingediend

Je kunt je indiening bekijken door je repository nog eens te klonen in een andere map:

```
cd eenAndereMap
git clone git@subgit.ugent.be:2022-2023/LP/Project/{studentnr} projectLPControle
```

## Deadlines

Na **2023-05-15 om 12:00:00** kun je geen wijzigingen meer aanbrengen aan je SubGIT repo.
De code in de `src` map, de testen in de `test` map en het verslag in `extra/verslag.pdf` zijn je finale indiening.
Voor de deadline kun je zo veel pushen naar master als je wilt, we raden je ook aan geregeld te pushen.

# Algemene richtlijnen

- Schrijf efficiënte code, maar ga niet over-optimaliseren: **geef de voorkeur
  aan elegante, goed leesbare code**. Kies zinvolle namen voor predicaten en
  variabelen en voorzie voldoende commentaar.
- Deze opgave beschrijft hoe je kunt testen of jouw code aan de minimumvereisten
  van het project voldoet. Als de "docker" container niet `AANVAARD`
  uitschrijft en stopt met exit code 0 voldoet je code niet aan de minimale
  vereisten. Projecten die niet aan de minimale vereisten voldoen kunnen geen
  punten opleveren. Het "hard coderen" van testgevallen is niet toegelaten.
- Het project wordt gequoteerd op **10** van de 20 te behalen punten voor dit
  vak. Als de helft niet wordt behaald, is je eindscore het minimum van je
  examencijfer en je score op het project.
- Projecten die ons niet (via de `master` branch op SubGIT) bereiken voor de
  deadline worden niet meer verbeterd: dit betekent het verlies van alle te
  behalen punten voor het project.
- Dit is een individueel project en dient dus door jou persoonlijk gemaakt te
  worden. **Het is ten strengste verboden code uit te wisselen**, op welke
  manier dan ook. Het overnemen van code beschouwen we als fraude (van **beide**
  betrokken partijen) en zal in overeenstemming met het examenreglement
  behandeld worden. Het overnemen of aanpassen van code gevonden op internet is
  ook **niet toegelaten** en wordt gezien als fraude.
- Vragen worden mogelijks **niet** meer beantwoord tijdens de laatste week voor
  de finale deadline.

# Vragen

Als je vragen hebt over de opgave of problemen ondervindt, dan kun je je vraag
stellen via [mail](mailto:tom.lauwaerts@ugent.be). Vermeld ook steeds je studentennummer (dan kunnen we gemakkelijk
je code clonen) en een 
"[minimal breaking example](https://stackoverflow.com/help/minimal-reproducible-example)".
Stuur geen screenshots van code.

