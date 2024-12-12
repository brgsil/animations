class Artifact{
  float seed = random(10,1000);
  float startOffset = random(TWO_PI);
  float alpha = random(9,45);
  float stroke = random(0.8,1.8);
  float totalPeriod = 0.1+0.5*pow(random(1),2.0);
  float scaleH = random(0.5,1.15);
  float scaleN = random(10,120); 
  
  int m = 800;
  float noiseR = 1.3;
  int nPeriod = 2;
    
  void show(OpenSimplexNoise noise, float t){
    strokeWeight(stroke);
    for(int i=0; i<m;i++){
      float p = 1.0*i/m;
      float theta = startOffset + totalPeriod*TWO_PI*p;
      
      float x = scaleH*xh(theta) + pow(p,3)*scaleN*noise.eval(seed + noiseR*cos(TWO_PI*(nPeriod*p-t)), noiseR*sin(TWO_PI*(nPeriod*p-t)));
      float y = scaleH*yh(theta) +  pow(p,3)*scaleN*noise.eval(2*seed + noiseR*cos(TWO_PI*(nPeriod*p-t)), noiseR*sin(TWO_PI*(nPeriod*p-t)));
      
      stroke(255, alpha*sin(PI*p));
      point(x,y);
    } 
  }
}
