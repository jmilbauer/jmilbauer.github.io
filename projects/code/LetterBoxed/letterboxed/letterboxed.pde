import java.lang.Character;
import java.util.Map;
import java.util.HashSet;

String word1 = "interstitial";
String word2 = "laproscopy";

int WIDTH = 650;
int HEIGHT = 400;

char[] left = {
  'I', 'R', 'L'
};
char[] top = {
  'N', 'S', 'A'
};
char[] right = {
  'T', 'P', 'C'
};
char[] bottom = {
  'E', 'O', 'Y'
};
char[] sides = {
  't', 'b', 'l', 'r'
};

color salmon = color(253, 160, 126);
color deadsalmon = color(249, 235, 228);
color clearsalmon = color(253, 160, 126, 20);

color sky = color(157, 203, 234);
color lightsky = color(215, 233, 244);
color clearsky = color(158, 203, 234, 20);

color accent = salmon;
color faintaccent = deadsalmon;
color clearaccent = clearsalmon;

ArrayList<LetterDot> tdots = new ArrayList<LetterDot>();
ArrayList<LetterDot> bdots = new ArrayList<LetterDot>();
ArrayList<LetterDot> ldots = new ArrayList<LetterDot>();
ArrayList<LetterDot> rdots = new ArrayList<LetterDot>();
HashMap<Character, ArrayList<LetterDot>> hm = new HashMap<Character, ArrayList<LetterDot>>();

ArrayList<LetterDot> sequence = new ArrayList<LetterDot>();
ArrayList<Character> sideseq = new ArrayList<Character>();
ArrayList<ArrayList<LetterDot>> history = new ArrayList<ArrayList<LetterDot>>();
LetterDot currentDot = null;
char currentSide = ' ';

SkipButton button = new SkipButton(100, 350);
SkipButton nextButton = new SkipButton(325, 275);

TypeBar typeBar = new TypeBar(25, 100);
boolean flashing = false;
int flashprogress = 0;
boolean flashUp = false;
boolean flashDown = false;
int flashSteps = 30;

BufferedReader reader;
BufferedReader gamereader;
String fileLine;
String gameLine;
ArrayList<String> words = new ArrayList<String>();

void drawLine(LetterDot a, LetterDot b, boolean locked) {
  if (locked) {
    stroke(faintaccent);
  } else {
    stroke(accent);
  }
  line(a.xpos, a.ypos, b.xpos, b.ypos);
}

void drawLine(LetterDot a, LetterDot b, float alpha) {
  stroke(accent, alpha);
  line(a.xpos, a.ypos, b.xpos, b.ypos);
  stroke(accent);
}

boolean validSequence(String str) {
  print("Checking:", str, '\n');
  return words.contains(str);
}

void loadNewGame() { 
  try {
    gameLine = gamereader.readLine();
  } 
  catch (IOException e) {
    gameLine = null;
  }
  if (gameLine == null) {
    print("No more games found.", '\n');
    startGame(top, bottom, left, right);
  } else {
    String[] parts = gameLine.split("\\s+");
    char[] new_top = parts[0].toCharArray();
    char[] new_bottom = parts[1].toCharArray(); 
    char[] new_left = parts[2].toCharArray();
    char[] new_right = parts[3].toCharArray();
    print("Starting new game:", parts[4]," -> ", parts[5], '\n');
    startGame(new_top, new_bottom, new_left, new_right);
  }
}

void startGame(char[] t, char[] b, char[] l, char[] r) {
  background(accent);

  tdots = new ArrayList<LetterDot>();
  bdots = new ArrayList<LetterDot>();
  ldots = new ArrayList<LetterDot>();
  rdots = new ArrayList<LetterDot>();

  LetterDot tlDot = new LetterDot(t[0], 300, 50, 't');
  tdots.add(tlDot);
  LetterDot tmDot = new LetterDot(t[1], 400, 50, 't');
  tdots.add(tmDot);
  LetterDot trDot = new LetterDot(t[2], 500, 50, 't');
  tdots.add(trDot);

  LetterDot blDot = new LetterDot(b[0], 300, 350, 'b');
  bdots.add(blDot);
  LetterDot bmDot = new LetterDot(b[1], 400, 350, 'b');
  bdots.add(bmDot);
  LetterDot brDot = new LetterDot(b[2], 500, 350, 'b');
  bdots.add(brDot);

  LetterDot ltDot = new LetterDot(l[0], 250, 100, 'l');
  ldots.add(ltDot);
  LetterDot lmDot = new LetterDot(l[1], 250, 200, 'l');
  ldots.add(lmDot);
  LetterDot lbDot = new LetterDot(l[2], 250, 300, 'l');
  ldots.add(lbDot);

  LetterDot rtDot = new LetterDot(r[0], 550, 100, 'r');
  rdots.add(rtDot);
  LetterDot rmDot = new LetterDot(r[1], 550, 200, 'r');
  rdots.add(rmDot);
  LetterDot rbDot = new LetterDot(r[2], 550, 300, 'r');
  rdots.add(rbDot);

  hm = new HashMap<Character, ArrayList<LetterDot>>();
  hm.put('t', tdots);
  hm.put('b', bdots);
  hm.put('l', ldots);
  hm.put('r', rdots);

  sequence = new ArrayList<LetterDot>();
  history = new ArrayList<ArrayList<LetterDot>>();
  sideseq = new ArrayList<Character>();
  sideseq.add(' ');
  currentDot = null;
  currentSide = ' ';

  drawBlank();
  typeBar.drawSelf(sequence, history, 255);
}

void drawBlank() {
  background(accent);
  stroke(0);
  strokeWeight(3);
  fill(255); 
  rect(250, 50, 300, 300); 

  for (char c : sides) {
    for (LetterDot dot : hm.get (c)) {
      dot.touched = false;
      dot.current = false;
      dot.drawSelf();
    }
  }
}

String seqString(ArrayList<LetterDot> seq) {
  String res = "";
  for (LetterDot dot : seq) {
    res += dot.letter;
  } 
  return res.toLowerCase();
}

void saveSequence(ArrayList<LetterDot> seq) {
  history.add(seq);
}

void drawHistory() {
  for (ArrayList<LetterDot> seq : history) {
    drawSequence(seq, false);
  }
}

void drawSequence(ArrayList<LetterDot> seq, boolean unlocked) {
  if (seq.size() == 1) {
    LetterDot a = seq.get(0);
    a.touched = true;
    a.current = true;
    a.locked = false;
    a.drawSelf();
  }

  for (int i = 0; i < seq.size ()-1; i++) {
    if (unlocked) {
      LetterDot a = seq.get(i);
      LetterDot b = seq.get(i+1);
      drawLine(a, b, !unlocked);
      a.touched = true;
      a.current = false;
      a.locked = false;
      a.drawSelf();
      b.touched = true;
      b.current = true;
      b.locked = false;
      b.drawSelf();
    } else {
      LetterDot a = seq.get(i);
      LetterDot b = seq.get(i+1);
      drawLine(a, b, !unlocked);
      a.touched = true;
      a.current = false;
      a.locked = true;
      a.drawSelf();
      b.touched = true;
      b.current = true;
      b.locked = true;
      b.drawSelf();
    }
  }
}

boolean isFinished() {
  HashSet<Character> letters = new HashSet<Character>();
  for (ArrayList<LetterDot> seq : history) {
    for (LetterDot dot : seq) {
      letters.add(dot.letter);
    } 
  }
  if (letters.size() == 12) {
    return true; 
  }  
  return false;
}

void setup()
{
  size(650, 400);

  frameRate(60);
  gamereader = createReader("games.txt");


  loadNewGame();
  sideseq.add(' ');


  reader = createReader("simpledict.txt");
  while (true) {
    try {
      fileLine = reader.readLine();
    } 
    catch (IOException e) {
      e.printStackTrace(); 
      fileLine = null;
    }
    if (fileLine == null) {
      break;
    } else {
      words.add(fileLine);
    }
  }
}

void mouseClicked() {
  if (button.shown) {
      button.onPress();
  }
  if (nextButton.shown) {
    nextButton.onPress();
  }
}

void keyPressed() {
  if (key == '5') {
    print("side len", sideseq.size(), "seq len", sequence.size());
    print('\n');
  }
  if (key == ENTER) {
    if (validSequence(seqString(sequence))) {
      saveSequence(sequence);
      LetterDot lastDot = sequence.get(sequence.size() - 1);
      sequence = new ArrayList<LetterDot>();
      sequence.add(lastDot);
      drawBlank();
      drawHistory();
      drawSequence(sequence, true);
    } else {
      flashing = true;
      flashUp = true;
    }
  } else if (key == BACKSPACE) {
    if (sequence.size() != 0) {
      sequence.remove(sequence.size()-1);
      sideseq.remove(sideseq.size()-1);
      currentSide = sideseq.get(sideseq.size()-1);
    }
    if (sequence.size() == 0 && history.size() != 0) {
      ArrayList<LetterDot> mostRecent = history.get(history.size() - 1);
      history.remove(history.size()-1);
      sequence = mostRecent;
      sequence.remove(sequence.size()-1);
      currentSide = sideseq.get(sideseq.size()-1);
    }
    drawBlank();
    drawHistory();
    drawSequence(sequence, true);
  } else {
    for (char cs : sides) {
      if (currentSide != cs) {
        for (LetterDot dot : hm.get (cs)) {
          if (dot.letter == key || java.lang.Character.toLowerCase(dot.letter) == key) {
            sequence.add(dot);
            currentSide = cs;
            sideseq.add(cs);
            break;
          }
        }
      }
    }
    drawHistory();
    drawSequence(sequence, true);
  }
}

void draw()
{  
  if (isFinished()) {
    fill(clearaccent);
    stroke(clearaccent);
    rect(0,0,WIDTH,HEIGHT);
    fill(255);
    stroke(0);
    rect(225, 175, 200, 50);
    fill(0);
    stroke(0);
    textSize(24);
    text("Congratulations!", 230, 210);
    nextButton.drawSelf();
    button.shown = false;
    nextButton.shown = true;
  } else {
    drawBlank();
    drawHistory();
    drawSequence(sequence, true);
    button.drawSelf();
    button.shown = true;
    nextButton.shown = false;

    if (flashing) {      
      typeBar.drawSelf(sequence, history, color((255 / flashSteps) * flashprogress, 0, 0));
      if (flashUp && flashprogress == flashSteps) {
        flashUp = false;
        flashDown = true;
      }
      if (flashUp) {
        flashprogress++;
      }
      if (flashDown) {
        flashprogress--;
      }
      if (flashDown && flashprogress == 0) {
        flashing = false;
        flashDown = false;
        flashUp = false;
      }
    } else {
      typeBar.drawSelf(sequence, history, color(0, 0, 0));
    }
  }
}
