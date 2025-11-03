int month = month();
float noiseScale=0.91;
String season;
color grass = color(100, 100, 50);
color sky;
int groundLevel;
int numberOfClouds;
Cloud[] clouds;
Snowflake[] snow;
int numberOfSnow;
PFont font;


void setup() {
  font = createFont("Georgia", 128);
  textFont(font);
  size(600, 900);
  colorMode(HSB, 360, 100, 100, 255);
  fill(102);
  noStroke();
  //month = 3; // FOR DEBUG PURPOSES. WILL REMOVE BEFORE SUBMIT.
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
  numberOfClouds = int(random(10, 20));
  clouds = new Cloud[numberOfClouds];
  for (int i = 0; i < numberOfClouds; i++) {
    clouds[i] = new Cloud();
  }
  numberOfSnow = int(random(20, 500));
  snow = new Snowflake[numberOfSnow];
  for (int i = 0; i < numberOfSnow; i++) {
    snow[i] = new Snowflake();
  }
}

void draw() {
  drawSky(sky);
  drawSun();
  drawGrass();
  drawTree();
  if (season=="winter" || season=="spring") {
    drawSnow(snow);
  }
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
    noiseSeed((long)random(400)*(long)random(400));
    randomSeed((long)random(400)*(long)random(400));
    break;
  }
  if (key == ' ') {
    String timestamp = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + "_" +
      nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    saveFrame("screenshot_" + timestamp + ".png");
    println("Screenshot saved!");
  }
}

void drawTree() {
  int rootx = width/2;
  int rooty = groundLevel;
  Tree tree1 = new Tree(rootx, rooty);
  tree1.draw();
}

//void drawGrass() {
//  for (int patch=0; patch<10; patch++) {
//    for (int blade=0; blade<10; blade++) {
//      print("");
//    }
//  }
//};

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
  color brown = color(40, 100, 20);
  color green = color(80, 100, 50);
  color yellow = color(30, 100, 80);



  void draw() {
    float growth = map(noise(rootx), 0, 1, rootThickness*10, rootThickness*15);
    float curvature = map(noise(rootx*7), 0, 1, 1, 20);
    fill(brown);
    // This loop draws the roots:
    for (int i=0; i<10; i++) {
      triangle(rootx-rootThickness, groundLevel, rootx+rootThickness, groundLevel, map(noise(rootx+20*i), 0, 1, rootx-100, rootx+100), map(noise(rooty+20*i), 0, 1, rooty, rooty+60));
    }
    // TODO: Add a recursive trunk function so that the trunk gets thinner toward the top. Perhaps use a trig function.
    beginShape();
    vertex(rootx+rootThickness, rooty);
    for (int growthStage=0; growthStage<growth; growthStage=growthStage+2) {
      float vx = (noise(rootx+42)-0.5)*map(growthStage, 0, growth, 0, 200)+rootx+rootThickness*map(growthStage, 0, growth, 1, 0)+sin(map(growthStage, 0, growth, 0, TWO_PI)*noise(rooty)*4)*curvature;
      float vy = rooty-growthStage;
      vertex(vx, vy);
      //if (growthStage>(growth/2) && noise(growthStage)>0.6) {
      //  //spawnBranch(vx+5, vy, growthStage);
      //  //triangle(vx+5, vy, vx+50, vy, vx, vy+5);
      //  float vvx=vx+noise(vx)*map(growthStage, 0, growth, 300, 100);
      //  vertex(vvx, vy);
      //  //beginShape();
      //  //fill(green);
      //  //vertex(vvx+10, vy+10);
      //  //vertex(vvx+20, vy);
      //  //vertex(vvx+10, vy-10);
      //  //vertex(vvx, vy);
      //  //endShape();
      //  //fill(brown);
      //  vertex(vx, vy+7);
      //  growthStage=growthStage+6;
      //}
    }
    for (int growthStage=int(growth); growthStage>0; growthStage=growthStage-2) {
      float vx = (noise(rootx+42)-0.5)*map(growthStage, 0, growth, 0, 200)+rootx-rootThickness*map(growthStage, 0, growth, 1, 0)+sin(map(growthStage, 0, growth, 0, TWO_PI)*noise(rooty)*4)*curvature;
      float vy = rooty-growthStage;
      vertex(vx, vy);
      //if (growthStage>(growth/2) && noise(growthStage*2)>0.7) {
      //  //spawnBranch(vx+5, vy, growthStage);
      //  //triangle(vx+5, vy, vx+50, vy, vx, vy+5);
      //  vertex(vx+noise(vx)*map(growthStage, 0, growth, -300, -100), vy);
      //  vertex(vx, vy-5);
      //}
    }
    vertex(rootx-rootThickness, rooty);
    endShape();
    if (season != "fall") {
      fill(green);
    } else {
      fill(yellow);
    }
    if (season != "winter") {
      ellipse(rootx, height-growth-200, 180, 100);
      ellipse(rootx+(noise(rootx*13)-0.5)*200, height-growth-250, 100, 50);
      ellipse(rootx+(noise(rootx*12)-0.5)*200, height-growth-150, 80, 50);
      ellipse(rootx+(noise(rootx*11)-0.5)*250, height-growth-180, 80, 50);
      ellipse(rootx+(noise(rootx*11)-0.5)*250, height-growth-190, 80, 50);
    }
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
  fill(0, 20);
  text("Fall", groundLevel, 200);
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
    // Clouds move with the wind.
    x = x + map(y, 0, height - (height - groundLevel), 0.7, 0);
    if (x > (width+150)) x= -150;
  }
}

class Snowflake {
  int x, y;
  Snowflake () {
    this.x = int(random(0, width));
    this.y = int(random(0, height));
  }
  void draw() {
    if (season=="winter") {
      fill(0, 0, 100);
      circle(x, y, 3);
      if (x>width) {
        x=0;
      } else {
        x=x+(int)(6*sin(noise(x, y)));
      }
      if (y>height) {
        y=0;
      } else {
        y=y+2;
      }
    } else {
      stroke(220, 30, 100, 230);
      strokeWeight(3);
      line(x, y, x+(int)(2*sin(noise(x, y))), y+8);
      noStroke();
      if (x>width) {
        x=0;
      } else {
        x=x+1+(int)(2*sin(noise(x, y)));
      }
      if (y>height) {
        y=0;
      } else {
        y=y+4;
      }
    }
  }
}

void drawSnow(Snowflake[] snow) {
  for (int snowId = 0; snowId < snow.length; snowId++) {
    snow[snowId].draw();
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
    sky = color(220, 25, 90, 255);
    grass = color(40, 65, 70);
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
