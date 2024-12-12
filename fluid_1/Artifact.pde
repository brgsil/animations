float amp = 0.3;
float noiseR = 0.7;
float pr = 0.15;
int totalSlots = 15;
float seed = random(20,10000);

float[] noises(OpenSimplexNoise noise, float t){
  float[] noises = new float[totalSlots];
  for (int i=0; i<totalSlots; i++)
    noises[i] = amp*noise.eval(seed+noiseR*cos(TWO_PI*t), noiseR*sin(TWO_PI*t),i*pr);
  
  return noises;
}

class Artifact{
  
  int slot = floor(random(15));
  float px = random(1) -0.5;
  float py = random(1);
  float size = random(1,4);

  public Artifact(){
  }

  void show(float[] noises, OpenSimplexNoise noise){
    //stroke(255);
    float dpx = noise.eval(2*seed+noiseR*cos(TWO_PI*t),noiseR*sin(TWO_PI*t), 30*px,30*py);
    float dppy = 0.2*noise.eval(3*seed+noiseR*cos(TWO_PI*t),noiseR*sin(TWO_PI*t), 30*px,30*py);
    float ppx = px+dpx; 
    
    int cslot = ppx > 0.5 ? (slot < totalSlots-1 ? slot+1 : slot) : (ppx<-0.5 ? (slot > 0 ? slot-1 : slot) : slot);
    ppx = cslot>slot ? ppx - 1 : (cslot < slot ? 1 + ppx : ppx);
    
    float dpy;
    if (ppx >= 0){
      int next = cslot < totalSlots-1 ? cslot+1 : 0;
      dpy = lerp(noises[cslot],noises[next],ppx);
    } else {
      int prev = cslot > 0 ? cslot-1 : totalSlots-1;
      dpy = lerp(noises[prev],noises[slot],1+ppx);
    } 
    
    
    
    float x = (cslot+ppx+0.5)*width/totalSlots;
    float y = (1-(py+dppy)*(1+dpy))*height*0.5;
    noStroke();
    fill(255,5);
    for (int i=1; i<size*10; i+=1){
      circle(x,y,pow(i,1.25));
    }
    //strokeWeight(size);
    //point(x,y);
  }
}
