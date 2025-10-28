void setup(){
  size(400,400);
  // fullScreen();
  noiseSeed((long)random(9,424));
  colorMode(RGB, 255, 255, 255, 255);
  // noFill();
  frameRate(30);
}

void draw(){  
  blendMode(BLEND);
  fill(0,0,0,230);
  rect(0,0,width,height);
  blendMode(ADD);
  // for (int i=-20; i<width+40; i=i+int(map(noise(1),0,1,30,50))){
  //   for (int j=0; j<height+40; j=j+int(map(noise(i),0,1,30,50))){
  for (int i=0; i<width+40; i=i+40){
    for (int j=0; j<height+40; j=j+40){
      fill(0,0,0,20);
      stroke(color(255,255,255,50));
      circle(i,j,200*sin(map(noise(i,j,frameCount * 0.01),0,1,0,TWO_PI)/2));
    }
  }
}
