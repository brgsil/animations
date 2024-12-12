class Artifact{
 float cx;
 float cy;
 float r = 5;
 
 boolean growing = true;
 float maxEdge = 300;
 
 float nR = 0.8;
 float amplitude = 2;
 
 int segments = 25;
 int max = 300;
 int maxR = 80;
 
 int seed;
 
 int nPeriod = floor(random(1,5));
 
 public Artifact(){
  seed = floor(random(100000));
  cx = random(2*max) - max;
  cy = random(2*max) - max;
  while(mag(cx,cy) > (maxEdge-10)){
    cx = random(2*max) - max;
    cy = random(2*max) - max;
  }
 }
 
 public Artifact(Artifact[] others){
  seed = floor(random(1000));
  cx = random(2*max) - max;
  cy = random(2*max) - max;
  boolean overlap = true;
  while(mag(cx,cy) > (maxEdge-20) || overlap){
    overlap = false;
    cx = random(2*max) - max;
    cy = random(2*max) - max;
    for (int i =0; i<others.length; i++){
      if (others[i]!=null)
        overlap = overlap || hasOverlap(others[i]);
    }
  }
 }
 
 void show(OpenSimplexNoise noise, float p){
   push();
   noFill();
   stroke(255);
   translate(width/2 + cx, height/2 + cy);
   //circle(0,0,2*r);
   for (int i=0; i < segments; i++){
     rotate(TWO_PI/segments);
     float dx1 = amplitude*noise.eval(seed+nR*sin(nPeriod*p*TWO_PI),nR*cos(nPeriod*p*TWO_PI),sin(i*TWO_PI/segments),cos(i*TWO_PI/segments));
     float dy1 = amplitude*noise.eval(seed+50+nR*sin(nPeriod*p*TWO_PI),nR*cos(nPeriod*p*TWO_PI),sin(i*TWO_PI/segments),cos(i*TWO_PI/segments));
     float dx2 = amplitude*noise.eval(seed+100+nR*sin(nPeriod*p*TWO_PI),nR*cos(nPeriod*p*TWO_PI),sin(i*TWO_PI/segments),cos(i*TWO_PI/segments));
     float dy2 = amplitude*noise.eval(seed+150+nR*sin(nPeriod*p*TWO_PI),nR*cos(nPeriod*p*TWO_PI),sin(i*TWO_PI/segments),cos(i*TWO_PI/segments));
     float dx3 = amplitude*noise.eval(seed+200+nR*sin(nPeriod*p*TWO_PI),nR*cos(nPeriod*p*TWO_PI),sin(i*TWO_PI/segments),cos(i*TWO_PI/segments));
     float dy3 = amplitude/10*noise.eval(seed+250+nR*sin(nPeriod*p*TWO_PI),nR*cos(nPeriod*p*TWO_PI),sin(i*TWO_PI/segments),cos(i*TWO_PI/segments));
     bezier(0,0,dx1 ,r/3 + dy1,dx2,2*r/3+dy2,dx3,r+dy3);
    }
    pop();
 }
 
 boolean hasOverlap(Artifact other){
   return mag(this.cx-other.cx, this.cy-other.cy) < (this.r + other.r +5); 
 }
 
 boolean hitEdge(){
  return (r + mag(cx,cy)) > maxEdge;
 }
 
 boolean grow(Artifact[] others){
   boolean canGrow = true;
   for (int i=0; i<others.length; i++){
     if (others[i] != null && others[i] != this){
      canGrow = canGrow && !this.hasOverlap(others[i]); 
     }
   }
   if (canGrow && !hitEdge() && this.r <= maxR){
     this.r += 1;
     this.amplitude = 0.8*this.r;
     this.segments = max(segments, ceil(pow(r / 5,1.3)));
     return true;
   }else{
     return false;
   }  
 }
 
}
