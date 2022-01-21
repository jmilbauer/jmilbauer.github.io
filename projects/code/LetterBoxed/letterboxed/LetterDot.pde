class LetterDot {
  int xpos, ypos;
  int textX, textY;
  char side;
  char letter;
  boolean touched;
  boolean current;
  boolean locked;
  int textSize = 32;
  
  LetterDot(char letter, int xpos, int ypos, char side)
  {
    this.xpos = xpos;
    this.ypos = ypos;
    this.letter = letter;
    this.side = side;
    
    if (this.side == 'r') {
      this.textX = this.xpos + this.textSize;
      this.textY = this.ypos + this.textSize / 3;
    } else if (this.side == 'l') {
      this.textX = this.xpos - this.textSize;
      this.textY = this.ypos + this.textSize / 3;
    } else if (this.side == 't') {
      this.textX = this.xpos + this.textSize / 4;
      this.textY = this.ypos - this.textSize / 2;
    } else if (this.side == 'b') {
      this.textX = this.xpos + this.textSize / 4;
      this.textY = this.ypos + this.textSize * 5 / 4;
    }
    
    this.textX -= this.textSize / 2;
      
    drawSelf();
  }
  
  void switchTo() {  
    this.current = true;
    this.touched = true;
  }
  
  void switchFrom() {
   this.current = false;
   this.touched = true; 
  }
  
  void drawSelf() {
    
    if (this.locked) {
      stroke(0);
      fill(accent);
    } else if (this.current) {
      fill(0);
      stroke(accent);
    } else if (this.touched) {
      stroke(accent);
      fill(255);
    } else {
      stroke(0);
      fill(255);
    }
    
    ellipse(xpos, ypos, 20, 20);
    
    fill(255);
    textSize(this.textSize);
    text(this.letter, this.textX, this.textY);

  }
}
