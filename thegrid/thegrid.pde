int gridDensity, gap, x, y;

void setup() {
  size(400, 400);
  colorMode(HSB, 360, 100, 100, 100);
  noStroke();
  background(152, 190, 100);
  gridDensity = width/10;
  gap = 6;
  frameRate(60);
}

void draw() {
  drawGrid();
  noFill();
  blendMode(ADD);
  stroke(color(154,34,63,100));
  circle(width/2,height/2,frameCount/(frameRate/15));
  blendMode(BLEND);
}

void drawGrid() {
  fill(color(152, 190, 10, 1));
  rect(0,0,width,height);
  for (int x=gap/2; x<width; x=x+gridDensity) {
    for (int y=gap/2; y<height; y=y+gridDensity) {
      fill(color(133, 50, 20, 10));
      rect(x, y, gridDensity-gap, gridDensity-gap);
    }
  }
}
