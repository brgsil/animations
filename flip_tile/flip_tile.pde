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

float easeOutBounce(float x) {
  float n1 = 7.5625;
  float d1 = 2.75;
  if (x < 1 / d1) {
      return n1 * x * x;
  } else if (x < 2 / d1) {
      return 0.6*(n1 * (x -= 1.5 / d1) * x + 0.75)+0.4;
  } else if (x < 2.5 / d1) {
      return n1 * (x -= 2.25 / d1) * x + 0.9375;
  } else {
      return n1 * (x -= 2.625 / d1) * x + 0.984375;
  }
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
int nx = 15, ny = 2;
Artifact[][] a = new Artifact[nx][ny];
Particle[] b = new Particle[200];
 
void setup(){
  size(600,600, P3D);
  result = new int[width*height][3];
  
  noise = new OpenSimplexNoise(42);
  
  for(int i=0;i<a.length;i++){
  for(int j=0;j<a[i].length;j++){
    a[i][j] = new Artifact(i,j);
  }
  }
  
  for(int j=0;j<b.length;j++){
    b[j] = new Particle();
  }
}

void draw_(){
  push();
  background(0);
  for(int i=0;i<a.length;i++){
  for(int j=0;j<a[i].length;j++){
    a[i][j].show();
  }
  }
  pop();
}

class Particle{
 
  float size = constrain(randomGaussian()*3+1.2,0.8,4);
  float noiseA = 100.0;
  float noiseR = 1.0/size;
  int total = numFrames*samplesPerFrame;
  
  float x = random(width);
  float ySpan = 2*ny*width/nx;
  float y = random(ySpan)-width/nx;
  float seed = random(100,10000);
  ArrayList<float[]> path = new ArrayList<>();
  public Particle(){
    for(int k=0; k<total; k++){
      float p = 1.0*k/total;
      float dx = noiseA*noise.eval(seed, noiseR*cos(TWO_PI*p), noiseR*sin(TWO_PI*p));
      float dy = 0.2*noiseA*noise.eval(2*seed, noiseR*cos(TWO_PI*p), noiseR*sin(TWO_PI*p));
      float[] pos = new float[]{x+dx,y+dy};
      path.add(pos);
    }
  }
  
  boolean isShown(int i, int j){
    float tileSize = width/nx;
    float xmin = i*tileSize;
    float xmax = (i+1)*tileSize;
    float ymin = j*tileSize;
    float ymax = (j+1)*tileSize;
    
    int idx = floor(t*total);
    float[] pos = path.get(idx);
    
    return xmin < pos[0] && pos[0] <= xmax && ymin < pos[1] && pos[1] <= ymax;
  }
  
  void show(int k){
    push();
    int idx = floor(t*total);
    float[] pos = path.get(idx);
    fill(255);
    stroke(255);
    strokeWeight(1);
    circle(pos[0],pos[1]+ySpan*k+ySpan*t,size);
    pop();
  }
  
}

class Artifact{
 float size = width/nx;
 
 float delay;
 
 int ix, iy;
 
 public Artifact(int ix_, int iy_){
   ix = ix_;
   iy = iy_;
   delay = randomGaussian()*0.5 + 1.2*(1-sin(PI*ix/nx)) + 0.5;
 }
  
  void configCam(float p, float rp){
    translate(ix*size,(2*iy)*size);
    fill(0);
    translate(0,2*p*size*ny);
    stroke(255, 255*(1-rp));//, 255*(0.9-(p*size*ny+(2*iy+1)*size)/height));
  }
  
  void show(){
    for (int k=-2; k<4; k++){
      float p = t+k;
      float rp = constrain(p+1.0*iy/ny-delay,0,1);
      float rot = PI+PI*easeOutBounce(ease(rp,1.5));
      
      push();
      configCam(p,rp);
      square(0,0,size);
      pop();
      //stroke(255);
      //strokeWeight(2);
      //point(size/2.0,size/2.0,-1);
      push();
      translate(0,0,-1);
      for (int i=0;i<b.length;i++){
       if(b[i].isShown(ix,2*iy-1))
         b[i].show(k);
      }
      pop();
      push();
      configCam(p,rp);
      rotateX(-rot);
      square(0,0,size);
      translate(-ix*size,-(2*iy)*size - 2*p*size*ny);
      translate(0,0,1);
      for (int i=0;i<b.length;i++){
       if(b[i].isShown(ix,2*iy))
         b[i].show(k);
      }
      pop();
    }
  }
}
