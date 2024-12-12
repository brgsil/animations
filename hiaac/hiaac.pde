int[][] result;
float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float mn = .5*sqrt(3), ia = atan(sqrt(.5));

void push_() {
  pushMatrix();
  pushStyle();
}

void pop_() {
  popStyle();
  popMatrix();
}

void draw() {

  if (recording || preview) {
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      t %= 1;
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = 0xff << 24 | 
        int(result[i][0]*1.0/samplesPerFrame) << 16 | 
        int(result[i][1]*1.0/samplesPerFrame) << 8 | 
        int(result[i][2]*1.0/samplesPerFrame);
    updatePixels();
  }
    
    if (recording){
      println(frameCount,"/",numFrames);
      saveFrame("out/fr-###.png");
      if (frameCount==numFrames)
        exit();
    } else if (!preview) {
      t = mouseX*1.0/width;
      c = mouseY*1.0/height;
      if (mousePressed)
        println(c);
      draw_();
    }
}

//////////////////////////////////////////////////////////////////////
 
int samplesPerFrame = 5;
int numFrames = 240;        
float shutterAngle = 0.5;
 
boolean recording = false, preview = false;


OpenSimplexNoise noise;


 
void setup(){
  size(800,800, P3D);
  result = new int[width*height][3];
  
  noise = new OpenSimplexNoise(42);
}

float W = 90*3;
float H = 160*3.5;

void draw_(){
  push();
  background(250);
  translate(width/2, height/2);
  rotateX(0.85);
  rotateZ(0.8);
 
  noStroke();
  fill(unhex("ff9100b9"));
  dRect(W, H, 30);
  push();
  fill(unhex("ff4c007e"));
  translate(0,10,1);
  dRect(W-20,H-40, 30);
  pop();
  push();
  fill(unhex("60ffffff"));
  translate(0,-10,2);
  dRect(W-40,W-40,0);
   pop();
  fill(0);
  drawSides();
  pop();
}

void dRect(float w,float h, float r){
  rect(-w/2.0,-h/2.0,w,h,r);
}

void drawSides(){
  beginShape(TRIANGLE_STRIP);
  vertex(-W/2.0,H/2.0-30,0);
  vertex(-W/2.0,H/2,0);
  vertex(W/2.0,H/2,0);
  vertex(W/2.0,H/2-30,0);
  vertex(W/2.0,H/2-30,-20);
  vertex(W/2.0,H/2,-20);
  vertex(-W/2.0,H/2,-20);
  vertex(-W/2.0,H/2.0-30,-20);
  endShape();
}
