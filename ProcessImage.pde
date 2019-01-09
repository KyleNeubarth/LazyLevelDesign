void ProcessImage(PImage img) {
  img.loadPixels();
  float dist;
  data = new int[img.width*img.height];
  
  for (int i=0;i<img.pixels.length;i++) {
    float minDist = 9999;
    int closest = -1;
    float temp;
    temp = GetDistance(img.pixels[i],ground);
    if (temp < minDist) {
      closest = 0;
      minDist = temp;
    }
    temp = GetDistance(img.pixels[i],deadly);
    if (temp < minDist) {
      closest = 1;
      minDist = temp;
    }
    temp = GetDistance(img.pixels[i],start);
    if (temp < minDist) {
      closest = 2;
      minDist = temp;
    }
    temp = GetDistance(img.pixels[i],finish);
    if (temp < minDist) {
      closest = 3;
      minDist = temp;
    }
    if (minDist < 50) {
      data[i] = closest;
    } else {
      data[i] = -1;
    }
  }
  //paste to image
  for (int i=0;i<img.width*img.height;i++) {
    if (data[i] == 0) {
      altLevel.set(i%img.width,i/img.width,groundR);
    } else if (data[i] == 1) {
      altLevel.set(i%img.width,i/img.width,deadlyR);
    } else if (data[i] == 2) {
      altLevel.set(i%img.width,i/img.width,startR);
    } else if (data[i] == 3) {
      altLevel.set(i%img.width,i/img.width,finishR);
    } else {
      altLevel.set(i%img.width,i/img.width,img.pixels[i]);
    }
  }
  /*
  for (int i=0;i<img.pixels.length;i++) {
    //blue
    dist = GetDistance(img.pixels[i],start);
    if (dist < 30) {
      data[i] = 3;
      spawnX+=i%img.width;
      spawnY+=i/img.width;
      numPoints++;
      continue;
    }
    //black
    dist = GetDistance(img.pixels[i],ground);
    if (dist < 80) {
      data[i] = 0;
      continue;
    }
    //red
    dist = GetDistance(img.pixels[i],deadly);
    if (dist < 60) {
      data[i] = 1;
      continue;
    }
    //green
    dist = GetDistance(img.pixels[i],finish);
    if (dist < 50) {
      data[i] = 2;
      continue;
    }
    //nothing
    data[i] = -1;
  }
  if (numPoints>0) {
    spawnX /= numPoints;
    spawnY /= numPoints;
    die();
  }
  //color representation of data
  //for debug only
  //data = new int[img.width*img.height];
  for (int i=0;i<img.width*img.height;i++) {
    if (data[i] == 0) {
      altLevel.set(i%img.width,i/img.width,groundR);
    } else if (data[i] == 1) {
      altLevel.set(i%img.width,i/img.width,deadlyR);
    } else if (data[i] == 2) {
      altLevel.set(i%img.width,i/img.width,startR);
    } else if (data[i] == 3) {
      altLevel.set(i%img.width,i/img.width,finishR);
    } else {
      altLevel.set(i%img.width,i/img.width,img.pixels[i]);
    }
  }*/
}
float GetDistance(color c1,color c2) {
  return sqrt(pow(red(c1)-red(c2),2)+pow(green(c1)-green(c2),2)+pow(blue(c1)-blue(c2),2));
}
void DrawPaletteFrame() {
  offscreen.strokeWeight(1);
  offscreen.stroke(0);
  offscreen.noFill();
  offscreen.rect(9,9,32,52);
  offscreen.rect(44,9,32,52);
  offscreen.rect(79,9,32,52);
  offscreen.rect(114,9,32,52);
}
void DrawPaletteColors() {
  if (cam.width>0) {
    offscreen.noStroke();
    offscreen.fill(ground);
    offscreen.rect(10,10,30,50);
    offscreen.fill(deadly);
    offscreen.rect(45,10,30,50);
    offscreen.fill(start);
    offscreen.rect(80,10,30,50);
    offscreen.fill(finish);
    offscreen.rect(115,10,30,50);
  }
}
void ReadPalette() {
  ground = GetAvgColor(cam,10,10,30,50);
  deadly = GetAvgColor(cam,45,10,30,50);
  start = GetAvgColor(cam,80,10,30,50);
  finish = GetAvgColor(cam,115,10,30,50);
}
int GetAvgColor(PImage img,int x, int y, int w, int h) {
  img.loadPixels();
  int avgR = 0;
  int avgG = 0;
  int avgB = 0;
  int count = 0;
  for (int i=x;i<x+w;i++) {
    for (int j=y;j<y+h;j++) {
      color c = img.pixels[img.width*j+i];
      avgR += red(c);
      avgG += green(c);
      avgB += blue(c);
      count++;
    }
  }
  avgR = round(avgR/count);
  avgG = round(avgG/count);
  avgB = round(avgB/count);
  return color(avgR,avgG,avgB);
}
float Luminance(int c) {
  return (0.2126*red(c)/255 + 0.7152*green(c)/255 + 0.0722*blue(c)/255);
}
float GetBrightness() {
  cam.loadPixels();
  int total = 0;
  float count = cam.width*cam.height;
  for (int i=0;i<cam.width;i++) {
      for (int j=0;j<cam.height;j++) {
        total += Luminance(cam.pixels[j*cam.width+i]);
    }
  }
  return total/count;
}
void Darken(float amount) {
  cam.loadPixels();
  for (int i=0;i<cam.width;i++) {
      for (int j=0;j<cam.height;j++) {
        //cam.pixels[j*cam.width+i]
    }
  }
}