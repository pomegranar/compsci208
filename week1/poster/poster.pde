int resolution = 660;
int posterHeight = resolution;
int posterWidth = (resolution / 4) * 3;
int month = month();
String season;
color grass = color(100, 100, 50);
color sky;

void setup() {
  size(360, 480);
  colorMode(HSB, 360, 100, 100, 255);
  fill(102);
  noStroke();
  month = 3; // FOR DEBUG PURPOSES. REMOVE BEFORE SUBMIT.
  println(month);
  updateBG();
}

void draw() {
  updateBG();
  fill(color(90, 100, 20));
  rect(width/2 - 5, 100, 10, height);
  fill(grass);
  rect(0, 3*(height / 4), width, height);
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
  }
}

void updateBG() {
  if (season == "winter") {
    sky = color(220, 5, 100, 255);
    grass = color(100, 5, 100);
  } else if (season == "spring") {
    sky = color(220, 30, 100, 255);
    grass = color(100, 50, 100);
  } else if (season == "summer") {
    sky = color(220, 40, 100, 255);
    grass = color(100, 100, 100);
  } else {
    grass = color(100, 100, 100);
    sky = color(220, 20, 100, 255);
  }
  drawSky(sky);
}

void drawSky(color baseColor) {
  color(baseColor);
  rect(0, 0, width, height);
  for (int band = 0; band < height; band = band + 2) {
    color(220, 50, 100, map(band, 0, height, 0, 255));
    rect(band, 0, band+2, width);
  }
}
