Functionaliteit:  Klanten koppelen aan een (lees 1) en/of meerdere projecten
  # is te specifiek, je kan er nog veel meer mee doen dan alleen filteren
  # b.v. in een lijstweergave de projecten groeperen per klant (= feature)
  Om de vindbaarheid van projecten te verhogen
  kan de Gebruiker klantgegevens gebruiken om projecten te filteren

Achtergrond:
  Gegeven het project "Website fiets.nl"
  En de klant "Fiets B.V."
  En de klant contactpersoon "Jan Bel"
  En de gebruiker "Leon de Graaf"

Scenario: Koppel een bestaande klant aan het project
  Gegeven dat de klant nog niet aan het project is toegevoegd
  Als het overzicht met klanten wordt getoond
  En de klant wordt gekozen
  Dan moet de klant aan het project zijn gekoppeld

Scenario: Een nieuwe klant vanuit het project aanmaken en koppelen
  Gegeven dat de klant nog niet bestaat in het systeem
  En dat de klant nog niet aan het project is toegevoegd
  En het overzicht met klanten wordt getoond
  Als de klant wordt aangemaakt in het systeem
  # Gebruiker kan in deze fase beslissen om de klant op te slaan maar 
  # niet meer te koppelen aan het project. Dit is om te voorkomen 
  # dat de gebruiker wederom alle klantgegevens moet invullen.
  En de klant wordt gekozen
  Dan moet de klant aan het project zijn gekoppeld

Scenario: Klant ontkoppelen van het project

Scenario: Meerdere klanten koppelen aan het project

# noodzakelijk?
Scenario: Klant aan meerdere projecten koppelen
  Gegeven de projecten "Huisstijl Fiets B.V." en "Website fiets.nl"
  Als 
