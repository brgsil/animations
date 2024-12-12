int[][] result;
float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0)
    return 0;
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else if (p <=1.0)
    return 1 - 0.5 * pow(2*(1 - p), g);
  else 
    return 1.0;
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
        println(t);
      draw_();
    }
}

//////////////////////////////////////////////////////////////////////
 
int samplesPerFrame = 4;
int numFrames = 360;        
float shutterAngle = 0.1;
 
boolean recording = true, preview = true;


OpenSimplexNoise noise;

int M = 100;
Artifact[] a = new Artifact[M];
 
void setup(){
  size(600,600, P3D);
  result = new int[width*height][3];
  
  noise = new OpenSimplexNoise(42);
  
  for(int i=0;i<a.length;i++){
    a[i] = new Artifact(1.0*i);
  }
}

void draw_(){
  push();
  background(0);
  float[][] vals = new float[width][height];
    for(int i=0; i<vals.length; i++){
     for(int j=0; j<vals[i].length; j++){
       vals[i][j] = 0.0;
     } 
    }
  
  for(int i=0;i<a.length;i++){
    a[i].show(vals);
  }
  showBorders(vals);
  pop();
}

class Artifact{  
  float n;
  float c = 20;
  float delay = constrain(randomGaussian() * 0.1+0.15,0,0.3);
  float pause = 0.2;
  public Artifact(float n_){
    n=n_;
    delay += 0.6;//(1-sqrt(n+1) / sqrt(M)) * 0.5;
  }
  
  
  void show(float[][] val){
    //float dn = constrain(ease(2*t,2)*TWO_PI,0,TWO_PI);
   
    float phi = (n+1) * 137.5 * PI / 180.0;
    float r = c*sqrt(n+1);
    float dx = r*cos(phi) + width/2;
    float dy = r*sin(phi) + height/2;
    float maxPhi = M * 137.5;
    float maxR = c*sqrt(M);
    if (t < (1.5-pause/2)/3){
    float p = constrain(ease(map(t,0,(1.5-pause/2)/3,0,1),2),0,1);
    
    float dPhi = constrain(p*TWO_PI,0,phi%TWO_PI);
    float dR = dPhi >= phi%TWO_PI ? constrain(map(r*map(p,(phi%TWO_PI)/TWO_PI,1,0,1),0,r,(phi%TWO_PI)/TWO_PI*maxR/1.4,r),0,maxR) : dPhi*maxR/1.4/TWO_PI;
    //p=(phi%TP)/TP -> (phi%TP)/TP*maxR
    dx = dR*cos(dPhi) + width/2;
    dy = dR*sin(dPhi) + height/2;
    } else if (t > (1.5+pause/2)/3){
     float p = constrain(ease(map(t,(1.5+pause/2)/3,1,0,1))*1/(1-delay)-(r/maxR)*delay,0,1);
     float dr = r*(1-p);
     dx = dr*cos(phi)+width/2;
     dy = dr*sin(phi)+height/2;
    }
    stroke(255);
    strokeWeight(3);
    point(dx,dy);
    for(int i=0; i<val.length; i++){
     for(int j=0; j<val[i].length; j++){
       val[i][j] += 1-ease(dist(i,j,dx,dy)/10.0,2);
     }   
    }
  }
  
}


void showBorders(float[][] val){
  float cDist = 5.5;
  stroke(255);
    strokeWeight(1);
    for(int i=0; i<val.length; i++){
     for(int j=0; j<val[i].length; j++){
       if(1.0/pow((cDist),2) <= val[i][j] )
         val[i][j] = 1.0;
     } 
    }
    float[][] dval = new float[width][height];
    for(int i=0; i<dval.length; i++){
     for(int j=0; j<dval[i].length; j++){
         dval[i][j] = val[i][j]*8.0 -
                     (i+1 < width ? val[i+1][j] : 0) -
                     (i-1 >= 0 ? val[i-1][j] : 0) -
                     (j+1 < height ? val[i][j+1] : 0) -
                     (j-1 >= 0 ? val[i][j-1] : 0) -
                     
                     (i+1 < width ? (j+1 < height ? val[i+1][j+1] : 0) : 0) -
                     (i-1 >= 0 ? (j+1 < height ? val[i-1][j+1] : 0) : 0) -
                     (i+1 < width ? (j-1 >= 0 ? val[i+1][j-1] : 0) : 0) -
                     (i-1 >= 0 ? (j-1 >= 0 ? val[i-1][j-1] : 0) : 0);
     } 
    }
    
    for(int i=0; i<dval.length; i++){
     for(int j=0; j<dval[i].length; j++){
       if(dval[i][j] > 0 )
         point(i,j);
     } 
    }
}
