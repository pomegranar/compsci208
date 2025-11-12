int scale = 40;
float h;

void setup() {
  size(800, 400);
  noStroke();
  h = scale * sin(radians(60));
}

void draw() {
  background(0);
  for (int row = 0; row < height / h + 2; row++) {
    float y = row * h;
    float off = (row % 2 == 0) ? 0 : scale / 2.0;
    for (int col = 0; col < width / scale - 1; col++) {
      float x = col * scale + off + scale/4;

      // upright triangle
      fill(255);
      triangle(x, y, x + scale, y, x + scale / 2, y - h);

      // inverted triangle (fills the gap below)
      fill(150);
      triangle(x, y, x + scale / 2, y + h, x + scale, y);
    }
  }
}
