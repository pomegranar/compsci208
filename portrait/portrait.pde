PImage img, mask;
PFont f;
String lyrics = " No one tried To read my eyes" +
" No one but you"+
" Wish it weren't true"+
" Maybe I (I'd kinda like it if you'd call me)"+
" It's not right ('Cause I'm so over bein' lonely)"+
" Make you mine (I need a virtual connection)"+
" Take our time (You'll be my video obsession)"+
" Come on, don't leave me, it can't be that easy, babe If you believe me, I guess l'll get on a plane Fly to your city excited to see your face"+
" Hold me, console me, and then l'll leave without a trace"+
" Come on, don't leave me, it can't be that easy, babe If you believe me, I guess I'll get on a plane Fly to your city excited to see your face Hold me, console me, then l'll leave without a trace"+
" Come on, don't leave me, it can't be that easy, babe If you believe me, I guess l'll get on a plane Fly to your city excited to see your face"+
" Hold me, console me, and then l'll leave without a trace"+
" Maybe I (Come on, don't leave me, it can't be that easy, babe)"+
" It's not right (If you believe me, I guess I'll get on a plane)"+
" Make you mine (Fly to your city excited to see your face)"+
" Take our time (Hold me, console me and then 'll leave without a trace)"+
" I'd kinda like it if you'd call me (It's not right)"+
" 'Cause I'm so over bein' lonely (Make you mine)"+
" I need a virtual connection (Take our time)"+
" You'll be my video obsession";

void setup(){
  size(600,600);
  img = loadImage("marias.png");
  mask = loadImage("marias-depth.png");
  img.mask(mask);
  imageMode(CENTER);
  f = createFont("DMMono-Medium.ttf", 14);
  textFont(f);
}

void draw(){
  background(map(mouseX,0,width,0,255));
  textAlign(RIGHT);
  blendMode(BLEND);
  fill(255);
  text(lyrics, 0, 0);
  image(img,width/2,height/2);
  blendMode(LIGHTEST);
  image(img,width/2,height/2);
}
