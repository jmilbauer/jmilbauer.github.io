var bubbles = [];
var roots = [];
var drawstack = [];
var running = false;
var spacedown = false;
var cherryMode = false;
const w = window.innerWidth;
const h = window.innerHeight-30;

const tree_width = h/20;
const growspeed = h/600;

function setup() {
  createCanvas(w*3, h);
  running = false;
  startover();
}

function startover() {
  background(0);
  roots = [];
  branches = [];
  drawstack = [];
}

function draw() {
  if (cherryMode) {
    background(0,0,50);
  } else {
    background(0);
  }

  if (running) {
    drawArt();
  } else {
    drawInstructions();
  }
}

function drawInstructions() {
  textSize(18);
  strokeWeight(0);
  fill(255);
  text("Press SPACE to draw a tree.",20,30);
  text("Click and hold to draw a moon.",20, 60);
  text("Press ENTER to start or reset.",20, 90);
  text("Press DELETE or BACKSPACE to remove the last element.",20,120);
  text("Press 'c' for Cherry Blossom Mode.", 20, 150);
}

function drawArt() {
  stroke(255);
  strokeWeight(.5);
  line(0, 5*height/6, width, 5*height/6);

  for (let i = 0; i < bubbles.length; i++) {
    bubbles[i].display();
  }

  for (let i = 0; i < roots.length; i++) {
    roots[i].display();
    roots[i].grow();
  }

  if (mouseIsPressed) {
    bubbles[bubbles.length-1].x = mouseX;
    bubbles[bubbles.length-1].y = mouseY;
    bubbles[bubbles.length-1].grow();
  }

  if (spacedown) {
    stroke(0,255,0,50);
    strokeWeight(tree_width);
    line(mouseX, 0, mouseX, height);
    print(key);
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
  // if (keyCode == DELETE || keyCode == BACKSPACE) {
  //   if (drawstack.length != 0) {
  //     if (drawstack[drawstack.length - 1])
  //   }
  // }
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
    roots.push(new Branch(mouseX-tree_width/2, 5*height/6, tree_width, radians(0), color(random(0,255), random(0,255), random(0,255))));
  }
}

function mousePressed() {
  bubbles.push(new Bubble(0,0));
  drawstack.push(true);
}

class Bubble {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.r = 0;
    this.i = 0;
    this.col = color(random(20,255), random(20,255), random(20,255), 125);
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
    this.tipY = int(random(s/3, 2*s/3));
    this.intensity = 255;
    this.col = col;
    this.leftChild = null;
    this.rightChild = null;
    this.fading = false;
  }

  display() {
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
    translate(x,y);
    rotate(theta);
    strokeWeight(0);
    fill(col, intensity);

    if (cherryMode) {
      strokeWeight(0);
      if (this.s > 6) {
        fill(75, 64, 41, intensity);
      } else {
        fill(233, 150, 160, intensity);
      }
    }

    rect(0,0,s,-s);
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

  addLeftChild() {
    let opposite = -this.tipY;
    let adjacent = this.tipX;
    let myTheta = atan(opposite / adjacent);
    let edgeDist = dist(0, 0, this.tipX, -this.tipY);
    this.leftChild = new Branch(0, -this.s, edgeDist, myTheta, this.col);
  }

  addRightChild() {
    let opposite = -this.tipY;
    let adjacent = -(this.s-this.tipX);
    let myTheta = atan(opposite / adjacent);
    let edgeDist = dist(this.s, 0, this.tipX, -this.tipY);
    this.rightChild = new Branch(this.tipX, -this.s-this.tipY, edgeDist, myTheta, this.col);
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
