OpenSimplexNoise noise;

ArrayList<ArrayList<PVector>> lines;

int numPoints = 250;
int numLines = 120;
float lineSpacing = 20;
boolean openSimplex = true;
int totalFrames = 360;
int noiseAmplitude = 350;

float pointSpacing = 1000/numPoints;
float noiseRadius = 0.8*pointSpacing;
int count = 0;

void setup()
{
  size(600,700,P3D);
  //frameRate(20);
  
  noise = new OpenSimplexNoise(12345);
  
  lines = new ArrayList<>();
  for (int i = 0; i < numLines; i++){
    ArrayList<PVector> line = new ArrayList<>();
    for (int j = 0; j < numPoints; j++){
      float noiseVal = getNoise(i,-(j+1));
      line.add(new PVector((j+0.5)*(pointSpacing)-(pointSpacing*numPoints/2),i*lineSpacing-lineSpacing*numLines/2, noiseAmplitude*noiseVal));
    }
    lines.add(line);
  }
}

void draw(){
  background(10);
  translate(width/2,0,-1300);
  rotateX(0.25*PI);
  //stroke(255,0,0);
  //line(0,0,0,1000,0,0);
  //stroke(0,255,0);
  //line(0,0,0,0,1000,0);
  //stroke(0,0,255);
  //line(0,0,0,0,0,1000);
  drawLines();
  updateLines();
  if (count <= totalFrames)
  saveFrame("out/loop-"+nf(count,3)+".png");
  else
  exit();
}

float smoothing(int line, int point){
  float scale = sin(PI * line / (numLines - 1.0));
  float pos = point / (numPoints - 1.0);
  float c = 2;
  return scale * exp(-pow(2*c*pos-c, 2));
  //return sin(pos*PI) * (1 - abs(pos - 0.5));
}

float getNoise(float i, float j){
  float x = noiseRadius*cos((j+count+numPoints)/totalFrames*TWO_PI);
  float y = noiseRadius*sin((j+count+numPoints)/totalFrames*TWO_PI);
  if (openSimplex)
    return map((float) noise.eval(x, y, i), -1, 1, 0, 1);
   else
     return noise(x, y, i);
}

void drawLines(){
  stroke(250);
  strokeWeight(2);
  fill(10);
  ArrayList<PVector> prev = null;
  for (ArrayList<PVector> line : lines){
    if (prev == null)
      prev = line;
    PVector linesBegin = prev.get(0);
    PVector linesEnd = prev.get(numPoints-1);
    beginShape();
    //vertex(linesBegin.x,linesBegin.y-1,-100);
    vertex(linesBegin.x,linesBegin.y-1,0);
    for (PVector p : line){
      vertex(p.x, p.y, p.z * smoothing(lines.indexOf(line), line.indexOf(p)));
    }
    vertex(linesEnd.x,linesEnd.y-1,0);
    //vertex(linesEnd.x,linesEnd.y-1,-100);
    endShape();
    prev = line;
  }
}

void updateLines(){
  for (ArrayList<PVector> line : lines){
    for (int i=line.size()-1; i > 0; i--){
      line.get(i).z = line.get(i-1).z;
    }
    float noiseVal = getNoise(lines.indexOf(line), 0);
    line.get(0).z = noiseAmplitude*noiseVal;
  }
  count++;
}
