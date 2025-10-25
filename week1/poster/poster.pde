int month = month();
float noiseScale=0.91;
String season;
color grass = color(100, 100, 50);
color sky;
int groundLevel;
int numberOfClouds;
Cloud[] clouds;


void setup() {
  size(400, 900);
  colorMode(HSB, 360, 100, 100, 255);
  fill(102);
  noStroke();
  month = 3; // FOR DEBUG PURPOSES. WILL REMOVE BEFORE SUBMIT.
  if (month >= 3 && month <= 5) {
    season = "spring";
  } else if (month >= 6 && month <= 8) {
    season = "summer";
  } else if (month >= 9 && month <= 11) {
    season = "fall";
  } else {
    season = "winter";
  }
  println(month);
  updateBG();
  groundLevel = 3*(height / 4);
  numberOfClouds = int(random(10, 30));
  clouds = new Cloud[numberOfClouds];
  for (int i = 0; i < numberOfClouds; i++) {
    clouds[i] = new Cloud();
  }
}

void draw() {
  drawSky(sky);
  drawSun();
  drawGrass();
  drawTree();
}

void keyPressed() {
  switch(key) {
  case '1':
    season = "winter";
    updateBG();
    break;
  case '2':
    season = "spring";
    updateBG();
    break;
  case '3':
    season = "summer";
    updateBG();
    break;
  case '4':
    season = "fall";
    updateBG();
    break;
  case 'r':
    noiseSeed((long)random(400));
    randomSeed((long)random(400));
    break;
  }
}

void drawTree() {
  int rootx = width/2;
  int rooty = groundLevel;
  Tree tree1 = new Tree(rootx,rooty);
  tree1.draw();
}

class Tree {
  int rootx, rooty, scale = 1, rootThickness;

  Tree (int x, int y) {
    rootx = x;
    rooty = y;
    rootThickness = int(map(noise(rootx), 0, 1, 10, 40)*scale);
  }

  Tree (int x, int y, int s) {
    rootx = x;
    rooty = y;
    scale = s;
    rootThickness = int(map(noise(rootx), 0, 1, 10, 40)*scale);
  }

  void draw() {
    fill(color(40, 100, 20));
    // This loop draws the roots:
    for (int i=0; i<10; i++) {
      triangle(rootx-rootThickness, groundLevel, rootx+rootThickness, groundLevel, map(noise(rootx+20*i), 0, 1, rootx-100, rootx+100), map(noise(rooty+20*i), 0, 1, rooty, rooty+60));
    }
    // TODO: Add a recursive trunk function so that the trunk gets thinner toward the top. Perhaps use a trig function.
  }
}

void drawSun() {
  for (int i=0; i<30; i++) {
    fill(color(50, 5, 255, 5));
    circle(100, 100, 50+2*i);
  }
  fill(color(50, 5, 255));
  circle(100, 100, 50);
}

void drawGrass() {
  fill(grass);
  rect(0, groundLevel, width, height);
}

void drawClouds(Cloud[] clouds) {
  for (int cloudId = 0; cloudId < clouds.length; cloudId++) {
    clouds[cloudId].draw();
  }
}

class Cloud {
  float x, y;
  int[] blobsx, blobsy;
  int n;
  int blobSize = 80;

  Cloud () {
    x = int(random(0, width));
    y = int(random(0, height - (height - groundLevel +100)));
    n = int(random(5, 15));
    blobsx = new int[n];
    blobsy = new int[n];
    blobSize = int(map(y, 0, height - (height - groundLevel), 60, 2));
    for (int i = 0; i < n; i++) {
      blobsx[i] = int(random(-blobSize*2, 2*blobSize));
      blobsy[i] = int(random(-(blobSize-map(y, 0, height - (height - groundLevel), 0, blobSize/2)), blobSize-map(y, 0, height - (height - groundLevel), 0, blobSize/2)));
    }
  }
  void draw() {
    fill(color(0, 0, 100, 170));
    ellipse(x, y, 2*blobSize, blobSize-map(y, 0, height - (height - groundLevel), 0, blobSize/2));
    for (int blob = 0; blob < blobsx.length; blob++) {
      ellipse(x + blobsx[blob], y + blobsy[blob], 2*blobSize, blobSize-map(y, 0, height - (height - groundLevel), 0, blobSize/2));
      for (int fluff =0; fluff<20; fluff++) {
      }
    }
    x = x + map(y, 0, height - (height - groundLevel), 1, 0);
    if (x > (width+150)) x= -150;
  }
}

void updateBG() {
  if (season == "winter") {
    sky = color(220, 20, 100, 255);
    grass = color(100, 5, 95);
  } else if (season == "spring") {
    sky = color(220, 40, 90, 255);
    grass = color(80, 60, 80);
  } else if (season == "summer") {
    sky = color(225, 60, 95, 255);
    grass = color(100, 70, 85);
  } else {
    sky = color(220, 30, 100, 255);
    grass = color(60, 60, 60);
  }
}

void drawSky(color baseColor) {
  updateBG();
  fill(color(baseColor));
  rect(0, 0, width, height);
  drawClouds(clouds);
  for (int band = 0; band < height - (height - groundLevel); band = band + 1) {
    fill(color(220, 50, 100, map(band, 0, height - (height - groundLevel), 0, 250)));
    rect(0, band, width, 1);
  }
}
