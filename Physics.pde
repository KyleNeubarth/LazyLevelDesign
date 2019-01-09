void DoPhysics() {
  
  //y
  if (three && !jump && grounded) {
    velY = maxJumpVel;
    grounded = false;
    jump = true;
  }
  if (jump && !three) {
    if (velY > minJumpVel) {
      velY = minJumpVel;
    }
    jump = false;
  }
  //x
  if (xAxis < -0.5f) {
    velX -= 0.4f;
    if (abs(velX) > abs(maxVelX)) {
      velX = -maxVelX;
    }
  }
  if (xAxis > 0.5f) {
    velX += 0.4f;
    if (abs(velX) > abs(maxVelX)) {
      velX = maxVelX;
    }
  }
  //friction
  velX *= .95f;
  //gravity
  velY -= 14f*deltaTime;
  //raycast
  DoCollisions();
  
  x += velX;
  y -= velY;
}
void die() {
  x = spawnX;
  y = spawnY;
  velX = 0;
  velY = 0;
  jump = false;
}