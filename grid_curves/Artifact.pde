class Artifact{

  float x,y;
  
  float scale = 0.2;
  float pr = 0.02;
  float noiseR = 1;
  int points = 100;
  
  public Artifact(float x_, float y_){
    this.x = x_;
    this.y = y_;
  }
  
  void show(float t){
    push();
    noFill();
    stroke(255,60);
    strokeWeight(1);
    //translate(x,y);
    float[][] controls = new float[points][2];
    float dx =pr*x, dy=pr*y;
    for (int i=0; i<points; i++){
      //push();
      float p = 1.0*i/points;
      float offset = p;//pow(p,3.0);
      dx = dx + 0.05*noise.eval(noiseR*cos(TWO_PI*(t)),noiseR*sin(TWO_PI*(t)),dx,dy);
      dy = dy + 0.05*noise.eval(100+noiseR*cos(TWO_PI*(t)),noiseR*sin(TWO_PI*(t)),dx,dy);
      //rotate(dx*0.05);
      //translate(scale*map(dy,-1,1,0,2),0);
      //translate(dx,dy);
      point(dx/pr*1.1,dy/pr*1.1);
    }
    pop();
  }
  
}
