int gridSize = 80;
float diameter;

void setup(){
  size(400,800);
  // fullScreen();
  noiseSeed((long)random(9,424));
  colorMode(RGB, 255, 255, 255, 255);
  // noFill();
  frameRate(60);
  background(0);
}

void draw(){  
  blendMode(MULTIPLY);
  fill(0,0,0,20);
  rect(0,0,width,height);
  blendMode(ADD);
  // for (int i=-20; i<width+40; i=i+int(map(noise(1),0,1,30,50))){
  //   for (int j=0; j<height+40; j=j+int(map(noise(i),0,1,30,50))){
  for (int i=0; i<width+gridSize; i=i+gridSize){
    for (int j=0; j<height+gridSize; j=j+gridSize){
      diameter = 100*sin(noise(i,j,frameCount * 0.01)*TWO_PI);
      fill(color(0,0,0,80));
      stroke(color(map(i,0,height,0,255),map(j,0,width,0,255),map(diameter,-100,100,0,255),50));
      circle(i,j,diameter+(mouseX+mouseY)/4);
    }
  }
}
