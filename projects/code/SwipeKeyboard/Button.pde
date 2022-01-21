class Button {

  int refX;
  int refY;
  int baseX;
  int baseY;
  int currX;
  int currY;

  String display;
  String retval;

  float w;
  float h;

  float myOffset;

  int flashEnd;
  boolean flashing;

  public Button(int refX, int refY, int x, int y, String display, String retval, float w, float h, float myOffset) {
    this.refX = refX;
    this.refY = refY;

    this.currX = x;
    this.currY = y;
    this.baseX = x;
    this.baseY = y;

    this.display = display;
    this.retval = retval;

    this.w = w;
    this.h = h;

    this.myOffset = myOffset;

    this.flashing = false;
    this.flashEnd = millis();
  }

  private boolean shouldRender() {
    if (this.currX + this.myOffset > sizeOfInputArea || (this.currX+this.myOffset + this.w) < 0) {
      return false;
    }
    return true;
  }

  public void render() {
    if (this.shouldRender()) {
      color kc = KEY_COLOR;

      if (this.flashing) {
        if (millis() < this.flashEnd) {
          kc = color(180);
        } else {
          this.flashing = false;
        }
      }

      int x = this.refX + this.currX;
      int y = this.refY + this.currY;

      int keyX = (int) (x + this.w*.05);
      int keyY = (int) (y + this.h*.05);

      fill(kc);
      stroke(KEY_STROKE);
      rect(keyX, keyY, this.w*.9, this.h*.9);

      textAlign(CENTER, CENTER);
      fill(TEXT_COLOR);
      textSize(insideText);
      text(this.display, keyX + this.w*.45, keyY + this.h*.45);
    }
  }

  public void moveTo(float offset, float ribbonWidth) {
    this.currX = this.baseX + (int) min(offset, ribbonWidth);
  }

  public String getResult(int mx, int my) {
    if (!this.shouldRender()) {
      return "";
    }
    if (this.currX+this.refX < mx && mx < this.currX + this.refX + this.w) {
      if (this.currY + this.refY < my && my < this.currY + this.refY + this.h) {
        return this.retval;
      }
    }
    return "";
  }

  private void flash() {
    this.flashing = true;
    this.flashEnd = millis() + 100;
  }
}
