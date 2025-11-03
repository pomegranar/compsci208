float side, radius; 

void setup(){
  size(720,720);
  background(0);
  noStroke();
  side = 120.0;
  radius = side/2;
  colorMode(HSB, 360, 100, 100);
  noiseSeed((long)random(543));
}
void draw(){
  for (int x=0;x<width+2;x=x+int(1*side)){
    for (int y=0;y<height+2;y=y+int(1*side*sin(radians(60)))) {
      hexagon(x,y,side);
    }
  }
  blendMode(MULTIPLY);
  fill(0,50);
  rect(0,0,width,height);
  blendMode(ADD);
}


void hexagon(float x,float y,float side){
  fill(map(noise(x+y),0,1,0,360),map(noise(x-y+frameCount*0.01),0,1,0,100),map(sin(noise(x+y+frameCount*0.01)),0,1,0,80),40);
  beginShape();
  vertex(x-side,y);
  vertex(x-radius-radius*0.9659,y-radius*0.2588);
  vertex(x-radius-radius*0.866,y-radius*0.5);
  vertex(x-radius-radius*0.7071,y-radius*0.7071);
  vertex(x-radius-radius*0.5,y-radius*0.866); 

  // vertex(x-radius-radius*0.9659,y-radius*0.2588);
  // vertex(x-radius-radius*0.866,y-radius*0.5);
  // vertex(x-radius-radius*0.7071,y-radius*0.7071);
  // vertex(x-radius-radius*0.5,y-radius*0.866);
  //
  vertex(x-radius,y-side*sin(radians(60)));
  vertex(x+radius,y-side*sin(radians(60)));

  vertex(x+radius+radius*0.5,y-radius*0.866);
  vertex(x+radius+radius*0.7071,y-radius*0.7071);
  vertex(x+radius+radius*0.866,y-radius*0.5);
  vertex(x+radius+radius*0.9659,y-radius*0.2588);

  vertex(x+side,y);
  vertex(x+radius,y+side*sin(radians(60)));
  vertex(x-radius,y+side*sin(radians(60)));
  endShape();
}


void keyPressed() {
  switch(key){
    case ' ':
      noiseSeed((long)random(543));
      break;
  }
}
