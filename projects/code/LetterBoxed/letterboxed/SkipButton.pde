class SkipButton {
  int xpos, ypos;
  boolean shown;

  SkipButton(int xpos, int ypos) {
    this.xpos = xpos;
    this.ypos = ypos;
    this.shown = false;
  }

  void drawSelf() {
    fill(255);
    stroke(0);
    ellipse(xpos, ypos, 50, 50);
    fill(0);
    triangle(xpos+2, ypos, xpos-13, ypos+10, xpos-13, ypos-10);
    triangle(xpos+17, ypos, xpos+2, ypos+10, xpos+2, ypos-10);
  }

  boolean isInside(int x, int y) {
    return dist(xpos, ypos, x, y) <= 25;
  }

  void onPress() {
    print("Mousepressed", '\n');
    if (isInside(mouseX, mouseY)) {
      print("Starting new game.", '\n');
      loadNewGame();
    }
  }
}

