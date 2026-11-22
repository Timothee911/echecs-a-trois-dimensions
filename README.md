# Échecs à trois dimensions

Les échecs en 3D en three.js : cinq plateaux 5×5 superposés (niveaux A à E, 125 cases), avec la licorne. Tu joues les Blancs contre un bot (trois niveaux), à deux ou en ligne avec un ami, avec un ELO comme aux échecs classiques.

![Aperçu](apercu.png)

## Lancer

```bash
python3 -m http.server 8000
```

Puis ouvrir http://localhost:8000

## Règles
- Départ : Blancs sur les niveaux A et B, Noirs sur D et E, niveau C vide. Case = niveau + colonne + rangée, par exemple `Bc3`.
- Tour sur 3 axes, fou en diagonale plane, licorne en diagonale à travers les trois axes, dame = tour + fou + licorne, cavalier en L (2 + 1) niveaux compris, roi d'une case dans les 26 directions.
- Pion : avance d'une case en rangée ou en niveau, prend en diagonale vers l'avant, devient dame au dernier rang ou niveau.
- Échec, échec et mat et pat détectés. Pas de roque ni de prise en passant.

## Jouer avec un ami
« Inviter un ami » crée un code à 6 caractères et un lien. L'ami ouvre le lien (ou tape le code) et la partie démarre : connexion directe de navigateur à navigateur (PeerJS, `peerjs.min.js` inclus), sans compte. Le serveur public de PeerJS ne sert qu'à mettre les deux navigateurs en relation. Pas d'ELO ni d'annulation en ligne.
