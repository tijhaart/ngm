Functionaliteit: Toegang tot app op verschillende niveaus beperken of toestaan voor gebruikers

Scenario: Gebruiker inloggen die nog geen account heeft

Scenario: Gebruiker inloggen wanneer deze nog niet eerder is ingelogd
  Gegeven dat gebruiker "John" nog niet is ingelogd
  En reeds een account heeft aangemaakt
  Als de gebruiker naar de app navigeert
  Dan moet de gebruiker de mogelijkheid hebben om zijn logingegevens in te voeren
  # "toegang" is in dit geval nog vaag en heeft nog een afgebakende beschrijving nodig
  # "toegang beperkt tot de mogelijkheden van de gebruiker"
  En na succesvol inloggen, toegang krijgen tot de app

Scenario: Inloggen en toegang onthouden
  Gegeven dat gebruiker "John" zijn login heeft laten onthouden
  En is ingelogd
  # verlopen sessies zijn: browser/tab/pc afgesloten
  En zijn loginsessie is uiteindelijk verlopen
  Als "John" bij zijn volgende bezoek de website opent
  Dan hoeft hij niet opnieuw in te loggen met zijn logingegevens

Scenario: Uitloggen

Scenario: Uitloggen wanneer login was onthouden