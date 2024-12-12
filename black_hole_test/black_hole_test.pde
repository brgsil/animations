Particle[][] rays = new Particle[700][700];
Thing[] t = new Thing[150];
int ii=0,jj=0;
float size = 700;
void setup(){
  size(700,700);
  //ortho();
  
  for (int i=0; i<t.length-51; i++){
    t[i] = new Ring();
  }
  t[t.length-51] = new Borders();
  for (int i=t.length-50; i<t.length; i++){
    t[i] = new Star();
  }
  
  for (int i=0; i<rays.length; i++){
  for (int j=0; j<rays[i].length; j++){
   rays[i][j] = new Particle((i-(rays.length-1)/2.0)*size/rays.length,(j-(rays[i].length-1)/2.0)*size/rays[i].length); 
  }
  }
  for (int i=0; i<rays.length; i++){
  for (int j=0; j<rays[i].length; j++){
    while(!rays[i][j].hit)
     rays[i][j].update(t);
     if(j%100==0)
      println(i + " " + j);
  }
  }
 frameRate(1000);
 background(0);
}

void draw(){
 translate(width/2,height/2);
 //rotateY(-PI/2);
 //rotateX(PI/2);
 //rotateZ(0.2);
 /*stroke(255);
 noFill();
 circle(0,0,100);
 stroke(255,0,0);
 line(0,0,0,100,0,0);
 stroke(0,255,0);
 line(0,0,0,0,100,0);
 stroke(0,0,255);
 line(0,0,0,0,0,100);*/
 
 for (int i=0; i<rays.length; i++){
  for (int j=0; j<rays[i].length; j++){
   //rays[i][j].update(t);
   rays[i][j].show(); 
  }
  }
  
  saveFrame("img.png");
  exit();
  
 
  /*for (int i=0; i<t.length; i++){
    t[i].show();
  }*/
}

class Particle{
  float x,y,z;
  PVector pos;
  
  float ang = 20.0*PI/180;
  PVector vel = new PVector(-1*cos(-ang),0,1*sin(-ang));
  
  float g = 1;
  boolean hit = false;
  Thing hitted = null;
  float d = 300;
  float h = 100;
  
  public Particle(float y_, float z_){
    x=d;
    y=y_;
    //z=z_;
    z = z_;
    //c=map(y,0,height/2,0,255);
    pos = new PVector(d*cos(ang)-z_*sin(ang),y,d*sin(ang)+z_*cos(ang));
    
    vel = PVector.add(new PVector(0,y_,z_),new PVector(-h,0,0)).normalize();
   
    float vx = cos(-ang)*vel.x+sin(-ang)*vel.z;
    float vz = -sin(-ang)*vel.x+cos(-ang)*vel.z;
    vel.set(vx,vel.y,vz);
  }
  
  void show(){
    if (hit){
   stroke(hitted.getColor());
   strokeWeight(1);
   point(y/size*700,z/size*700);
   //point(x,y,z);
    }else{
   stroke(255);
   strokeWeight(2);
   point(y/size*700,z/size*700);
   //point(pos.x,pos.y,pos.z);
    }
  }
  
  void update(Thing[] t){
    float dist = pos.mag()-5;
    if (dist < 250 || dist > 750){
    for (int i=0; i<t.length; i++){
     if(t[i].hit(pos)){
      hit = true;
      hitted = t[i];
     }
    }
  }
    
    if (!hit){
    vel.add(pos.copy().mult(-0.1*g/pow(dist,2)));
    vel.setMag(1);
    pos.add(vel.copy().mult(0.1));
    }
    
      
  }
}

interface Thing{
 boolean hit(PVector p);
 void show();
 color getColor();
}

class Ring implements Thing{
  float r = random(100,200);
  float h = random(4)-2;
  
  boolean hit(PVector p){
    float pr = mag(p.x,p.y);
    float ph = p.z;
    return abs(r-pr) <= 0.5 && abs(h-ph) <= 0.5;
  }
  
  void show(){
    push();
    noFill();
    stroke(100,100,20);
    translate(0,0,h);
    circle(0,0,2*r);
    pop();
  }
  color getColor(){
    return color(100,100,20);
  }
}

class Borders implements Thing{
 
  boolean hit(PVector p){
    return abs(p.x) > 1000 || abs(p.y) > size || abs(p.z) > size || p.mag() < 10;
  }

  void show(){
    
  }
  color getColor(){
    return color(0,0,0);
  }
}

class Star implements Thing{
 
  PVector pos = new PVector(-800,random(0,1000),random(0,1000));
  
  float r = random(2,6);
  color c = color(random(50,220),random(50,220),random(50,220));
  
  boolean hit(PVector p){
    return pos.dist(p) <= r;
  }
  
  void show(){
    push();
    translate(pos.x,pos.y,pos.z);
    sphere(r);
    pop();
  }
  
  color getColor(){
    return c;
  }
  
}
