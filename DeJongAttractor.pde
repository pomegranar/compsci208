float a = random(-3, 5);
float b = random(-3, 5);
float c = random(-3, 5);
float d = random(-3, 5);

float x;
float y;
float z = random(1);
float e = 0.7, f = -1.1;
float clr1, clr2, clr3;

boolean paused = false;
float mode = 0;
int cal = 0;

void setup() {
  //size(1080, 720);
  fullScreen();
  background(0);
  //blendMode(ADD);
  //fill(255);
  noStroke();

  x = 0;
  y = 0;
}

void draw() {
  translate(width/2, height/2);
  float base = random(128);

  if (mode == 2) {
    a = -0.06;
    b = 2.84;
    c = -0.69;
    d = -1.76;
  }
  for (int i =0; i<10000; i++) {
    float x_next = sin(a*y) - cos(b*x);
    float y_next = sin(c*x) - cos(d*y);

    fill(64, 128, 174, 15);

    if (mode == 0) {
      ellipse(x_next*100, y_next*100, 1, 1);
    } else if (mode == 1) {
      ellipse(x_next*300*sin(map(i, 1, 10000, 0, 2*PI)), y_next*300*sin(map(i, 1, 10000, 0, 2*PI)), 1, 1);
    } else if (mode == 2) {
      ellipse(x_next*random(300), y_next*random(300), 1, 1);
    }

    fill(255);
    textSize(28);
    int base_height = 450;

    if (cal>450000) {
      text("a: "+ a, 500, height/2-base_height-200);
      text("b: "+ b, 500, height/2-base_height-150);
      text("c: "+ c, 500, height/2-base_height-100);
      text("d: "+ d, 500, height/2-base_height-50);
      text("Mode: "+ mode, 500, height/2-base_height);
    }
    //println(x_next, y_next);
    x = x_next;
    y = y_next;
  }

  cal += 10000;

  if (cal >= 500000) {
    newLoop();
    cal = 0;
  }
}

void newLoop () {
  background(0);
  a = random(-5, 5);
  b = random(-5, 5);
  c = random(-5, 5);
  d = random(-5, 5);

  mode = int(random(3));
}

void mouseClicked() {
  paused = !paused;
  if (paused) {
    noLoop();
  } else {
    loop();
  }
}
