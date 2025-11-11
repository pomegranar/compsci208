PImage img, depth;
float strength = 1;

void setup() {
  size(800, 534);
  img = loadImage("img.png");
  depth = loadImage("depth.png");

  img.resize(width, height);
  depth.resize(width, height);
}

void draw() {
  background(0);
  
  img.loadPixels();
  depth.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    color d = depth.pixels[i];

    // 0 = red (near), 1 = blue (far)
    float depthFactor = (blue(d) - red(d) + 255) / mouseX;


    //float curved = log(1 + depthFactor * 9) / log(10); // maps 0→0, 1→1 but nonlinearly
    float curved = pow(depthFactor, 9); 
    float darkness = curved * strength;

    float r = red(c) * (1 - darkness);
    float g = green(c) * (1 - darkness);
    float b = blue(c) * (1 - darkness);

    img.pixels[i] = color(r, g, b);
  }

  img.updatePixels();
  image(img, 0, 0);
}
