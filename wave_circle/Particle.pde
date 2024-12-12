class Particle{
  float px;
  float py;
  
  float maxR = 500.0;
  float extra = 80;
  float noiseR = 0.95;
  float amplitude = 400;
  float proximity = 0.006;
  
  public Particle(){
    do{
      px = random(2*maxR) - maxR;
      py = random(2*maxR) - maxR;
    } while (mag(px,py) > (maxR+extra));
  }
  
  void show(float p){    
    float[] displacement = computeDisplacement(p);
    /*if (mag(displacement[0],displacement[1]) > maxR){
      float scale = mag(displacement[0],displacement[1]) / maxR;
      displacement[0] /= scale;
      displacement[1] /= scale;
    } */
    float[] prev = computeDisplacement(p-0.01);
    /*if (mag(prev[0],prev[1]) > maxR){
      float scale = mag(prev[0],prev[1]) / maxR;
      prev[0] /= scale;
      prev[1] /= scale;
    }*/
    float vel = mag(displacement[0]-prev[0],displacement[1]-prev[1]);
    stroke(250 * min(1, map(vel,0,20,0,1)));
    strokeWeight(1.2);
    point(displacement[0],displacement[1]);
  }
 
 float[] computeDisplacement(float p){
   float ang = TWO_PI*p;
    float nX = noise.eval(noiseR*sin(ang),noiseR*cos(ang),proximity*px,proximity*py);
    float nY = noise.eval(100+noiseR*sin(ang),noiseR*cos(ang),proximity*px,proximity*py);
    float smoothing = max(0,ease(1-mag(px,py)/(maxR),1.2));
    
    return new float[]{px + amplitude*nX*smoothing, py + amplitude*nY*smoothing};
 }
 
}
