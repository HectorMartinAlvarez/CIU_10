import gifAnimation.*;

GifMaker gifExport;

PShader shader;

float time = 0.0;
float v = 0.01;
float X = 900.0;
float Y = 900.0;
float r = 0.0;

void setup() {
  size(900, 900, P3D);
  noStroke();
  shader = loadShader("shader.glsl");
  shader.set("X", X);
  shader.set("Y", Y);
  gifExport = new GifMaker(this, "spin rect sine growth.gif");
  gifExport.setRepeat(0); // make it an "endless" animation
  gifExport.setTransparent(255); // make white the transparent color -- match browser bg color
}

void draw() {
  shader.set("u_time", time);
  shader(shader);
  background(0);
  translate(width/2, height/2);
  rotateY(r+=0.01);
  box(500);
  time += v;
  gifExport.addFrame();
  if (frameCount == 120) gifExport.finish();  
}
