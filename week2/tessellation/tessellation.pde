float side, radius; 

void setup(){
  size(1920,180);
  background(0);
  smooth();
  pixelDensity(1);
  noStroke();
  side = 90.0;
  radius = side/2;
  colorMode(HSB, 360, 100, 100);
  noiseSeed((long)random(543));
}
void draw(){
  blendMode(MULTIPLY);
  fill(0,55);
  rect(0,0,width,height);
  // ENABLE TO SEE THE TESSELLATION MORE CLEARLY
  // outline();
  blendMode(ADD); 
  for (float x=0;x<width+side;x=x+1*side){
    for (float y=0;y<height+side;y=y+1*side*0.866) {
      hexagon(x,y,side);
    }
  }

}


void hexagon(float x,float y,float side){
  fill(map(noise(x+y),0,1,0,360),map(noise(x-y+frameCount*0.01),0,1,0,100),map(sin(noise(x+y+frameCount*0.01)),0,1,0,80),50);
  beginShape();
  vertex(x-side,y);
  vertex(x-radius-radius*0.9659,y-radius*0.2588);
  vertex(x-radius-radius*0.866,y-radius*0.5);
  vertex(x-radius-radius*0.7071,y-radius*0.7071);
  vertex(x-radius-radius*0.5,y-radius*0.866); 

  vertex(x-side+radius*0.7071,y-side*sin(radians(60))+radius*0.7071);
  vertex(x-side+radius*0.866,y-side*sin(radians(60))+radius*0.5);
  vertex(x-side+radius*0.9659,y-side*sin(radians(60))+radius*0.2588);

  vertex(x-radius,y-side*sin(radians(60)));
  vertex(x+radius,y-side*sin(radians(60)));

  vertex(x+side-radius*0.9659,y-side*sin(radians(60))+radius*0.2588);
  vertex(x+side-radius*0.866,y-side*sin(radians(60))+radius*0.5);
  vertex(x+side-radius*0.7071,y-side*sin(radians(60))+radius*0.7071);

  vertex(x+radius+radius*0.5,y-radius*0.866);
  vertex(x+radius+radius*0.7071,y-radius*0.7071);
  vertex(x+radius+radius*0.866,y-radius*0.5);
  vertex(x+radius+radius*0.9659,y-radius*0.2588);

  vertex(x+side,y);
  vertex(x+radius,y+side*sin(radians(60)));
  vertex(x-radius,y+side*sin(radians(60)));
  endShape();
}

void outline(){
  for (float x=0;x<width+side;x=x+1*side){
    for (float y=0;y<height+side;y=y+1*side*0.866) {
      stroke(0,50);
      strokeWeight(2);
      line(x,y,x+radius,y+side*0.866);
      line(x+radius,y+side*0.866,x+side,y);
      line(x,y,x+side,y);
      noStroke();
    }
  }
}


void keyPressed() {
  switch(key){
    case ' ':
      noiseSeed((long)random(543));
      break;
  }
}
