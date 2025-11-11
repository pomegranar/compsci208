PImage img, depth, alphaMap;

void setup() {
  size(800, 534);
  img = loadImage("img.png");
  depth = loadImage("depth.png");
  alphaMap = createImage(img.width, img.height, ALPHA);

  depth.loadPixels();
  alphaMap.loadPixels();

  for (int i = 0; i < depth.pixels.length; i++) {
    color c = depth.pixels[i];

    //float val = brightness(c);

     float val = hue(c);

    alphaMap.pixels[i] = color(0, 0, 0, val);
  }

  alphaMap.updatePixels();
}

void draw() {
  background(0);

  tint(255, 255);
  image(img, 0, 0);

  tint(400, 128); 
  image(alphaMap, 0, 0);
}
