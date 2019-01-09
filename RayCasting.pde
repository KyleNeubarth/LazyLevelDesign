enum direction {
  TOP,
  BOTTOM,
  LEFT,
  RIGHT
}

class RayCastHit {
  int x, y, type;
  direction dir; 
  public RayCastHit(int _x, int _y, int _type, direction _dir) {
    x = _x;
    y = _y;
    type = _type;
    dir = _dir;
  }
}
public RayCastHit VRayCast(int sX,int sY,int l) {
  direction dir = ((l>0)?direction.TOP:direction.BOTTOM);
  line(sX,sY,sX,sY-l);
  for (int i=1;i<abs(l)+1;i++) {
    int pos = sY + i*((l>0)?-1:1);
    //fell out of bounds
    if (pos*level.width+sX > level.width*level.height || pos*level.width+sX < 0) {
      die();
      return null;
    }
    if (data[pos*level.width+sX] == 0) {
      return(new RayCastHit(sX,pos+((dir == direction.BOTTOM)?-1:1),0,dir));
    }
    if (data[pos*level.width+sX] == 1) {
      die();
      return null;
      //return(new RayCastHit(sX,spawnY,1,dir));
    }
  }
  return null;
}
public RayCastHit HRayCast(int sX,int sY,int l) {
  if (l==0) {
    return null;
  }
  direction dir = ((l>0)?direction.RIGHT:direction.LEFT);
  line(sX,sY,sX+l,sY);
  for (int i=1;i<abs(l)+1;i++) {
    int pos = sX + i*((l>0)?1:-1);
    //fell out of bounds
    if (pos > level.width || pos < 0) {
      die();
      return null;
    }
    if (data[pos+sY*level.width] == 0) {
      return(new RayCastHit(pos+((dir == direction.LEFT)?1:-1),sY,0,dir));
    }
    if (data[pos+sY*level.width] == 1) {
      die();
      return null;
      //return(new RayCastHit(sX,spawnY,1,dir));
    }
  }
  return null;
}

void DoCollisions() {
  direction dir = (velY>0)?direction.TOP:direction.BOTTOM;
  grounded = false;
  boolean hit = false;
  int closest = (dir == direction.TOP)?0:999999;
  boolean recording[] = new boolean[15];
  for (int i=0;i<10;i++) {
    RayCastHit v;
    if (dir == direction.BOTTOM) {
      //bottom
      v = VRayCast(round(x-pWidth/2+pWidth*i/9),round(y+pHeight/2),floor(velY));
    } else {
      //top
      v = VRayCast(round(x-pWidth/2+pWidth*i/9),round(y-pHeight/2),ceil(velY));
    }
    if (v != null) {
      recording[i] = true;
      hit = true;
      if (v.dir == direction.TOP) {
        if (v.y > closest) {
          closest = v.y;
        }
      } else {
        if (v.y < closest) {
          closest = v.y;
        }
      }
    }
  }
  if (hit) {
    boolean allRight = true;
    boolean allLeft = true;
    for (int i=1;i<10;i++) {
      if (recording[i] == true) {
        allLeft = false;
      }
    }
    for (int i=0;i<9;i++) {
      if (recording[i] == true) {
        allRight = false;
      }
    }
    if (recording[0] && allRight) {
      println("left");
      x--;
      return;
    } else if (recording[9] && allLeft) {
      println("right");
      x++;
      return;
    } else {
      velY = 0;
      if (dir == direction.TOP) {
          y = closest+pHeight/2;
          jump = false;
      } else if (dir == direction.BOTTOM) {
          y = closest-pHeight/2;
          grounded = true;
          jump = false;
      }
    }
  }
  
  dir = (velX>0)?direction.RIGHT:direction.LEFT;
  hit = false;
  recording = new boolean[15];
  closest = (dir == direction.LEFT)?0:999999;
  for (int i=0;i<15;i++) {
    RayCastHit h;
    if (dir == direction.LEFT) {
      //Left
      h = HRayCast(round(x-pWidth/2),round(y+pHeight/2f-pHeight*i/14),floor(velX));
    } else {
      //Right
      h = HRayCast(round(x+pWidth/2),round(y+pHeight/2f-pHeight*i/14),ceil(velX));
    }
    if (h != null) {
      recording[i] = true;
      hit = true;
      if (h.dir == direction.LEFT) {
        if (h.x > closest) {
          closest = h.x;
        }
      } else {
        if (h.x < closest) {
          closest = h.x;
        }
      }
    }
  }
  
  if (hit) {
    boolean allBottom = true;
    boolean allTop = true;
    for (int i=1;i<15;i++) {
      if (recording[i] == true) {
        allBottom = false;
      }
    }
    for (int i=0;i<14;i++) {
      if (recording[i] == true) {
        allTop = false;
      }
    }
    if (recording[0] && allBottom) {
      y--;
      return;
    } else if (recording[14] && allTop) {
      y++;
      return;
    } else {
      velX = 0;
      if (dir == direction.RIGHT) {
          x = closest-pWidth/2;
      } else if (dir == direction.LEFT) {
          x = closest+pWidth/2;
      }
    }
  }
}