float j1 = 0, j2 = PI;
float R = 200;
int power1 = 0, power2 = 0;
float speed = 0.01;
boolean direction = false;

void setup() {
 size(500, 500);
}

void draw() {
  rectMode(CENTER);
  background(0);
  float theta0 = (j1 + j2)/2;
  println(j1, j2, theta0);
  translate(width/2, height/2);
 
  pushMatrix();
  rotate(theta0);
  if (j1 > j2) stroke(255, 0, 0); else stroke(0, 0, 255);
  for (float theta = 0; theta < PI; theta += 0.001) {
    point(R * cos(theta), R * sin(theta));
  }
  if (j1 > j2) stroke(0, 0, 255); else stroke(255, 0, 0);
  for (float theta = PI; theta < TWO_PI; theta += 0.001) {
    point(R * cos(theta), R * sin(theta));
  }
  popMatrix();
  
  //draw J1
  noStroke();
  fill(255, power1 + 55, power1 + 55);
  pushMatrix();
  translate(R * cos(j1), R * sin(j1));
  rotate(j1);
  rect(0, 0, 20, 80, 4);
  popMatrix();
  
    //draw J2
  noStroke();
  fill(55 + power2, 55 + power2, 255);
  pushMatrix();
  translate(R * cos(j2), R * sin(j2));
  rotate(j2);
  rect(0, 0, 20, 80, 4);
  popMatrix();
  
  if (power1 > 0) power1 -= 1;
  if (power2 > 0) power2 -= 1;
}

void keyPressed() {
   if (key == CODED) {
     switch (keyCode) {
       case DOWN :
         if (power1 == 0) power1 = 200;
         break;
       case RIGHT :
         j1 += direction ? speed : -speed;
         break;
       case LEFT :
         j1 -= direction ? speed : -speed;
         break;
     }
   } else {
      switch (key) {
        case 'a' :
          j2 += direction ? speed : -speed;
          break;
        case 'd' :
          j2 -= direction ? speed : -speed;
          break;
        case 's' :
          if (power2 == 0) power2 = 200;
          break;
      }
   }
   while (j1 < 0) j1 += TWO_PI;
   while (j2 < 0) j2 += TWO_PI;
   while (j1 >= TWO_PI) j1 -= TWO_PI;
   while (j2 >= TWO_PI) j2 -= TWO_PI;
}
