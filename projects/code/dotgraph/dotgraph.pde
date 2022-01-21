int RED = 0;//150;
int WIDTH = 800;
int HEIGHT = 600;
int GREEN = 150;//220;
int BLUE = 0;//250;
color blueColor = #519ECC;
int DOT_COUNT = 200;
Dot[] dots;
int SPEED = 1;
int CONNECTION_DISTANCE = 100;


class Dot {
  float xPos;
  float yPos;
  PVector motion;
  int MYRED;
  int MYGREEN;
  int MYBLUE;
  int resetTimer;

  Dot(PVector l, PVector m) {
    xPos = (int)l.x;
    yPos = (int)l.y;
    motion = m;
    MYRED = RED;
    MYGREEN = GREEN;
    MYBLUE = BLUE;
    resetTimer = 100;
  }

  void move() {
    if (resetTimer > 0) {
      resetTimer--;
    }
    /*if ((dist(xPos, yPos, mouseX, mouseY) < 200)) {
     return; 
     }*/
    if (xPos >= width || xPos <= 0 || yPos >= height || yPos <= 0) {
      int newX = width/2;
      int newY = height/2;
      resetTimer = 100;
      
     //while (newX >= width/10 && newX <= width - width/10) {
        newX = (int)random(0,width);
      //}
    //  while (newY >= height/10 && newY <= height - height/10) {
        newY = (int)random(0,height);
      //}
      xPos = newX;
      yPos = newY;
      motion = randomMotion(SPEED);
      xPos += motion.x;
      yPos += motion.y;

      //print("hit bottom");
      /* motion.x *= -1;
       xPos += motion.x;
       yPos += motion.y;
       } else if (yPos >= height || yPos <= 0) {
       //print("hit side");
       motion.y *= -1;
       xPos += motion.x;
       yPos += motion.y; */
    } else {
      xPos += motion.x;
      yPos += motion.y;
      //print("X: " + xPos + " Y: " + yPos);
    }
  }

  void drawSelf() {
    if (resetTimer == 0) {
      stroke(MYRED, MYGREEN, MYBLUE);
    } else {
      stroke(MYRED+resetTimer, MYGREEN+resetTimer, MYBLUE+resetTimer); 
  }
    strokeWeight(1);
    point(xPos, yPos);
  }
}

PVector randomMotion(int maxSpeed) {
  float moveX = random(maxSpeed * -1, maxSpeed);
  int randMultiplier = 1;
  if ((int)random(2) == 0) {
    randMultiplier = -1;
  }
  float moveY = sqrt((pow(maxSpeed, 2)) - (pow(moveX, 2))) * randMultiplier;
  print("x: " + moveX + "y: " + moveY);
  return new PVector(moveX, moveY);
}

void setup() {
  size(800, 600);
  dots = new Dot[DOT_COUNT];
  for (int i = 0; i < DOT_COUNT; i++) {
    int randX = (int)random(width);
    int randY = (int)random(height);
    PVector motion = randomMotion(SPEED);
    dots[i] = new Dot(new PVector(randX, randY), motion);
  }
}

void draw() {
  //fill(0,100);
  //rect(0,0,width+1,height+1);
  background(0);
  for (int i = 0; i < DOT_COUNT; i ++) {
    dots[i].drawSelf();
    for (int j = i; j < DOT_COUNT; j++) {
      int x1 = (int)dots[i].xPos;
      int y1 = (int)dots[i].yPos;
      int x2 = (int)dots[j].xPos;
      int y2 = (int)dots[j].yPos;
      int distance = (int)dist(x1, y1, x2, y2);
      if (distance > CONNECTION_DISTANCE) {
      } else { 
        int whitify = dots[i].resetTimer + dots[j].resetTimer;
        stroke(RED+whitify, GREEN-whitify, BLUE, 2*(100-distance));
        strokeWeight(3);
        line(x1, y1, x2, y2);
      }
    }
    dots[i].move();
  }
}
