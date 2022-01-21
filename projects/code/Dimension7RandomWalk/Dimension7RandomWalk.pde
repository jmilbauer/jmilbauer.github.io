import processing.pdf.*;

int x;
int y;
int xSIDE = 64;
int ySIDE = 64;
int red;
int green;
int blue;
int pointSize;
boolean paused;


void setup()
{
 red=127;
 green=127;
 blue=127;
 size(256,256); 
 x = xSIDE/2;
 y = ySIDE/2;
 frameRate(60);
 pointSize = 8;
 paused = false;
 
 beginRecord(PDF, "drawings/walk.pdf");
 background(color(0,0,0));
}

void keyPressed() {
  if (key == 'p') {
    paused = !paused;
  }
  if (key == 'r') {
    setup();
  }
}

void step()
{
 int r = (int)random(0,11);
 move(r);
 if (x<0) {x = 0;}
 if (x>width) {x = width;}
 if (y<0) {y = 0;}
 if (y>height) {y = height;}
 if (red==-1) {red=0;}
 if (red==256) {red=255;}
 if (green==-1) {green=0;}
 if (green==256) {green=255;}
 if (blue==-1) {blue=0;}
 if (blue==256) {blue=255;}
 noStroke();
 fill(color(red,green,blue));
 rect(x,y,pointSize, pointSize);
 }

int steps = 0;
void draw()
{
  if (!paused) {
    for (int i = 0; i < 100; i++) {
      step();
      steps += 1;
      println(steps);
    }
  }
}

void move(int rand)
{
  if (rand == 1 && x > 0) {x-=pointSize;}
  if (rand == 2 && x < width) {x+=pointSize;}
  if (rand == 3 && y > 0) {y-=pointSize;}
  if (rand == 4 && y < height) {y+=pointSize;}
  if (rand == 5) {red--;}
  if (rand == 6) {red++;}
  if (rand == 7) {green--;}
  if (rand == 8) {blue++;}
  if (rand == 9) {green++;}
  if (rand == 10) {blue--;}
}
