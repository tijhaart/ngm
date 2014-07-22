Functionaliteit: Toegang tot app op verschillende niveaus beperken of toestaan voor gebruikers

Scenario: Inloggen

Scenario: Inloggen en toegang onthouden
  Gegeven dat gebruiker "John" zijn login heeft laten onthouden
  En is ingelogd
  # verlopen sessies zijn: browser/tab/pc afgesloten
  En zijn loginsessie is uiteindelijk verlopen
  Als "John" bij zijn volgende bezoek de website opent
  Dan hoeft hij niet opnieuw in te loggen met zijn logingegevens

Scenario: Uitloggen

Scenario: Uitloggen waneer login werd onthouden