class Suggestion {

  int x;
  int y;
  int w;
  int h;
  HashMap<String, String> errMap;
  ArrayList<String> topWords;
  HashMap<String, Boolean> tops;
  String continuation;

  public Suggestion(float x, float y, float w, float h) {
    this.x = (int) x;
    this.y = (int) y;
    this.w = (int) w;
    this.h = (int) h;

    this.topWords = new ArrayList<String>();
    this.tops = new HashMap<String, Boolean>();
    loadFrom(topstring);
    this.continuation = "";
  }

  public String getSuggestion() {
    return "";
  }

  private void loadFrom(String topstring) {
    String[] words = topstring.split(",");
    for (String w : words) {
      this.tops.put(w, true);
      this.topWords.add(w);
    }
  }

  public String getContinuation(String sofar, float maxlen) {
    if (sofar.length() < 1) {
      this.continuation = "";
      return "";
    }
    for (String w : this.topWords) {
      if (w.startsWith(sofar)) {
        String cont = w.substring(sofar.length(), w.length());
        if (textWidth(sofar + "|" + cont) < maxlen && cont.length() > 0) {
          this.continuation = cont;
          return cont + " ";
        }
      }
    }
    this.continuation = "";
    return "";
  }

  public String getResult(int mx, int my) {
    if (this.x < mx && mx < this.x + this.w) {
      if (this.y < my && my < this.y + this.h) {
        return this.continuation;
      }
    }
    return "";
  }
  
  public String getResultAlways() {
    return this.continuation;
  }
}
