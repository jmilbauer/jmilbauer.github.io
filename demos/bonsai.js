var bubbles = [];
var roots = [];
var grasses = [];
var grassBuffer = [];
var drawstack = [];
var running = false;
var spacedown = false;
var grassdown = false;
var cherryMode = true;
const w = window.innerWidth;
const h = window.innerHeight-30;
const gustWidth = 5;
const windWidth = 200;
const maxVel = 20;
const minEnergy = 1;
const windHeight = 50;
var mouseHistory = [];

const fps = 60;

const tree_width = h/20;
const growspeed = h/400;

function setup() {
  createCanvas(w*3, h);
  running = false;
  startover();
  frameRate(fps);
}

function startover() {
  background(0);
  roots = [];
  bubbles = [];
  grasses = [];
  drawstack = [];
}

function draw() {
  if (cherryMode) {
    background(0, 0, 50);
  } else {
    background(0);
  }

  mouseHistory.push(mouseX);
  if (mouseHistory.length > fps/3) {
    mouseHistory.shift();
  }

  drawInstructions();
  drawArt();
}

function getVel(mouseHist) {
  let vel = 0;
  if (mouseHist.length < 2) {
    vel = 0;
  } else {
    for (let i = 0; i < mouseHist.length -1; i ++) {
      vel += mouseHist[i+1] - mouseHist[i];
    }
    vel /= mouseHist.length - 1;
  }
  vel = constrain(vel, -maxVel, maxVel);
  return vel;
}

function drawInstructions() {
  textSize(14);
  strokeWeight(0);
  fill(200);
  text("Press SPACE to draw a tree.", 20, 20);
  text("CLICK and HOLD to draw a moon.", 20, 40);
  text("Press ENTER to reset.", 20, 60);
  text("Press 'g' to place grass.", 20, 80);
  text("Press DELETE or BACKSPACE to remove the last element.", 20, 100);
  text("Press 'c' to toggle Cherry Blossom / Colorful mode.", 20, 120);
}

function drawArt() {
  stroke(255);
  strokeWeight(0.5);
  line(0, 5*height/6, width, 5*height/6);

  vel = getVel(mouseHistory);

  // Paint the moons.
  for (let i = 0; i < bubbles.length; i++) {
    bubbles[i].display();
  }

  // Paint the bases of the trees
  for (let i = 0; i < roots.length; i++) {
    roots[i].displayRootOnly();
    roots[i].grow();
  }

  // Paint the grass
  for (let i = 0; i < grasses.length; i++) {
    for (let j = 0; j < grasses[i].length; j++) {
      grasses[i][j].step(vel);
      grasses[i][j].display();
    }
  }

  for (let i = 0; i < grassBuffer.length; i++ ) {
    grassBuffer[i].step(vel);
    grassBuffer[i].display();
  }

  // Paint the branches of the trees
  for (let i = 0; i < roots.length; i++) {
    roots[i].displayChildOnly();
  }

  // Sensing
  if (mouseIsPressed) {
    bubbles[bubbles.length-1].x = mouseX;
    bubbles[bubbles.length-1].y = mouseY;
    bubbles[bubbles.length-1].grow();
  }

  if (grassdown) {
    let n = random(1,5);
    for (let i = 0; i < n; i++) {
        let h = constrain(randomGaussian(5,4), 1, 25);
        grassBuffer.push(new Grass(randomGaussian(mouseX, 10), height*5/6, h));
    }
  }

  if (spacedown) {
    stroke(0, 255, 0, 50);
    strokeWeight(tree_width);
    line(mouseX, 0, mouseX, height);
  }
}

function keyPressed() {
  if (keyCode == RETURN || keyCode == ENTER) {
    running = true;
    startover();
  }
  if (key == ' ') {
    spacedown = true;
  }
  if (key == 'g') {
    grassdown = true;
  }
  if (keyCode == DELETE || keyCode == BACKSPACE) {
    if (drawstack.length != 0) {
      let t = drawstack[drawstack.length - 1];
      if (t == 0) {
        bubbles.pop();
      } else if (t == 1) {
        roots.pop();
      } else if (t == 2) {
        grasses.pop();
      }
      drawstack.pop();
    }
  }
  if (key == 'c') {
    cherryMode = !cherryMode;
    if (cherryMode) {
      document.getElementById('bg').style.background = '#000032';
    } else {
      document.getElementById('bg').style.background = 'black';
    }
  }
}

function keyReleased() {
  if (key == ' ') {
    spacedown = false;
    roots.push(new Branch(mouseX-tree_width/2, 5*height/6, tree_width, radians(0), color(random(0, 255), random(0, 255), random(0, 255))));
    drawstack.push(1);
  }
  if (key == 'g') {
    grassdown = false;
    grasses.push(grassBuffer);
    grassBuffer = [];
    drawstack.push(2);
  }
}

function mousePressed() {
  bubbles.push(new Bubble(0, 0));
  drawstack.push(0);
}

class Bubble {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.r = 0;
    this.i = 0;
    this.col = color(random(20, 255), random(20, 255), random(20, 255), 125);
  }

  grow() {
    this.r += growspeed;
  }

  display() {
    fill(this.col);
    if (cherryMode) {
      fill(230, 230, 230, 150);
    }
    stroke(0);
    strokeWeight(0);
    circle(this.x, this.y, this.r);
  }
}

class Branch {
  constructor(x, y, s, theta, col) {
    this.x = x;
    this.y = y;
    this.s = s;
    this.theta = theta;
    this.tipX = int(random(0, s));
    this.tipY = int(random(s/3, 0.64*s));
    this.intensity = 255;
    this.col = col;
    this.leftChild = null;
    this.rightChild = null;
    this.fading = false;
    this.isroot = true;

    let darkshift = random(-70,10);
    let brownshift = -10;
    this.brown = color(75+brownshift, 64+brownshift, 41+brownshift);
    this.pink = color(233+darkshift, 150+darkshift, 160+darkshift);
  }

  display() {
    // have the Z value come closer to the camera at each successive branch, this way grass will be layered properly!
    push();

    let x = this.x;
    let y = this.y;
    let theta = this.theta;
    let intensity = this.intensity;
    let s = this.s;
    let tipY = this.tipY;
    let tipX = this.tipX;
    let fading = this.fading;
    let col = this.col;
    translate(x, y);
    rotate(theta);
    strokeWeight(0);
    fill(col, intensity);

    if (cherryMode) {
      strokeWeight(0);
      if (this.s > 6) {
        fill(this.brown, intensity);
      } else {
        fill(this.pink, intensity);
      }
    }

    rect(0, 0, s, -s);
    triangle(0, -s, s, -s, tipX, -s-tipY);
    if (this.leftChild != null) {
      this.leftChild.display();
    }
    if (this.rightChild != null) {
      this.rightChild.display();
    }

    pop();

    if (fading && intensity >0) {
      intensity -= 1;
    }
    if (intensity == 0) {
      fading = false;
    }
  }

  displayRootOnly() {
    // have the Z value come closer to the camera at each successive branch, this way grass will be layered properly!
    push();

    let x = this.x;
    let y = this.y;
    let theta = this.theta;
    let intensity = this.intensity;
    let s = this.s;
    let tipY = this.tipY;
    let tipX = this.tipX;
    let fading = this.fading;
    let col = this.col;
    translate(x, y);
    rotate(theta);
    strokeWeight(0);
    fill(col, intensity);

    if (cherryMode) {
      strokeWeight(0);
      if (this.s > 6) {
        fill(this.brown, intensity);
      } else {
        fill(this.pink, intensity);
      }
    }

    rect(0, 0, s, -s);
    triangle(0, -s, s, -s, tipX, -s-tipY);

    pop();

    if (fading && intensity >0) {
      intensity -= 1;
    }
    if (intensity == 0) {
      fading = false;
    }
  }

  displayChildOnly() {
    // have the Z value come closer to the camera at each successive branch, this way grass will be layered properly!
    push();

    let x = this.x;
    let y = this.y;
    let theta = this.theta;
    let intensity = this.intensity;
    let s = this.s;
    let tipY = this.tipY;
    let tipX = this.tipX;
    let fading = this.fading;
    let col = this.col;
    translate(x, y);
    rotate(theta);

    if (this.leftChild != null) {
      this.leftChild.display();
    }
    if (this.rightChild != null) {
      this.rightChild.display();
    }

    pop();
  }

  addLeftChild() {
    let opposite = -this.tipY;
    let adjacent = this.tipX;
    let myTheta = atan(opposite / adjacent);
    let edgeDist = dist(0, 0, this.tipX, -this.tipY);
    this.leftChild = new Branch(0, -this.s, edgeDist, myTheta, this.col);
    this.leftChild.isroot = false;
  }

  addRightChild() {
    let opposite = -this.tipY;
    let adjacent = -(this.s-this.tipX);
    let myTheta = atan(opposite / adjacent);
    let edgeDist = dist(this.s, 0, this.tipX, -this.tipY);
    this.rightChild = new Branch(this.tipX, -this.s-this.tipY, edgeDist, myTheta, this.col);
    this.rightChild.isroot = false;
  }

  grow() {
    if (this.s < 5) {
      return;
    }

    if (this.leftChild != null) {
      this.leftChild.grow();
    } else {
      if (random(0, 100) < 10) {
        this.addLeftChild();
      }
    }

    if (this.rightChild != null) {
      this.rightChild.grow();
    } else {
      if (random(0, 100) < 10) {
        this.addRightChild();
      }
    }
  }
}

class Grass {
  constructor(x, y, h) {
    this.x = x;
    this.y = y;
    this.h = h;
    let greenShift = random(-10, 20);
    let otherShift = random(-10, 10);
    let darkShift = random(-100, 0);
    this.col = color(160+otherShift+darkShift, 205+greenShift+darkShift, 160+otherShift+darkShift);
    this.swaying = false;
    this.onset = null;
    this.energy = 0;
    this.energydir = 0;
    this.gust = 0;
  }

  step(vel) {
    if (this.x > mouseX - windWidth && this.x < mouseX + windWidth && mouseY < 5*height/6 && mouseY > (5*height/6)-windHeight ) {
      let velScaling = pow(1 - abs(mouseX - this.x)/windWidth,4);
      print(vel, velScaling);
      vel = vel * velScaling;
      if (!this.swaying) {
        this.swaying = true;
        this.onset = frameCount + random(0,fps/5); // random delay
        this.energy = abs(vel);
        this.energydir = vel / abs(vel);
      } else {
        let initEnergy = this.energy;
        this.energy -= maxVel / (5 * fps);
        this.energy = max(this.energy, abs(vel));
      }
    } else if (this.energy == 0) {
      this.swaying = false;
      this.onset = null;
    } else if (this.energy > 0) {
      this.energy -= maxVel / (2 * fps);
      this.energy = max(this.energy, 0);
    }

    this.gust = 0;
    if (this.swaying) {
      let sinval = sin((max(0,frameCount-this.onset))*6.28/fps);
      sinval = constrain(sinval, -1, 1);
      this.gust = gustWidth*(this.energy/maxVel)*sinval;
      this.gust *= this.energydir;
    }
  }

  display() {
    stroke(this.col);
    strokeWeight(2);
    line(this.x, this.y, this.x+this.gust, this.y - this.h);
  }
}
