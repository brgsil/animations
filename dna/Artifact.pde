class Artifact{
  float seed = random(10,1000);
  float startOffset = 7*PI;//random(TWO_PI);
  float alpha = 100;//random(80,100);
  float stroke = random(0.8,1.8);
  float totalPeriod = 6.0;//0.1+0.5*pow(random(1),2.0);
  float scaleH = 1.0;//random(0.5,1.15);
  float scaleN = random(5,200); 
  
  float starWaveDelay = 0.6;
  int side;
  
  int m = 600;
  float noiseR = 1.3;
  int nPeriod = 2;
  
  public Artifact(int side_){ this.side = side_; }
    
  void show(OpenSimplexNoise noise, float t){
    //strokeWeight(stroke);
    for(int i=0; i<m;i++){
      float p = 1.0*i/m;
      float theta = startOffset + totalPeriod*TWO_PI*p-t*TWO_PI;
      
      float x = scaleH*xh(theta)*lerp(1,xh(TWO_PI),t);// + pow(1-p,2)*scaleN*noise.eval(seed + noiseR*cos(TWO_PI*(nPeriod*p-t)), noiseR*sin(TWO_PI*(nPeriod*p-t)));
      float y = scaleH*yh(theta)*lerp(1,xh(TWO_PI),t);// + pow(1-p,2)*scaleN*noise.eval(2*seed+noiseR*cos(TWO_PI*(nPeriod*p-t)), noiseR*sin(TWO_PI*(nPeriod*p-t)));
      
      float nx = max(0,pow(-p+(starWaveDelay),1)/pow(starWaveDelay,1))*scaleN*noise.eval(seed + noiseR*cos(TWO_PI*(nPeriod*p-t)), noiseR*sin(TWO_PI*(nPeriod*p-t)));
      float ny = max(0,pow(-p+(starWaveDelay),1)/pow(starWaveDelay,1))*scaleN*noise.eval(2*seed + noiseR*cos(TWO_PI*(nPeriod*p-t)), noiseR*sin(TWO_PI*(nPeriod*p-t)));
      
      float waveScale = (1+max(0,pow(p-starWaveDelay,1)/pow(1-starWaveDelay,1))*sin(-10*theta+side*PI)/2);
      float dx = waveScale*x + nx;
      float dy = waveScale*y + ny;
      
      strokeWeight(1+pow(p,2)*20);
      stroke(255, alpha*p+cos(10*theta+side*PI)*40);
      point(dx,dy);
      if(p>starWaveDelay){
      strokeWeight(1);
      line(x,y,dx,dy);
      }
    } 
  }
  
  
  float b = 0.28;
  float xh(float p){
    return pow(1.5,b*p)*cos(p);
  }
  
  
  float yh(float p){
    return pow(1.5,b*p)*sin(p);
  }
}
