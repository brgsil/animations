int[][] result;
float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p <0.5)
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float easeQuadCub(float x){
  float wo=1.8;
  return pow(x,1/x)*(1-pow(1-x,5)) + (1-x)*pow(x,2);
  //return pow(p,2);
  /*
  if (p < 0.634) 
    return 0.5 * pow(2*p, 2);
  else
    return 1 - 0.5 * pow(2*(1 - p), 3);*/
}

float easeInOut(float p, float g){
  while(p>1)
    p -= 1;
  while (p<0)
    p+=1;
 if (p<0.5)
 return ease(map(p,0,0.5,0,1),g);
 else
 return 1- ease(map(p,0.5,1,0,1),g);
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
 
boolean recording = true, preview = true;


OpenSimplexNoise noise;

Particle[] a = new Particle[150];
 
void setup(){
  size(600,600, P3D);
  result = new int[width*height][3];
  
  noise = new OpenSimplexNoise(42);
  
  for(int i=0;i<a.length;i++){
    a[i] = new Particle();
  }
  PVector v = new PVector(10.0, -10.0);
  println(v.heading()/PI);
  println(sin(-PI/2));
}

void draw_(){
  push();
  background(0);
  translate(width/2, height/2);
  rotateX(PI);
  noFill();
  strokeWeight(2);
  stroke(255,100,0);
  circle(0,0,120);
  for(int i=0;i<a.length;i++){
    a[i].show(t);
  }
  pop();
}
