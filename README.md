# Flutter Hack Challenge

- [Flutter Hack Challenge](#flutter-hack-challenge)
  - [Online Demo](#online-demo)
  - [Tile Animation](#tile-animation)
    - [Notes](#notes)
  - [Background Animation](#background-animation)
    - [Simple Background](#simple-background)
    - [Shadows animation](#shadows-animation)
    - [Space Animation](#space-animation)
  - [Used packages](#used-packages)
  - [Platforms](#platforms)

## [Online Demo](https://schabanbo.github.io/puzzle_hack/#/)

## Tile Animation

The main animation for the tiles moving in the puzzle is Explode-implode animation, where the tile will break at the point where the user clicks (or taps) and from this point multiple breaking lines for this tile will be generated (The number of the lines is adjustable in the settings) and then the tile will be converted from those lines to many pieces, and they will preform an explosion animation. And after the explosion is finished the same number of pieces will be generated and perfume an imploded animation to shape at the end the new tile in the new position (The explosion and implode animation duration is adjustable in the settings).

### Notes

- For performance reasons on mobile devices, the tile will not break and will be animated as one piece. This behavior could be turned On/Off from the settings.
- The tile's shape and color will be change according to the chosen background
- While imploding, the braking point will be set to the middle of the tile.
- Whenever a tile is in the right position a gray border will appear around it.

## Background Animation

There are three types of backgrounds in the app. On wide screen the background could be changes from the sidebar, otherwise it could be changed from the drawer.

### Simple Background

Just simple colorful background, the speed of the animation could be changed from the settings.

### Shadows animation

This Background is just a number of moving boxes that show shadows against the moving light, this light position will change with mouse position and if the running device is a mobile device, then the light position will follow the finger position or will float with the direction of the boxes.

Those properties are adjustable in the settings:

- The boxes number
- The boxes speed
- The light radius
- The length of the box shadow

### Space Animation

This background will show a shining star in the middle of the screen with a number of asteroids which orbit around it, and at random positions in the screen a number of stars will glow. The number of asteroid and start is adjustable from the settings.

As asteroids orbit around the star, the whole view will rotate in vertical direction in a specific speed, which can be adjusted from the settings.

## Used packages

- [Getx](https://pub.dev/packages/get) for state management.

## Platforms

Tested on **Web**, **Windows** and **Android**
