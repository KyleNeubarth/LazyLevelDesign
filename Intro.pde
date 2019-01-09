void Intro(int goTo) {
  switch (goTo) {
    case 1:
      messageIndex = 1;
      break;
    case 2:
      messageIndex = 2;
      ks.toggleCalibration();
      displayMain = mode.CAMERA;
      break;
    case 3:
      messageIndex = 3;
      ks.toggleCalibration();
      displayMain = mode.EMPTY;
      //display color palette
      displayPaletteFrame = true;
      break;
    case 4:
      messageIndex = 4;
      displayMain = mode.COLORS;
      ReadPalette();
      displayPaletteColors = true;
      break;
    case 5:
      messageIndex = 5;
      displayMain = mode.EMPTY;
      displayPaletteColors = false;
      break;
  }
}