int seed = 1;

void setup(){
  println(seed);
  size(540, 720, P3D);
  noFill();
  fill(14, 15, 16);
  noStroke();
}

void draw(){
  lights();
   fill(14, 15, 16);
 //border();
  camera(30.0, mouseY, 220.0, // eyeX, eyeY, eyeZ
         0.0, 0.0, 0.0, // centerX, centerY, centerZ
         0.0, 1.0, 0.0); 
  noStroke();
  box(90);
  stroke(255);
}

void border() {
  for (int side = 0; side < 4; side++) {
    box(side * 10);
  }
}
