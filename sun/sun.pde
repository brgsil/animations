int[][] result;
float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else if(p < 1.0)
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
        println(c);
      draw_();
    }
}

//////////////////////////////////////////////////////////////////////
 
int samplesPerFrame = 3;
int numFrames = 240;        
float shutterAngle = 0.2;
 
boolean recording = true, preview = true;


OpenSimplexNoise noise;

Artifact[] a = new Artifact[50000];

float[] zAng = new float[]{random(-PI,PI), random(-PI,PI), random(-PI,PI)};
float[] yAng = new float[]{random(-PI,PI), random(-PI,PI), random(-PI,PI)};
 
void setup(){
  size(600,600, P3D);
  result = new int[width*height][3];
  
  noise = new OpenSimplexNoise(millis());
  
  for(int i=0;i<a.length;i++){
    a[i] = new Artifact();
  }
    println("START");
}

void draw_(){
  push();
  background(0);
  translate(width/2, height/2);
  rotateX(0.8);
  //rotateY(TWO_PI*t);
  //rotateZ(TWO_PI*t);
  int easeG = 3;
  if(t<1.0/4)
    rotateY(yAng[0]*ease(4*t,easeG));
   else if (t<2.0/4)
    rotateY(yAng[0] + (yAng[1])*(ease(4*t-1,easeG)));
   else if (t<3.0/4)
    rotateY(yAng[0] + yAng[1] + (yAng[2])*(ease(4*t-2,easeG)));
   else
    rotateY((yAng[0] +yAng[1] + yAng[2])%TWO_PI - ((yAng[0] +yAng[1] + yAng[2])%TWO_PI)*(ease(4*t-3,easeG)));
  if(t<1.0/4)
    rotateZ(zAng[0]*ease(4*t,easeG));
   else if (t<2.0/4)
    rotateZ(zAng[0] + (zAng[1])*(ease(4*t-1,easeG)));
   else if (t<3.0/4)
    rotateZ(zAng[0] + zAng[1] + (zAng[2])*(ease(4*t-2,easeG)));
   else
    rotateZ((zAng[0] + zAng[1] + zAng[2])%TWO_PI - ((zAng[0] + zAng[1] + zAng[2])%TWO_PI)*(ease(4*t-3,easeG)));
  stroke(0);
  fill(0);
  sphere(199);
  for(int i=0;i<a.length;i++){
    a[i].show();
  }
  pop();
}

class Artifact{
  ArrayList<ArrayList<PVector>> paths = new ArrayList<>();
  float r = 200;
  float noiseR = 0.05;
  float loopNoiseR = 0.25;
  float pr = 0.02;
  int replicas = 60;
  
  float phiI = random(0,TWO_PI);
  float thetaI = acos(1-2*random(1));
  int flowLoop = 3;
  
  int steps = 300;
  public Artifact(){
    /*for(int i=0; i<steps; i++){
      ArrayList<PVector> path = new ArrayList<>();
      float phi = phiI;
      float theta = thetaI;
      for(int j=0; j<steps; j++){
        path.add(new PVector(theta,phi));
        float x = r*sin(theta)*cos(phi);
        float y = r*sin(theta)*sin(phi);
        float z = r*cos(theta);
        phi += noiseR*noise.eval(pr*x+loopNoiseR*cos(TWO_PI*i/steps),pr*y+loopNoiseR*sin(TWO_PI*i/steps),pr*z);
        theta += noiseR*noise.eval(100+pr*x+loopNoiseR*cos(TWO_PI*i/steps),pr*y+loopNoiseR*sin(TWO_PI*i/steps),pr*z);
      }
      paths.add(path);
    }*/
  }
  
  void show(){
    float prog = flowLoop*t*(steps-1);
    int idx = floor(prog);
    ArrayList<PVector> path = new ArrayList<>();
      float phi = phiI;
      float theta = thetaI;
      for(int j=0; j<steps; j++){
        path.add(new PVector(theta,phi));
        float x = r*sin(theta)*cos(phi);
        float y = r*sin(theta)*sin(phi);
        float z = r*cos(theta);
        phi += noiseR*noise.eval(pr*x+loopNoiseR*cos(TWO_PI*t),pr*y+loopNoiseR*sin(TWO_PI*t),pr*z);
        theta += noiseR*noise.eval(100+pr*x+loopNoiseR*cos(TWO_PI*t),pr*y+loopNoiseR*sin(TWO_PI*t),pr*z);
      }
    for(int k=0; k<replicas; k++){
      int ver = (idx+k*(steps-1)/replicas)%(steps-1);
      PVector pos = path.get(ver);
      PVector next = path.get(ver+1);
      float th = lerp(pos.x, next.x, prog-idx);
      float ph = lerp(pos.y,next.y, prog-idx);//+TWO_PI*t)%TWO_PI;
      float x = r*sin(th)*cos(ph);
      float y = r*sin(th)*sin(ph);
      float z = r*cos(th);
      
      stroke(255, 150*ease(min(1.0,ver/(0.15*steps)),2));
      strokeWeight(1);
      point(x,y,z);
    }
  }
}
