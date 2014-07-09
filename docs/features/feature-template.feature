Functionaliteit: Feature templates maken en beheren
  Om features van een project niet bij elk nieuw project te hoeven herschrijven
  wil ik als Gebruiker standaard features kunnen hergebruiken in mijn projecten
  zodat ik tijd bespaar en ik meer aandacht kan besteden aan klantspecifieke
  details van het project

  # 2. Standaard definitie van een feature
  # 3. Leesbaar voor verschillende soorten partijen (o.a. designer, developer, klant, projectmanager)
  # 4. Door ervaring kan een standaardprijs en tijd worden berekend per feature 
  #    (bv: feature 1, 2 en 5 is 500 euro omdat feature 1 tijd += 20 uur, en feature 2 en 5 += 30)
  # 5. Feature kan zodanig in code worden gestandardiseerd dat deze bij volgende projecten inplugbaar zijn

Achtergrond:
  Gegeven het project "Website fiets.nl"
  En de klant "Fiets B.V."
  En "Jan Bel" als contactpersoon van de klant
  En de gebruiker "Leon de Graaf"

Scenario: Nieuwe feature template toevoegen aan het project

Scenario: Feature template aanpassen in het project
  Gegeven dat de feature reeds is toegevoegd aan het project
  Als de feature is bijgewerkt 
  En is opgeslagen
  Dan moet de feature enkel zijn bijgewerkt voor het project
  En niet voor te feature template

Scenario: Feature template verwijderen

Scenario: Feature template bijwerken

Scenario: Nieuwe feature template aanmaken op basis van een bestaande feature template
  Gegeven dat er reeds de feature template "Contactformulier" bestaat
  Als de feature wordt gekopieerd
  Dan moet er nieuwe feature zijn aangemaakt met dezelfde inhoud als de originele feature
  En moet de nieuwe feature een referentie bevatten naar de originele feature

Scenario: Nieuwe featuretemplate  aanmaken op basis van een bestaande feature in het project