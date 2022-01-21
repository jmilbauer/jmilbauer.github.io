boolean didMouseClick(float x, float y, float w, float h) {
  return didSomethingClick(mouseX, mouseY, x, y, w, h);
}

boolean didSomethingClick(float mx, float my, float x, float y, float w, float h) //simple function to do hit testing
{
  return (mx > x && mx<x+w && my>y && my<y+h); //check to see if it is in button bounds
}

// Checks & handles for advancement clicks.
void nextClick(int x, int y) {
  //You are allowed to have a next button outside the 1" area
  if (didSomethingClick(x, y, 600, 600, 200, 200)) //check if click is in next button
  {
    nextTrial(); //if so, advance to next trial
  }
  return;
}
