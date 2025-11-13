
int cols, rows;
float tileSize = 40;
Tile[][] grid;
PVector[] pos = new PVector[3];
PVector[] prev = new PVector[3];
color[] colsRGB = { color(255, 0, 0, 20), color(0, 255, 0, 20), color(0, 0, 255, 20) };
float step = 2;
float t = 0;

void setup() {
  size(800, 800);
  blendMode(ADD);
  cols = int(width / tileSize);
  rows = int(height / tileSize);
  grid = new Tile[cols][rows];
  noiseSeed((int)random(9999));

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float n = noise(i * 0.1, j * 0.1);
      grid[i][j] = new Tile(i, j, n);
    }
  }

  for (int i = 0; i < 3; i++) {
    pos[i] = new PVector(random(width), random(height));
    prev[i] = pos[i].copy();
  }

  background(0);
  strokeWeight(2.5);
}

void draw() {
  fill(0, 10);
  noStroke();
  rect(0, 0, width, height);
  noFill();

  t += 0.01;

  for (int i = 0; i < 3; i++) {
    stroke(colsRGB[i]);

    for (int k = 0; k < 200; k++) {
      int cx = constrain(int(pos[i].x / tileSize), 0, cols - 1);
      int cy = constrain(int(pos[i].y / tileSize), 0, rows - 1);
      Tile tile = grid[cx][cy];

      PVector dir = tile.transform(pos[i].copy().mult(0.01), t + i * 10);
      if (dir.mag() < 0.01) dir = PVector.random2D();
      dir.normalize();
      prev[i].set(pos[i]);
      pos[i].add(dir.mult(step));

      line(prev[i].x, prev[i].y, pos[i].x, pos[i].y);

      if (pos[i].x < 0) pos[i].x += width;
      if (pos[i].x > width) pos[i].x -= width;
      if (pos[i].y < 0) pos[i].y += height;
      if (pos[i].y > height) pos[i].y -= height;
    }
  }
  stroke(0);
  strokeWeight(1);
  for (int x = 0; x < cols; x++) {
    line(x * tileSize, 0, x * tileSize, height);
  }
  for (int y = 0; y < rows; y++) {
    line(0, y * tileSize, width, y * tileSize);
  }stroke(0);
  strokeWeight(1);
  for (int x = 0; x < cols; x++) {
    line(x * tileSize, 0, x * tileSize, height);
  }
  for (int y = 0; y < rows; y++) {
    line(0, y * tileSize, width, y * tileSize);
  }
}

class Tile {
  int x, y;
  float noiseVal;
  int funcType;
  float amp, freq;

  Tile(int x, int y, float n) {
    this.x = x;
    this.y = y;
    this.noiseVal = n;
    funcType = int(map(n, 0, 1, 0, 4));
    amp = map(noise(x * 0.2, y * 0.2), 0, 1, 0.8, 2.0);
    freq = map(noise(x * 0.3, y * 0.3), 0, 1, 0.8, 2.5);
  }

  PVector transform(PVector p, float t) {
    float v = (p.x + 5 * sin(t * 0.3)) * freq +
              (p.y + 5 * cos(t * 0.2)) * freq;
    float dx = 0, dy = 0;

    switch (funcType) {
      case 0:
        dx = sin(v + t) * amp;
        dy = cos(v - t) * amp;
        break;
      case 1:
        dx = sin(v * 0.5 + t) * exp(cos(v + t * 0.5)) * 0.3 * amp;
        dy = cos(v * 0.7 - t) * exp(sin(v - t * 0.5)) * 0.3 * amp;
        break;
      case 2:
        dx = (sin(v * 0.8 + t) + cos(v * 1.2 - t)) * 0.5 * amp;
        dy = (cos(v * 0.9 - t) - sin(v * 1.1 + t)) * 0.5 * amp;
        break;
      case 3:
        dx = sin(v + cos(v * 1.5 + t)) * amp;
        dy = cos(v - sin(v * 1.5 - t)) * amp;
        break;
    }

    return new PVector(dx, dy);
  }
}

