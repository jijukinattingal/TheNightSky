
color darkColor = color(70, 83, 117);
color lightColor = color(255, 213, 147);
color treeColor = color(0, 0, 0);
color bgColor = color(166, 186, 198);
color groundColor = color(6, 14, 21);
color moonColor = color(255, 213, 147);

float noiseStep = .005;


void setup() {
  size(970, 600);
  noLoop();
}

void draw() {
  background(bgColor);

  drawStars();
  
  drawMoon();
  
  drawSky();
  
  drawTree();
}


void drawStars() {
  loadPixels(); 
 
  for(int x=0; x<width; x++) { 
    for(int y=0; y<height; y++) { 
      pixels[x+y*width] = color(sq((noise(x*noiseStep,y*noiseStep)*2-1))*64 + random(16),255); 
    } 
  }
  updatePixels(); 

  for(int x=width/2; x<=width; x+=10){
    for(int y=0; y<=height*2/3; y+=10){
    float x1 = map(x, width/2, width, width/2, width);
    float y1 = map(y, 0, 2*height/3, 2*height/3, 0);
    for(int i=0; i < pow((noise(x1*noiseStep,y1*noiseStep)*2-1)*10,2)/4; i++) {
        float test = random(1); 
        if(test>.75 && test<.95) { 
          star(x1+random(-5,5), y1+random(-5,5), random(.1,2.5), color(255,255, random(255)));         
        } 
      } 
    } 
  }
}

void drawMoon() {
  noStroke();
  fill(moonColor);
  ellipse(width*0.1,height*0.45, 75, 75);
}

void drawSky() {
  for (int y = 0; y < height; y += 2)   {
    for (int x = 0; x < width; x += 2)     {
      //draw clouds
      float n = noise(x/200., y/50.);     
      noStroke();
      //float maped = map(y, 0, 2*height/3., 255, 0);
      float maped = map(y, 0, 2*height/3.0, 255, 0);
      float alpha = n*maped;
      //if (y < height/2) {
      //  println("y = ", y, "noise = ", n, "maped = ", maped, "alpha = ", alpha);
      //}
      fill(darkColor, alpha); 
      ellipse(x, y, 3, 3);
    }
    //draw the light on the bottom
    strokeWeight(3);
    stroke(groundColor, map(y, 2*height/3, height, 0, 255));
    line(0, y, width, y);
  }
}

void drawTree() { 
  for (int i = 0; i < 10; i++) {
    tint(255, 30);
    tree(width*0.25+i*3, height, height/5.5, -HALF_PI);
  }

  for (int i = 0; i < 10; i++) {
    tint(255, 30);
    tree(width*0.45+i*3, height, height/4, -HALF_PI);
  }
}

void tree(float beginX, float beginY, float bLength, float angle) {
  //find the end of the branch
  float endX = beginX + bLength*cos(angle);
  float endY = beginY + bLength*sin(angle);
  
  //draw the branch
  strokeWeight(map(bLength, height/4, 3, 20, 1));
  stroke(treeColor);
  line(beginX, beginY, endX, endY);
  
  //generate 2 new branchs
  if (bLength  > 3) {
    if (random(1) > 0.1) tree(endX, endY, bLength*random(0.6, 0.8), angle - random(PI/15, PI/5));
    if (random(1) > 0.1) tree(endX, endY, bLength*random(0.6, 0.8), angle + random(PI/15, PI/5));
  }
}

void streak(float x,float y,float w,float h, float a) {
  pushMatrix(); 
  translate(x,y); 
  rotate(a); 
  triangle(-w/2,0, 0,h/2 , 0,-h/2); 
  triangle(w/2,0, 0,h/2 , 0,-h/2);  
  popMatrix(); 
} 

void star(float x, float y, float r, color c) { 
  fill(c*2,random(16,64)); 
  for(int i=0; i<random(3,5); i++) { 
    streak(x,y,random(3*r,5*r),1,random(TWO_PI)); 
  } 
  fill(c,random(16,255)); 
  ellipse(x,y,r,r); 
} 

void keyPressed() {
  //save the framme when we press the letter s
  if (key == 's' || key =='S')   {
    saveFrame("TheNightSky-###.png");
  }
}

void mouseReleased() {
  noiseSeed((int)random(0xFFFFFF));  //change noiseSeed
  background(255, 255, 255);
  redraw();
}
