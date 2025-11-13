
int cols, rows;
float tileSize = 200;
Tile[][] grid;
PVector[] pos = new PVector[3];
PVector[] prev = new PVector[3];
color[] colsRGB = { color(255, 0, 0, 200), color(0, 255, 0, 200), color(0, 0, 255, 200) };
float step = 2;
float t = 0;
int minute;

void setup() {
  size(1000, 1000);
  // fullScreen();
  frameRate(60);
  blendMode(ADD);
  cols = int(width / tileSize);
  rows = int(height / tileSize);
  grid = new Tile[cols][rows];
  noiseSeed((int)random(4353));

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
}

void draw() {
  if (frameCount%frameRate!=0) {
    noStroke();
    blendMode(DARKEST);
    // blendMode(MULTIPLY);
    if (frameCount%2==0) fill(0, 1);
    rect(0, 0, width, height);
    //rect(width/4, height/4, width/2, height/2);
    noFill();

    t += 10;

    strokeWeight(2);
    blendMode(ADD);
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
    //// grid so that it's more obvious
    //blendMode(DIFFERENCE);
    //stroke(0, 10);
    //strokeWeight(1);
    //for (int x = 0; x < cols; x++) {
    //  line(x * tileSize, 0, x * tileSize, height);
    //}
    //for (int y = 0; y < rows; y++) {
    //  line(0, y * tileSize, width, y * tileSize);
    //}
    //stroke(0);
    //strokeWeight(1);
    //for (int x = 0; x < cols; x++) {
    //  line(x * tileSize, 0, x * tileSize, height);
    //}
    //for (int y = 0; y < rows; y++) {
    //  line(0, y * tileSize, width, y * tileSize);
    //}
    //blendMode(ADD);
  } else {
    blendMode(0);
    fill(0);
    rect(0, 0, width, height);
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
    amp = map(noise(x * 0.2, y * 0.2), 0, 1, 4.0, 8.0);
    freq = map(noise(x * 0.3, y * 0.3), 0, 1, 3, 7);
  }

  PVector transform(PVector p, float t) {
    float v = (p.x + 5 * sin(t * 0.3)) * freq +
      (p.y + 5 * cos(t * 0.2)) * freq;
    float dx = 0, dy = 0;

    switch (funcType) {
    case 0:
      dx = sin(v + t) * amp;
      dy = -cos(v * 0.7 - t) * exp(sin(v - t * 0.5)) * 3.3 * (amp*noiseVal);
      break;
    case 1:
      dx = -sin(v * 1.5 + t) * exp(cos(v + t * 0.5)) * 3.3 * (amp/noiseVal);
      dy = cos(v - t) * (amp*noiseVal);
      break;
    case 2:
      dx = (sin(v * 0.8 + t) + cos(v * 1.2 - t)) * 0.5 * (amp/noiseVal);
      dy = -cos(v - sin(v * 1.5 - t)) * (amp*noiseVal);
      break;
    case 3:
      dy = (cos(v * 0.9 - t) - sin(v * 1.1 + t)) * 0.5 * (amp*noiseVal);
      dx = sin(v + cos(v * 1.5 + t)) * (amp/noiseVal);
      break;
    }

    return new PVector(dx, dy);
  }
}
