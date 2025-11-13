
import java.awt.Rectangle;
import processing.video.*;
import gab.opencv.*;
import org.opencv.core.*;

PImage img, depth, blurred;
Capture cam;
OpenCV opencv;

float[][] heights;
int cols, rows;
float scaleFactor = 2;

float camX = 0, camY = 0;  // camera offsets

void setup() {
  size(800, 600, P3D);

  img = loadImage("marias.png");
  depth = loadImage("marias-depth.png");
  blurred = img.copy();
  blurred.filter(BLUR, 6);
  img.resize(200, 200);
  depth.resize(200, 200);

  cols = img.width;
  rows = img.height;
  heights = new float[cols][rows];

  // map depth map
  depth.loadPixels();
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      float b = brightness(depth.pixels[y * cols + x]);
      heights[x][y] = map(b, 0, 205, -50, 50);  // adjust vertical scale
    }
  }

  // webcam (WHY WON'T IT WORK ANYMORE)
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  cam.start();

  opencv = new OpenCV(this, cam.width, cam.height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
}

void draw() {
  background(0);
  //pushMatrix();
  //resetMatrix();  
  //image(blurred, 0, 0, width, height);
  //popMatrix();

  lights();
  
  float targetX = map(mouseX, 0, width, -50, 50);
  float targetY = map(mouseY, 0, height, -30, 30);
  camX = lerp(camX, targetX, 0.1);
  camY = lerp(camY, targetY, 0.1);

  if (cam.available()) {
    cam.read();
    opencv.loadImage(cam);
    Rectangle[] faces = opencv.detect();
    if (faces.length > 0) {
      float faceX = faces[0].x + faces[0].width/2;
      float faceY = faces[0].y + faces[0].height/2;
      camX = map(faceX, 0, cam.width, -50, 50);
      camY = map(faceY, 0, cam.height, -30, 30);
    }
    //println("faces:", faces.length, "camX:", camX, "camY:", camY);
  }


  // make camera move with user's head
  camera(width/2 + camX, height/2 + camY, 150, width/2, height/2, 0, 0, 1, 0);

  // 3D surface render logic
  // translate(width/2 - cols/2, height/2 - rows/2);
  // rotateX(PI/3);  // top-down tilt
  translate(width/2 - cols/2, height/2 - rows/2, 0);

  noStroke();
  textureMode(NORMAL);
  texture(img);

  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      float h1 = heights[x][y] * scaleFactor;
      float h2 = heights[x][y+1] * scaleFactor;
      float u = float(x)/cols;
      float v1 = float(y)/rows;
      float v2 = float(y+1)/rows;
      //if (heights[x][y] < -10) blurred.get(x,y);
      //  else img.get(x,y);

      //float d = map(heights[x][y], -50, 50, 0, 1);
      //color cNear = img.get(x, y);
      //color cFar = blurred.get(x, y);
      //color mixed = lerpColor(cFar, cNear, pow(d, 1.5));

      fill(img.get(x, y));
      //fill(mixed);
      vertex(x, y, h1, u, v1);
      fill(img.get(x, y+1));
      //fill(mixed);
      vertex(x, y+1, h2, u, v2);
    }
    endShape();
  }
}
