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
 
boolean recording = true, preview = false;


OpenSimplexNoise noise;
 
void setup(){
  size(600,600, P3D);
  result = new int[width*height][3];
  
  noise = new OpenSimplexNoise(42);
}
int m = 50000;
float rad = 4;
float nperiod = 4.0;
void draw_(){
  push();
  background(0);
  for(int i=0;i<m;i++){
    float p = 1.0*i/m;
    float dx = 400*(float)noise.eval(rad*cos(TWO_PI*(nperiod*p-t)),rad*sin(TWO_PI*(nperiod*p-t)));
    float dy = 400*(float)noise.eval(100 + rad*cos(TWO_PI*(nperiod*p-t)),rad*sin(TWO_PI*(nperiod*p-t)));
 
    //if (abs(dy) < 40)
    float scale = 1/(1-nperiod*p/2);
    dx /= scale;
    dy /= scale;
    stroke(255,max(0,(1-p*nperiod)*255));
      point(width/2 + dx,height/2 + dy);
  }
  pop();
}
