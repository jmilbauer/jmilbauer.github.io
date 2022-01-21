class TypeBar {
  int xpos, ypos;
  
  TypeBar(int x, int y) {
    this.xpos = x;
    this.ypos = y; 
  }
  
  void drawSequence(ArrayList<LetterDot> seq, color textColor) {
    stroke(0);
    line(xpos, ypos, xpos+150, ypos);
    stroke(textColor);
    fill(textColor);
    alpha(0);
    textSize(24);
    text(seqString(seq).toUpperCase(), xpos, ypos - 5);
  }
  
  void smallSequence(ArrayList<LetterDot> seq) {
    
  }
  
  void drawHistory(ArrayList<ArrayList<LetterDot>> history) {
    int offset = 20;
    textSize(18);
    fill(50);
    stroke(50);
    for (ArrayList<LetterDot> hist : history) {
      text(seqString(hist).toUpperCase(), xpos, ypos + offset);
      offset += 20;
    }  
  }
  
  void flashRed(ArrayList<LetterDot> seq) {
    print("flashing");
    for (int i = 0; i < 100; i++) {
      fill(0 + i*2, 0, 0);
      textSize(24);
      text(seqString(seq).toUpperCase(), xpos, ypos - 5);
      delay(1);
    }
    delay(500);
    for (int i = 99; i >= 0; i--) {
      fill(0 + i*2, 0, 0);
      textSize(24);
      text(seqString(seq).toUpperCase(), xpos, ypos - 5);
      delay(1);
    }
    print("done");
  }
  
  void drawSelf(ArrayList<LetterDot> seq, ArrayList<ArrayList<LetterDot>> hist, color tc) {
     drawSequence(seq, tc);
     drawHistory(hist); 
  }
}
