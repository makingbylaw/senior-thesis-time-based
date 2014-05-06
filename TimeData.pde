class TimeData {
  
  public TimeData(int hour, int numberOfSections) {
   this.hour = hour;
   this.sections = new SectionData[numberOfSections]; 
  }
  
 int hour;
 SectionData[] sections; 
}
