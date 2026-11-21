# Échecs à trois dimensions

Les échecs tridimensionnels façon *Star Trek*, en three.js : trois plateaux principaux 4×4 et quatre plateaux d'attaque 2×2 mobiles, répartis sur sept niveaux. Tu joues les Blancs contre un bot (trois niveaux) ou à deux, avec un ELO comme aux échecs classiques.

![Aperçu](apercu.png)

## Lancer

```bash
python3 -m http.server 8000
```

Puis ouvrir http://localhost:8000

## Règles (version de fans simplifiée)
- Pièces : roi, dame, tour, fou, cavalier, pion, avec des déplacements sur les trois dimensions.
- Plateaux d'attaque : à ton tour, tu peux déplacer un plateau que tu contrôles (un niveau plus haut ou plus bas, ou de l'autre côté) au lieu de jouer une pièce.
- Échec, échec et mat et pat détectés. Pas de roque ni de prise en passant.
