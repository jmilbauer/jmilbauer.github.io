class Dot {
  PVector loc;
  float r;
  float sensitivity_range;
  String name;

  Dot(PVector loc, float r) {
    this.loc = loc;
    this.r = r;
    this.sensitivity_range = DOT_SENSITIVITY - this.r;
  }

  Dot(String name, PVector loc, float r) {
    this.name = name;
    this.loc = loc;
    this.r = r;
    this.sensitivity_range = DOT_SENSITIVITY - this.r;
  }

  void show() {
    float d = dist(this.loc.x, this.loc.y, mouseX, mouseY);
    if (d < DOT_SENSITIVITY) {
      stroke(255, 255, 255);
      float scaled = (this.sensitivity_range - max(d-PT_RAD, 0))/this.sensitivity_range;
      strokeWeight(scaled * MAX_DOT_BORDER);
      fill(DOT_COLOR, ALPH);
      ellipse(this.loc.x, this.loc.y, PT_RAD, PT_RAD);
    } else {
      noStroke();
      fill(DOT_COLOR, ALPH);
      ellipse(this.loc.x, this.loc.y, PT_RAD, PT_RAD);
    }
  }

  void showName() {
    float d = dist(this.loc.x, this.loc.y, mouseX, mouseY);
    float scaled = (this.sensitivity_range - max(d-PT_RAD, 0))/this.sensitivity_range;

    if (d < this.r && name != null) {
      int fsize = max(((int) (pow(scaled, 4) * FONT_SIZE)), 1);
      textSize(fsize);
      if (textWidth(name) + this.loc.x + this.r + 20 > width) {
        textAlign(RIGHT);
      } else {
        textAlign(LEFT);
      }
      fill(255);
      int borderStroke = 2;
      for (int i=-1; i<2; i++){
        text(name, this.loc.x + (this.r)+(borderStroke*i), (this.loc.y + this.r/2));
        text(name, this.loc.x + (this.r), (this.loc.y + this.r/2)+(borderStroke*i));
      }
      fill(0);
      text(name, this.loc.x + (this.r), (this.loc.y + this.r/2));
    }
  }

  void showBland() {
    noStroke();
    fill(DOT_COLOR);
    ellipse(this.loc.x, this.loc.y, PT_RAD, PT_RAD);
  }
}
