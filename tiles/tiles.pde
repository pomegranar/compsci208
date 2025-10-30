
int cols, rows;
float tileSize = 40;
Tile[][] grid;
PVector pos, prev;
float step = 2;
float t = 0;

void setup() {
  size(800, 800);
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

  pos = new PVector(width / 2, height / 2);
  prev = pos.copy();

  stroke(255);
  strokeWeight(2.5);
  background(0);
}

void draw() {
  fill(0, 20);
  noStroke();
  rect(0, 0, width, height);
  stroke(255);
  noFill();

  t += 0.01; // animate noise / transformations

  for (int k = 0; k < 300; k++) {
    int cx = constrain(int(pos.x / tileSize), 0, cols - 1);
    int cy = constrain(int(pos.y / tileSize), 0, rows - 1);
    Tile tile = grid[cx][cy];

    PVector dir = tile.transform(pos.copy().mult(0.01), t);

    // ensure motion never dies out
    if (dir.mag() < 0.01) dir = PVector.random2D();
    dir.normalize();
    prev.set(pos);
    pos.add(dir.mult(step));

    line(prev.x, prev.y, pos.x, pos.y);

    // wrap around screen
    if (pos.x < 0) pos.x += width;
    if (pos.x > width) pos.x -= width;
    if (pos.y < 0) pos.y += height;
    if (pos.y > height) pos.y -= height;
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

