float R = 200;
float speed = 0.01;
// false == direction at the top, true == direction at the bottom
boolean direction = false;

Player j1, j2;

void setup() {
 size(500, 500);
 
 j1 = new Player(0, Player.RED);
 j2 = new Player(PI, Player.BLUE);
}

void draw() {
  rectMode(CENTER);
  background(0);
  float theta0 = (j1.position + j2.position)/2;
  translate(width/2, height/2);
 
  pushMatrix();
  rotate(theta0);
  if (j1.position > j2.position) stroke(255, 0, 0); else stroke(0, 0, 255);
  for (float theta = 0; theta < PI; theta += 0.001) {
    point(R * cos(theta), R * sin(theta));
  }
  if (j1.position > j2.position) stroke(0, 0, 255); else stroke(255, 0, 0);
  for (float theta = PI; theta < TWO_PI; theta += 0.001) {
    point(R * cos(theta), R * sin(theta));
  }
  popMatrix();
  
  j1.draw();
  j2.draw();  
  j1.update();
  j2.update();
}

void keyPressed() {
   if (key == CODED) {
     j1.setMove(keyCode, true);
   } else {
     j2.setMove(keyCode, true);
   }
}

void keyReleased() {
   if (key == CODED) {
     j1.setMove(keyCode, false);
   } else {
     j2.setMove(keyCode, false);
   }
}

class Player {
  static final int BLUE = 0;
  static final int RED = 1;
  static final int GREEN = 2;
  
  float position;
  int power = 0;
  boolean isRight = false;
  boolean isLeft = false;
  final int c;
  
  Player(final float position, final int c) {
    this.position = position;
    this.c = c;
  }
  
  void draw() {
    noStroke();
    switch(this.c) {
      case Player.RED :
        fill(255, power + 55, power + 55);
        break;
      case Player.BLUE :
        fill(power + 55, power + 55, 255);
        break;
      case Player.GREEN :
        fill(power + 55, 255, power + 55);
        break;
      default :
        fill(power + 55, power + 55, power + 55);
    }
    pushMatrix();
    rotate(position);
    translate(R, 0);
    rect(0, 0, 20, 80, 4);
    popMatrix();
  }
  
  void update() {
    if (this.isRight) {
      this.position += speed;
    }
    if (this.isLeft) {
      this.position -= speed;
    }
    if (power > 0) power -= 1;
    while (position < 0) position += TWO_PI;
    while (position >= TWO_PI) position -= TWO_PI;
  }
  
  void setMove(final int k, final boolean mode) {
    switch(k) {
      case 'A' :
      case LEFT :
        if (direction)
          this.isRight = mode;
        else
          this.isLeft = mode;
        break;
      case 'D' :
      case RIGHT :
        if (direction)
          this.isLeft = mode;
        else
          this.isRight = mode;
        break;
      case 'S' :
      case DOWN :
        if (this.power == 0)
          this.power = 200;
        break;
    }
  }
}
