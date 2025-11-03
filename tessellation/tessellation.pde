// Soccer-ball–style tessellation (Processing 4, Java mode)
// Hex grid + regular pentagons placed in a repeating pattern.

int cols = 18;
int rows = 18;
float R = 36; // hexagon circumradius (adjust to scale)
float pad = 20;

void setup() {
  size(900, 900);
  noLoop();
  smooth();
}

void draw() {
  background(240);
  translate(pad, pad);
  float w = sqrt(3) * R;         // horizontal spacing for pointy-top hex
  float h = 2 * R;               // hex height
  float vert = 0.75f * h;        // vertical step between rows

  stroke(20);
  strokeWeight(2);
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      float x = c * w + (r % 2) * (w / 2);
      float y = r * vert;
      // draw white hex
      fill(255);
      drawHex(x, y, R);

      // rule to place pentagon patches in a pleasing repeating arrangement
      // tweak modulus to change density/spacing
      if ((c + 2 * r) % 7 == 0) {
        pushMatrix();
        translate(x, y);
        float pR = R * 0.62f;    // pentagon size relative to hex
        float rot = (r % 2 == 0) ? radians(18) : radians(-18);
        rotate(rot);
        // black pentagon patch with thin white inner border
        fill(20);
        noStroke();
        drawPolygon(0, 0, pR, 5, 0);
        stroke(255);
        strokeWeight(2);
        noFill();
        drawPolygon(0, 0, pR * 0.78f, 5, 0);
        popMatrix();
      }
    }
  }
}

// Draw a regular hexagon (6 sides)
void drawHex(float cx, float cy, float r) {
  beginShape();
  for (int i = 0; i < 6; i++) {
    float ang = TWO_PI / 6 * i + PI / 6; // pointy-top orientation
    float vx = cx + cos(ang) * r;
    float vy = cy + sin(ang) * r;
    vertex(vx, vy);
  }
  endShape(CLOSE);
}

// Generic regular polygon centered at (cx,cy)
void drawPolygon(float cx, float cy, float rad, int sides, float startAngle) {
  beginShape();
  for (int i = 0; i < sides; i++) {
    float ang = TWO_PI / sides * i + startAngle;
    vertex(cx + cos(ang) * rad, cy + sin(ang) * rad);
  }
  endShape(CLOSE);
}
