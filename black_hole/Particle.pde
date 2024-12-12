float easeInBack(float p){
  return 3*pow(p,3) - 2*pow(p,2);
}

class Particle{
  
  float r = random(80, 120);
  float ellR = r+lerp(0,120,(r-80)/(120-80));
  int steps = 1000;
  float mass = random(0.8,3);
  
  float angD = 0.4;
  float aD = random(1);
  
  float low = HALF_PI, high = TWO_PI;
  
  ArrayList<PVector> path = new ArrayList<>();
  
  public Particle(){
    println(aD);
    PVector pos = PVector.random2D();
    pos.setMag(r);
    //path.add(pos.copy());
    for (int s=0;s<steps;s++){
      float ang = pos.heading();
      
      if (angD < ang && ang < PI-angD){
        pos.rotate(high/steps);
      } else if (ang < 0 || ang > PI){
          pos.rotate(low/steps);
      } else {
        if (ang < angD)
          pos.rotate(lerp(low,high,easeQuadCub(ang/angD))/steps);
         else
          pos.rotate(lerp(high,low,easeQuadCub((ang-PI+angD)/angD))/steps);        
      }
      ang = pos.heading();
      if (angD < ang && ang < PI-angD){
        pos.setMag(r);
      path.add(pos.copy());
      } else if (ang < 0 || ang > PI){
          PVector ePos = pos.copy().set(ellR*cos(ang),(ellR/8)*sin(ang));
          path.add(ePos.copy());
      } else {
        if (ang < angD)
          pos.setMag((lerp(ellR,r,easeQuadCub(ang/angD))));
         else
          pos.setMag((lerp(r,ellR,easeQuadCub((ang-PI+angD)/angD))));
      path.add(pos.copy());
      }
        
    }
    
  }
 
  void show(float p){
    stroke(255,50);
    noFill();
    //circle(0,0,2*r);
    //ellipse(0,0,2*ellR,2*r/3);
    for(int i=0; i<steps; i++){
      float k = ((1.0*i/steps - p)%1+1)%1;
    float floatIndex = (steps-1)*k;
    int index1 = floor(floatIndex);
    int index2 = index1+1;
    float lerpParameter = floatIndex-index1;
    PVector position1 = path.get(index1);
    PVector position2 = path.get(index2);
    PVector lerpedPosition = position1.copy().lerp(position2,lerpParameter);
    
    push();
    translate(lerpedPosition.x,lerpedPosition.y);
    
    stroke(255,100,0,easeInOut(-3.0*i/steps+aD,2)*100);
    strokeWeight(mass);
    point(0,0);
    pop();
    }
  }
}
