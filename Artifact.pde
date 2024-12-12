class Artifact{
  
  int slot = floor(random(15));
  float px = random(1);
  float py = random(1);
  
  float size = random(1,4);
  
  static float amp = 0.3;
  static float noiseR = 1.0;
  static float pr = 0.25;

  public Artifact(){
  }

  void show(float[] noises){
    stroke(255);
    
    float dpy = noises[slot];
    
    float x = (slot+px)*width/15;
    float y = (1-py*(1+dpy))*height/2 ;
    
    strokeWeight(size);
    point(x,y);
  }
  
  static float[] noises(OpenSimplexNoise noise, float t){
    float[] noises = new float[15];
    for (int i=0; i<15; i++)
      noises[i] = amp*noise.eval(noiseR*cos(TWO_PI*t), noiseR*sin(TWO_PI*t),i*pr);
    
    return noises;
  }

}
