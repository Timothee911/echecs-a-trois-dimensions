# Échecs à trois dimensions

Les échecs tridimensionnels façon *Star Trek*, en three.js : trois plateaux principaux 4×4 posés en escalier et quatre plateaux d'attaque 2×2 mobiles sur des tenons, sur six niveaux, comme le jeu de la série. Tu joues les Blancs contre un bot (trois niveaux) ou à deux, avec un ELO comme aux échecs classiques.

![Aperçu](apercu.png)

## Lancer

```bash
python3 -m http.server 8000
```

Puis ouvrir http://localhost:8000

## Règles (version de fans simplifiée)
- On raisonne vue de dessus : chaque pièce bouge comme aux échecs classiques, puis se pose sur le niveau de son choix. Une pièce sur la trajectoire, à n'importe quel niveau, bloque les pièces qui glissent.
- Plateaux d'attaque : à ton tour, tu peux déplacer un plateau que tu contrôles vers un tenon libre voisin (autre coin du même plateau, plateau voisin, ou de l'autre côté) au lieu de jouer une pièce.
- Échec, échec et mat et pat détectés. Pas de roque ni de prise en passant.

## Jouer avec un ami
« Inviter un ami » crée un code à 6 caractères et un lien. L'ami ouvre le lien (ou tape le code) et la partie démarre : connexion directe de navigateur à navigateur (PeerJS, `peerjs.min.js` inclus), sans compte. Le serveur public de PeerJS ne sert qu'à mettre les deux navigateurs en relation. Pas d'ELO ni d'annulation en ligne.
