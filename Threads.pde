class ProcessCameraFeed implements Runnable {
  Thread t;
  public void run() {
    while (true) {
      if (cameraReady) {
        processing = true;
        ProcessImage(level);
        //tell the main thread to print the new data
        processing = false;
        updateData = true;
        cameraReady = false;
      }
      try {
        // thread to sleep for 1000 milliseconds
        Thread.sleep(100);
      } catch (Exception e) {
        System.out.println(e);
      }
    }
  }
}