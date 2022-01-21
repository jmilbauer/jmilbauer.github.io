class Pane {
  PVector loc;
  float w, h;
  color bg;
  color border;

  Pane(PVector loc, float w, float h, color bg, color b) {
    this.loc = loc;
    this.w = w;
    this.h = h;
    this.bg = bg;
    this.border = b;
  }

  void show() {
    fill(this.bg);
    stroke(this.border);
    strokeWeight(5);
    rect(this.loc.x, this.loc.y, w, h);
  }

  PVector scalePoint(PVector p) {
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
