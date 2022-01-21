final int DPIofYourDeviceScreen = 324; //you will need to measure or look up the DPI or PPI of your device/browser to make sure you get the right scale!!
final float sizeOfInputArea = DPIofYourDeviceScreen*1; //aka, 1.0 inches square!

int totalTrialNum = 2; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far

//Variables for my silly implementation. You can delete this:
int currentLetter = int('a');


String topRow = "qwertyuiop";
String middleRow = "asdfghjkl";
String bottomRow = "zxcvbnm";

color TEXT_COLOR = color(0);
color KEY_COLOR = color(255);
color KEY_STROKE = color(0);

ArrayList<Button> tops;
ArrayList<Button> mids;
ArrayList<Button> bottoms;
Suggestion model;

int ribbonWidth;

float insideText;
float outsideText;

float regionX;
float regionY;
float keyW;
float keyH;


//You can add stuff in here. This is just a basic implementation.
void setup()
{
  size(800, 800); //Sets the size of the app. You should modify this to your device's native size. Many phones today are 1080 wide by 1920 tall.
  noStroke(); //my code doesn't use any strokes.

  insideText = sizeOfInputArea / 7;
  outsideText = DPIofYourDeviceScreen / 15;

  //randomize the phrase order
  for (int i=0; i<phrases.length; i++)
  {
    int r = (int)random(0, phrases.length);
    String temp = phrases[i];
    phrases[i] = phrases[r];
    phrases[r] = temp;
  }

  regionX = width/2 - sizeOfInputArea/2;
  regionY = height/2 - sizeOfInputArea/2;
  keyW = sizeOfInputArea/4.5;
  keyH = sizeOfInputArea/4;
  tops = buildRow(topRow, topRow, keyW, keyH, (int) (regionX), (int) (regionY + keyH), 0);
  mids = buildRow(middleRow, middleRow, keyW, keyH, (int) (regionX + keyW/2), (int) (regionY + 2*keyH), keyW/2);
  bottoms = buildRow(bottomRow, bottomRow, keyW, keyH, (int) (regionX + keyW), (int) (regionY + 3*keyH), keyW);
  float m1 = max(topRow.length(), middleRow.length());
  ribbonWidth = (int) (keyW * max(m1, bottomRow.length()));

  model = new Suggestion(regionX, regionY, sizeOfInputArea, sizeOfInputArea);
}

ArrayList<Button> buildRow(String keys, String rets, float keyW, float keyH, int refX, int refY, float offset) {
  ArrayList<Button> res = new ArrayList<Button>();
  for (int i = 0; i < keys.length(); i++) {
    String display = str(keys.charAt(i));
    String ret = str(rets.charAt(i));

    Button b = new Button(refX, refY, (int) (i * keyW), 0, display, ret, keyW, keyH, offset);
    res.add(b);
  }
  return res;
}

void drawFinished() {
  fill(0);
  textAlign(CENTER);
  textSize(outsideText);
  text("Trials complete!", 400, 200); //output
  text("Total time taken: " + (finishTime - startTime), 400, 220); //output
  text("Total letters entered: " + lettersEnteredTotal, 400, 240); //output
  text("Total letters expected: " + lettersExpectedTotal, 400, 260); //output
  text("Total errors entered: " + errorsTotal, 400, 280); //output
  float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
  text("Raw WPM: " + wpm, 400, 300); //output
  float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
  text("Freebie errors: " + nf(freebieErrors, 1, 3), 400, 320); //output
  float penalty = max(errorsTotal-freebieErrors, 0) * .5f;
  text("Penalty: " + penalty, 400, 340);
  text("WPM w/ penalty: " + (wpm-penalty), 400, 360); //yes, minus, because higher WPM is better
  return;
}

void drawInitial() {
  fill(128);
  textAlign(CENTER);
  textSize(outsideText);
  text("Click to start time!", 280, 150); //display this message until the user clicks!
}

void drawCurrentInput() {
  fill(255);
  stroke(0);
  float regionX = width/2 - sizeOfInputArea/2;
  float regionY = height/2 - sizeOfInputArea/2;
  float b = sizeOfInputArea / 40;
  rect(regionX, regionY, sizeOfInputArea, sizeOfInputArea/4);

  float areaLen = sizeOfInputArea - 4*b;

  textAlign(LEFT, TOP);
  textSize(insideText);
  String[] words = currentTyped.split(" ");
  String lastword;
  String continuation;
  if (words.length > 0 && !currentTyped.endsWith(" ")) {
    lastword =  words[words.length-1];
    continuation = model.getContinuation(lastword, areaLen);
  } else {
    lastword = "";
    continuation = "";
  }

  String outstring = lastword + "|";
  while (textWidth(outstring) > areaLen) {
    outstring = outstring.substring(1, outstring.length());
  }

  outstring += continuation;
  while (textWidth(outstring) > areaLen) {
    continuation = continuation.substring(0, continuation.length()-1);
    outstring = outstring.substring(0, outstring.length()-1);
  }

  String printedSoFar = "";

  fill(40, 40, 140);
  text(outstring.substring(0, outstring.length()-continuation.length()-1), regionX + 2*b + textWidth(printedSoFar), regionY + 2*b);
  printedSoFar = outstring.substring(0, outstring.length()-continuation.length()-1);

  fill(90);
  text(outstring.substring(outstring.length()-continuation.length()-1, outstring.length()-continuation.length()), regionX + 2*b + textWidth(printedSoFar), regionY + 2*b);
  printedSoFar += "|";

  fill(170);
  text(outstring.substring(outstring.length()-continuation.length(), outstring.length()), regionX + 2*b + textWidth(printedSoFar), regionY + 2*b);
}

void drawTrialInfo() {
  //you can very slightly adjust the position of the target/entered phrases and next button
  textAlign(LEFT); //align the text left
  fill(128);
  textSize(outsideText);
  text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
  fill(128);
  text("Target:   " + currentPhrase, 70, 100); //draw the target string
  text("Entered:  " + currentTyped + "|", 70, 140); //draw what the user has entered thus far 

  //draw very basic next button
  fill(255, 0, 0);
  rect(600, 600, 200, 200); //draw next button
  fill(255);
  text("NEXT > ", 650, 650); //draw next label
}

void drawRow(ArrayList<Button> buttons) {
  for (Button b : buttons) {
    float constrained = max(-ribbonWidth+sizeOfInputArea, min(activeDeltaX, 0));
    b.moveTo(constrained, ribbonWidth);
    b.render();
  }
}


void drawDesign() {
  drawRow(tops);
  drawRow(mids);
  drawRow(bottoms);
  drawBorder();
  drawCurrentInput();
}

void drawBorder() {
  int xRef = (int) (width/2 - sizeOfInputArea/2);
  int yRef = (int) (width/2 - sizeOfInputArea/2);

  fill(255);
  noStroke();
  rect(xRef, yRef, -(sizeOfInputArea/3), sizeOfInputArea);
  rect(xRef+sizeOfInputArea, yRef, (sizeOfInputArea/3), sizeOfInputArea);
}

void drawWatchSquare() {
  // Draw the watch grid.
  fill(100);
  rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea); //input area should be 1" by 1"
}

//You can modify stuff in here. This is just a basic implementation.
void draw()
{
  background(255); //clear background

  // Draw final score information.
  if (finishTime!=0)
  {
    drawFinished();
    return;
  }

  drawWatchSquare();

  // Draw initial information.
  if (startTime==0 & !mousePressed)
  {
    drawInitial();
  }

  // If we are going to trigger a trial.
  if (startTime==0 & mousePressed)
  {
    nextTrial(); //start the trials!
  }

  //if start time does not equal zero, it means we must be in the trials
  if (startTime!=0)
  {
    drawTrialInfo();
    drawDesign();
  }
}

int startX = -1;
int startY = -1;
int endX = -1;
int endY = -1;
//you can replace all of this logic.
void mousePressed()
{
  startX = mouseX;
  startY = mouseY;
  scrolling = false;
}

void mouseReleased() {
  endX = mouseX;
  endY = mouseY;

  stableDeltaX = activeDeltaX;

  if (didSwipeRight()) {
    handleString(model.getResultAlways());
  } else if (didSwipeLeft()) {
    handleString("<");
  } else if (!scrolling) {
    handleString(getKeyPress(mouseX, mouseY));
  }

  nextClick(mouseX, mouseY);
  scrolling = false;
}

void handleString(String s) {
  if (s.equals(" ")) {
    currentTyped = currentTyped + " ";
  } else if (s.equals("<")) {
    if (currentTyped.length()>0) {
      currentTyped = currentTyped.substring(0, currentTyped.length()-1);
    }
  } else {
    currentTyped = currentTyped + s;
  }
}

String getKeyPress(int x, int y) {
  String res = "";
  if (regionX < x && x < regionX + sizeOfInputArea && regionY < y && y < regionY + keyW) {
    return " ";
  }
  for (Button b : tops) {
    res += b.getResult(x, y);
    if (!res.equals("")) {
      b.flash();
      return res;
    }
  }
  for (Button b : mids) {
    res += b.getResult(x, y);
    if (!res.equals("")) {
      b.flash();
      return res;
    }
  }
  for (Button b : bottoms) {
    res += b.getResult(x, y);
    if (!res.equals("")) {
      b.flash();
      return res;
    }
  }
  return res;
}

float activeDeltaX = 0;
float stableDeltaX = 0;
boolean scrolling = false;
void mouseDragged() {
  if (abs(mouseX - startX) > sizeOfInputArea/15 && (abs(startY - mouseY) < sizeOfInputArea/5) && startY > regionY+keyH) {
    scrolling = true;
  }
  if (scrolling) {
    float deltaX = mouseX - startX;
    activeDeltaX = stableDeltaX + deltaX;
  }
}

boolean didSwipeDown() {
  return (endY - startY > sizeOfInputArea/5) && (abs(endX - startX) < sizeOfInputArea/4) && !scrolling;
}

boolean didSwipeUp() {
  return (startY - endY > sizeOfInputArea/5) && (abs(endX - startX) < sizeOfInputArea/4) && !scrolling;
}

boolean didSwipeLeft() {
  return (startX - endX > sizeOfInputArea/5 && !scrolling && startY < regionY + keyH);
}
boolean didSwipeRight() {
  return (endX - startX > sizeOfInputArea/5 && !scrolling && startY < regionY + keyH);
}




void nextTrial()
{
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

  if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    println("==================");
    println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    println("Target phrase: " + currentPhrase); //output
    println("Phrase length: " + currentPhrase.length()); //output
    println("User typed: " + currentTyped); //output
    println("User typed length: " + currentTyped.length()); //output
    println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    println("Time taken on this trial: " + (millis()-lastTime)); //output
    println("Time taken since beginning: " + (millis()-startTime)); //output
    println("==================");
    lettersExpectedTotal+=currentPhrase.length();
    lettersEnteredTotal+=currentTyped.length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  //probably shouldn't need to modify any of this output / penalty code.
  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    println("==================");
    println("Trials complete!"); //output
    println("Total time taken: " + (finishTime - startTime)); //output
    println("Total letters entered: " + lettersEnteredTotal); //output
    println("Total letters expected: " + lettersExpectedTotal); //output
    println("Total errors entered: " + errorsTotal); //output
    float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
    println("Raw WPM: " + wpm); //output
    float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
    println("Freebie errors: " + nf(freebieErrors, 1, 3)); //output
    float penalty = max(errorsTotal-freebieErrors, 0) * .5f;
    println("Penalty: " + penalty, 0, 3);
    println("WPM w/ penalty: " + (wpm-penalty)); //yes, minus, becuase higher WPM is better
    println("==================");
    currTrialNum++; //increment by one so this message only appears once when all trials are done
    return;
  }

  if (startTime==0) //first trial starting now
  {
    println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
  } else
  {
    currTrialNum++; //increment trial number
  }

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc"; // uncomment this to override the test phrase (useful for debugging)
}




//=========SHOULD NOT NEED TO TOUCH THIS METHOD AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2) //this computers error between two strings
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}
