# Flutter Hack Challenge

- [Flutter Hack Challenge](#flutter-hack-challenge)
  - [Online Demo](#online-demo)
  - [Puzzle Animation](#puzzle-animation)
    - [Notes](#notes)
  - [Background Animation](#background-animation)
    - [Simple Background](#simple-background)
    - [Shadows animation](#shadows-animation)
    - [Space Animation](#space-animation)
  - [Used packages](#used-packages)

## [Online Demo](https://www.google.com)

## Puzzle Animation

The main animation for the tiles moving in the puzzle is Explode-implode animation. Where the tile will break at the point where the users clicks (or taps) and from this point multiple breaks lines for this tile will be generated (The number of the lines is adjustable in the settings) and then the tile will be converted to many pieces and they will preform an explode animation. and after the explosion is finished the same number of pieces will be generated and perfume an implode animation to shape at the end the new tile in the new position (The explode and implode animation duration is adjustable in the settings).

### Notes

- For performance reasons on small screens (smaller as 500) the tile will not break and will be animated as one piece this behaver could be turned On/Off from the settings
- The tiles shape and color will be change according to the chosen background
- While imploding the braking point will be set to the middle of the tile.

## Background Animation

There are three types of backgrounds in the app. On wide screen the background could be changes from the sidebar otherwise it could be changed from the drawer.

### Simple Background

Just simple colorful background the speed of the animation could be changed from the settings.

### Shadows animation

### Space Animation

## Used packages

- [Getx](https://pub.dev/packages/get) for state management.
