float grav = 9.8;
int steps = 1000;

class Particle{  
  PVector cPos = new PVector(random(300)-150,
                             random(300)-150,
                             random(300));
  
  PVector vel = new PVector(0.0,0.0,0.0);
  PVector acc = new PVector(0.0,0.0,-grav);
  
  float mass = random(0.8,3.5);
  
  ArrayList<PVector> path = new ArrayList<>();
  
  public Particle(){
    path.add(cPos.copy());
  }
  
  void update(){
    vel.add(acc.copy().mult(0.1));
    cPos.add(vel.copy().mult(0.1));
    cPos.set(constrain(cPos.x,-150,150),constrain(cPos.y,-150,150),constrain(cPos.z,0,300));
    path.add(cPos.copy());
  }
  
  void show(){
    
    float floatIndex = (steps-1)*t;
    int index1 = floor(floatIndex);
    int index2 = index1+1;
    float lerpParameter = floatIndex-index1;
    PVector position1 = path.get(index1);
    PVector position2 = path.get(index2);
    PVector lerpedPosition = position1.copy().lerp(position2,lerpParameter);
    
    push();
    translate(lerpedPosition.x,lerpedPosition.y, lerpedPosition.z);
    
    stroke(255);
    strokeWeight(mass);
    point(0,0,0);
    pop();
  }
}

class Fluid{
 
  Particle[] particles = new Particle[1000];
  
  public Fluid(){
      println("UP");
   for(int i=0;i<particles.length;i++){
      particles[i] = new Particle();
    } 
    
    for(int s=0; s<steps; s++){
     for(int i=0;i<particles.length;i++){
        particles[i].update();
      } 
    }
  }
  
  void show(){
    for(int i=0;i<particles.length;i++){
      particles[i].show();
    } 
  }
  
  float kernel(float r, float d){
    float volume = PI * pow(r,8)/4;
   float v = max(0,r*r - d*d);
   return pow(v,3) / volume;
  }
  
  float calcDensity(PVector samplePoint){
    float density = 0;
    for(int i=0;i<particles.length;i++){
      float dist = particles[i].cPos.dist(samplePoint);
      density += particles[i].mass * kernel(20,dist);
    } 
    return density;
  }
  
  PVector gradient(PVector samplePoint){
    float baseDensity = calcDensity(samplePoint);
    float dx = calcDensity(PVector.add(samplePoint, new PVector(0.01,0,0))) - baseDensity;
    float dy = calcDensity(PVector.add(samplePoint, new PVector(0,0.01,0))) - baseDensity;
    float dz = calcDensity(PVector.add(samplePoint, new PVector(0,0,0.01))) - baseDensity;
    return new PVector(dx,dy,dz).div(0.01);
  }
  
}
