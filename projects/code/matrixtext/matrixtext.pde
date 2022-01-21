PFont mono;
int RED = 0;
int GREEN = 150;
int BLUE = 0;
TextLine[] printers;
int PRINTER_COUNT = 100;
String validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHJIKLMNOPQRSTUVWXYZ";
String otherValidChars = "0123456789∑øπß∂ƒ√∫µ!@#$%&*()";
//String validChars = "会意字會意字";
//String otherValidChars = "丁七九了二人入八刀力十又乃不与中丹予互五井仁今介仏元公六内円冗凶分切刈化匹区升午厄及友双反収";
int TEXT_WIDTH;
int TEXT_SPACING;
int TEXT_HEIGHT = 18;



class TextLine {
  int xPos;
  int yPos;
  int stringLength;
  int counter;
  int MYRED;
  int MYGREEN;
  int MYBLUE;
  
  TextLine() {
    reset();
  }
  
//  boolean inMessage(int xPos, yPos) {
//      y = yPos
//      x = (xPos - 1) / TEXT_SPACING;
//    
//      if (x >= 2 && y == 2 && x <= 45 &&) {
//        return true; 
//      }
//      if (x >= 2 && x <= 50 && y == 4) {
//        return true;
//      }
//      if (x >= 2 && x <= 44 && y == 6) {
//       return true; 
//      }
//      if (x >= 2 && x <= 93 && y == 8) {
//        return true;
//      }
//      return false;
//  }
  
//  void printMessage(x, y) {
//    int xPos = x * TEXT_SPACING + 1;    
//    
//    if (y == 2) {
//      char outputChar = message1.charAt(x-2);
//    } else if (y == 4) {
//      char outputChar = message2.charAt(x-2);
//    } else if (y == 6) {
//      char outputChar = message3.charAt(x-2);
//    } else if (y == 8) {
//      char outputChar = message4.charAt(x-2);
//    }
//    text(outputChar, xPos, (y+counter+1) * TEXT_HEIGHT);
//  }
  
  void reset() {
    xPos = (int)random(0, (int)(width/TEXT_SPACING)) * TEXT_SPACING + 1;
    yPos = 0;//(int)random(0, ((int)(height/TEXT_HEIGHT) * TEXT_HEIGHT + 1)/2);
    stringLength = (int)((height-yPos)/TEXT_HEIGHT) - (int)random(0,20);   
    counter = 0;
    if (random(0,100) < 10) {
      MYRED = GREEN;
      MYGREEN = RED;
      MYBLUE = BLUE; 
    } else {
       MYRED = RED;
      MYGREEN = GREEN;
     MYBLUE = BLUE; 
    }
  }
  
  
  void printNext() {
    if (counter < stringLength) {
      String outputChar;
      int flag = (int)(random(5));
      if (flag == 0) {
        outputChar = "" + validChars.charAt((int)random(validChars.length()));
      } else {
        outputChar = "" + otherValidChars.charAt((int)random(otherValidChars.length()));
      }
      
      int factor = 20;//(8/(stringLength - counter)) * 60;
      fill(MYRED + factor, MYGREEN + factor, MYBLUE + factor, (int)(255 * (1 - ((double)counter/stringLength))));
     //if (inMessage(xPos, yPos)) {
     //   printMessage(xPos, yPos);
     // } else {
        text(outputChar, xPos, (yPos+counter+1) * TEXT_HEIGHT);
     // }
      counter += 1;
    } else {
      reset();
      printNext();
    }
  }
 
   
  
}


void setup() {
  size(1280,800);
  mono = createFont("FiraMono-Regular",32);
  textFont(mono);
  textSize(TEXT_HEIGHT);
  TEXT_WIDTH = (int)textWidth('a');
  TEXT_SPACING = TEXT_WIDTH + 2;
  background(0);
  //text("test",10,20);
  printers = new TextLine[PRINTER_COUNT];
  for (int i = 0; i < PRINTER_COUNT; i++) {
   printers[i] = new TextLine();
  }
  frameRate(30);
  
  
}

void draw() {
  for (int i = 0; i < PRINTER_COUNT; i ++) {
   printers[i].printNext();
  }
  fill(0,10);
  rect(0,0,width,height);
}
