import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class interactiveCloud extends PApplet {

float PT_RAD = 10;
int N_DOTS = 400;
float MAX_DOT_BORDER = 5;
float DOT_SENSITIVITY = 50;
float ALPH = 150;

PFont f;
int FONT_SIZE = 20;

int BACKGROUND_COLOR = color(255);
int BORDER_COLOR = color(0);
int CONTENT_COLOR = color(200);
int DOT_COLOR = color(0, 150, 255);

JSONArray json;

ArrayList<Dot> dots;
Pane pointPane;
Pane textPane;


public void setup() {
  background(BACKGROUND_COLOR);
  size(600, 600);
  f = createFont("Arial", FONT_SIZE, true);
  textMode(MODEL);

  pointPane = new Pane(new PVector(10, 10), width-20, height-20, CONTENT_COLOR, BORDER_COLOR);

  dots = new ArrayList<Dot>();
  json = loadJSONArray("imports2D.json");
  for (int i = 0; i < json.size (); i++) {
    JSONObject importVec = json.getJSONObject(i);
    String name = importVec.getString("word");
    float x = importVec.getFloat("x");
    float y = importVec.getFloat("y");
    PVector dotloc = new PVector(x, y);
    dots.add(new Dot(name, pointPane.scalePoint(dotloc), 10));
  }
}

public void draw() {
  background(BACKGROUND_COLOR);
  pointPane.show();
  for (Dot d : dots) {
    d.show();
  }
  for (Dot d : dots) {
    d.showName();
  }
}
class Dot {
  PVector loc;
  float r;
  float sensitivity_range;
  String name;

  Dot(PVector loc, float r) {
    this.loc = loc;
    this.r = r;
    this.sensitivity_range = DOT_SENSITIVITY - this.r;
  }

  Dot(String name, PVector loc, float r) {
    this.name = name;
    this.loc = loc;
    this.r = r;
    this.sensitivity_range = DOT_SENSITIVITY - this.r;
  }

  public void show() {
    float d = dist(this.loc.x, this.loc.y, mouseX, mouseY);
    if (d < DOT_SENSITIVITY) {
      stroke(255, 255, 255);
      float scaled = (this.sensitivity_range - max(d-PT_RAD, 0))/this.sensitivity_range;
      strokeWeight(scaled * MAX_DOT_BORDER);
      fill(DOT_COLOR, ALPH);
      ellipse(this.loc.x, this.loc.y, PT_RAD, PT_RAD);
    } else {
      noStroke();
      fill(DOT_COLOR, ALPH);
      ellipse(this.loc.x, this.loc.y, PT_RAD, PT_RAD);
    }
  }

  public void showName() {
    float d = dist(this.loc.x, this.loc.y, mouseX, mouseY);
    float scaled = (this.sensitivity_range - max(d-PT_RAD, 0))/this.sensitivity_range;

    if (d < this.r && name != null) {
      int fsize = max(((int) (pow(scaled, 4) * FONT_SIZE)), 1);
      textSize(fsize);
      if (textWidth(name) + this.loc.x + this.r + 20 > width) {
        textAlign(RIGHT);
      } else {
        textAlign(LEFT);
      }
      fill(255);
      int borderStroke = 2;
      for (int i=-1; i<2; i++){
        text(name, this.loc.x + (this.r)+(borderStroke*i), (this.loc.y + this.r/2));
        text(name, this.loc.x + (this.r), (this.loc.y + this.r/2)+(borderStroke*i));
      }
      fill(0);
      text(name, this.loc.x + (this.r), (this.loc.y + this.r/2));
    }
  }

  public void showBland() {
    noStroke();
    fill(DOT_COLOR);
    ellipse(this.loc.x, this.loc.y, PT_RAD, PT_RAD);
  }
}
class Pane {
  PVector loc;
  float w, h;
  int bg;
  int border;

  Pane(PVector loc, float w, float h, int bg, int b) {
    this.loc = loc;
    this.w = w;
    this.h = h;
    this.bg = bg;
    this.border = b;
  }

  public void show() {
    fill(this.bg);
    stroke(this.border);
    strokeWeight(5);
    rect(this.loc.x, this.loc.y, w, h);
  }

  public PVector scalePoint(PVector p) {
    // Expects a point that has been scaled to [0,1]
    float w_area = this.w - (MAX_DOT_BORDER * 4);
    float h_area = this.h - (MAX_DOT_BORDER * 4);
    PVector res = new PVector(p.x*w_area, p.y*h_area);

    //offset the point
    res.x += this.loc.x + (MAX_DOT_BORDER*2);
    res.y += this.loc.y + (MAX_DOT_BORDER*2);

    return res;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "interactiveCloud" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
