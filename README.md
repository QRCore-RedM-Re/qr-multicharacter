# qb-multicharacter
Multi Character Feature for QB-Core Framework :people_holding_hands:

Added support for setting default number of characters per player per Rockstar license

## Dependencies
- [qb-core](https://github.com/QRCore-framework/qb-core)
- [qb-spawn](https://github.com/QRCore-framework/qb-spawn) - Spawn selector
- [qb-apartments](https://github.com/QRCore-framework/qb-apartments) - For giving the player a apartment after creating a character.
- [qb-clothing](https://github.com/QRCore-framework/qb-clothing) - For the character creation and saving outfits.
- [qb-weathersync](https://github.com/QRCore-framework/qb-weathersync) - For adjusting the weather while player is creating a character.

## Screenshots
![Character Selection](https://cdn.discordapp.com/attachments/934470871333105674/1014215694394589294/unknown.png)
![Character Registration](https://cdn.discordapp.com/attachments/934470871333105674/1014215687700488304/unknown.png)

## Features
- Ability to create up to 5 characters and delete any character.
- Ability to see character information during selection.

## Installation
### Manual
- Download the script and put it in the `[qb]` directory.
- Add the following code to your server.cfg/resouces.cfg
```
ensure qb-core
ensure qb-multicharacter
ensure qb-spawn
ensure qb-apartments
ensure qb-clothing
ensure qb-weathersync
```
