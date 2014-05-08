final String FILENAME = "data2";
final int SECTIONS = 64;
final int SECTION_DIMENSION = 8;
final int TEXT_SIZE = 50;

TimeData[] data = new TimeData[24];
int frames = 0;
int currentHour = 0;
int maxFrequency = 0;
PImage bg;

void setup() {
  size(872, 682 + TEXT_SIZE);
  background(#ffffff);
  noStroke();
  
  // We can change the background image here. It must be the same size the the sketch.
  bg = loadImage("maparea_with_time_bw.png");
  
  Table table = loadTable(FILENAME + ".csv", "header");

  println(table.getRowCount() + " total rows in table"); 

  // Loop through each line
  for (TableRow row : table.rows()) {
    
    // Break apart the CSV
    //  0: section
    //  1: x
    //  2: y
    //  3: hour
    //  4: frequency
    int section = row.getInt("section");
    int x = row.getInt("x");
    int y = row.getInt("y");
    int hour = row.getInt("hour");
    int frequency = row.getInt("frequency");
    if (frequency > maxFrequency) {
      maxFrequency = frequency;
    }
    
    // Check if this hour has data
    if (data[hour] == null) {
      data[hour] = new TimeData(hour, SECTIONS);
    }
    TimeData timeData = data[hour]; 

    // Configure the section too
    if (timeData.sections[section] == null) {
      timeData.sections[section] = new SectionData();
    }
    SectionData sectionData = timeData.sections[section];
    sectionData.section = section; 
    sectionData.x = x;
    sectionData.y = y;
    sectionData.frequency = frequency;
  }
  
}

void draw() {
  
  // Clear the background
  //background(#ffffff); // This is a white background
  background(bg); // This uses the image background
  
  // Change the hours every two seconds
  frames++;
  if (frames > frameRate * 2) {
    frames = 0;
    currentHour ++;
    if (currentHour > 23) {
       currentHour = 0; 
    }
  }
  // Draw the time
  drawTime();
  
  // Draw heat map
  drawHeatMap();
}

void drawTime() {

  // Work out the time (convert from UTC)
  int adjustedTime = currentHour - 8;
  if (adjustedTime < 0)
      adjustedTime += 24;
  
  // Build up the time
  String time;
  if (adjustedTime == 0) {
      time = "12:00 a.m.";
  } else if (adjustedTime == 12) {
      time = "12:00 p.m.";
  } else if (adjustedTime > 12) {
      int adjustedToTwelveHour = adjustedTime- 12;
      time = adjustedToTwelveHour + ":00 p.m.";
  } else {
      time = adjustedTime + ":00 a.m.";
  }  
  
  // Draw the time
  fill(50);
  textSize(32);
  textAlign(CENTER);
  text(time, 0, 0, width, TEXT_SIZE);
}

void drawHeatMap() {
  // Get the section to draw
  TimeData timeData = data[currentHour];
  if (timeData == null)
      return; // Don't do anything if there is nothing to draw
  
  // Work out the common width and size
  //float commonWidth = min(width, height);
  float boxSizeX = width / SECTION_DIMENSION;
  float boxSizeY = (height - TEXT_SIZE) / SECTION_DIMENSION;
  
  // Loop through each section and draw it
  for (int i = 0; i < SECTIONS; i++) {
      
    // Unpack the data structure
    SectionData heatMapData = timeData.sections[i];
    if (heatMapData == null) {
        continue;
    }
    
    // Calculate the current color
    // For now go along the red scale adjusting the value
    float alpha = (heatMapData.frequency * 255.0f) / maxFrequency;
    color c = color(255, 0, 0, alpha);
    fill(c);
    
    // Calculate x and y coordinates as well as size
    float x = ((SECTION_DIMENSION - 2) - heatMapData.x) * boxSizeX;
    float y = ((SECTION_DIMENSION - 1) - heatMapData.y) * boxSizeY + TEXT_SIZE;
    
    // Draw a rectangle
    rect(x, y, boxSizeX, boxSizeY);
    
  }  
}
