# 🔫 Anar's fabulous fictitious gun generator

Guns and gaming go hand in hand to create the extremely popular genre of shooter games. Developers work day and night to perfect the feel, realism, and fun-ness of their guns. This project aims to discover a way to generatively create new and unique guns through parametric design.

## These parameters include:

- Barrel length
- Barrel height
- Weight (affects rotation speed and recoil)
- Body silhouette
- Gun body colors
- Magazine size
- Firing mode (single-fire, burst, shotgun, automatic, auto shotgun)
- Fire rate
- Bullet color
- Bullet trajectory
- Bullet speed (proportional to barrel length)
- Bullet spread (for shotguns)
- Accuracy
- Single/burst fire cooldown time
- Recoil intensity (affected by weight)

## Parameter definition

The above parameters all depend on the seed, which is determined by converting the gun's name (a string) to a numerical value, so you can reproduce the same gun from its name alone.

# How to play

1. Download Processing.
2. Run gun.pde in Processing.
3. Use WASD to move your gun.
4. Use Mouse1 to shoot the balloons.
5. Hit R to reload ammo (you start with 3 magazines, so don't waste it all).
6. Clearing all balloons will progress you to the next level, with tougher balloons (+1 magazine for clearing a round, with 3 mags max).
7. Game ends if you run out of ammo.
8. Press Escape to quit.
