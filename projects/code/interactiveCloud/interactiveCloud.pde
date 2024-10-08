float PT_RAD = 10;
int N_DOTS = 400;
float MAX_DOT_BORDER = 5;
float DOT_SENSITIVITY = 5;
float ALPH = 30;

PFont f;
int FONT_SIZE = 20;

color BACKGROUND_COLOR = color(255);
color BORDER_COLOR = color(0);
color CONTENT_COLOR = color(200);
color DOT_COLOR = color(0, 150, 255);

JSONArray json;

ArrayList<Dot> dots;
Pane pointPane;
Pane textPane;

void setup() {
  background(BACKGROUND_COLOR);
  size(600, 600);
  f = createFont("Arial", FONT_SIZE, true);
  textMode(MODEL);

  pointPane = new Pane(new PVector(10, 10), width-20, height-20, CONTENT_COLOR, BORDER_COLOR);

  dots = new ArrayList<Dot>();
  json = loadJSONArray("repos2d.json");
  for (int i = 0; i < json.size (); i++) {
    JSONObject importVec = json.getJSONObject(i);
    String name = importVec.getString("word");
    float x = importVec.getFloat("x");
    float y = importVec.getFloat("y");
    PVector dotloc = new PVector(x, y);
    dots.add(new Dot(name, pointPane.scalePoint(dotloc), 10, DOT_COLOR));
  }
}

void draw() {
  background(BACKGROUND_COLOR);
  pointPane.show();
  for (Dot d : dots) {
    d.show();
  }
  Dot closest = null;
  float distt = -1;
  for (Dot d : dots) {
    float x = d.getDist();
    if (x < distt || distt == -1) {
      distt = x;
      closest = d;
    }
  }
  closest.showName();
}
