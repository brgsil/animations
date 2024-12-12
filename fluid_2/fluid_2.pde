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

float easeInOut(float p, float g){
  while (p > 1.0)
    p -= 1;
  while (p < 0)
    p += 1;
  if (p < 0.5) 
    return ease(p*2,g);
  else
    return ease(2*(1-p),g);
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
 
boolean recording = false, preview = true;


OpenSimplexNoise noise;

//Particle[] a = new Particle[2500];
Fluid f;
 
void setup(){
  size(600,600, P3D);
  result = new int[width*height][3];
  
  noise = new OpenSimplexNoise();
  
  f = new Fluid();
  
  //for(int i=0;i<a.length;i++){
    //a[i] = new Particle();
  //}
}

void draw_(){
  push();
  background(0);
  translate(width/2, height*0.7,-20);
  rotateX(1.2);
  rotateZ(TWO_PI*t);
  stroke(255,0,0);
  line(0,0,0,200,0,0);
  stroke(0,255,0);
  line(0,0,0,0,200,0);
  stroke(0,0,255);
  line(0,0,0,0,0,200);
  stroke(255,70);
  f.show();
  pop();
}
