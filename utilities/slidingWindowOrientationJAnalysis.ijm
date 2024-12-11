//This imagej macro is based on this post in the imagej forum: https://forum.image.sc/t/i-cant-get-orientationj-to-focus-on-my-roi-when-called-from-a-macro/102756/1
//The macro serially extracts windows from your image and calculates the orientation of the features contained therein, outputting the windowed image and matching orientation 
//results in separate files for later perusal.
//To tailor the macro to your situation, consider changing the parameters set in lines 11, 12 and 37.
//You will need to install the orientationj plug-in.

#@ File (label="Select a file", style="file") myFile
#@ File (label="Select a directory", style="directory") myDir

open(myFile);
run("8-bit");
area=100;   //size of focal area in pixels
stepSize = area * 0.5;
id = getImageID();
w = getWidth();
h = getHeight();

for (ii=0;ii<h/stepSize;ii++){
   for (i=0;i<w/stepSize;i++){
        x=i*stepSize;
        y=ii*stepSize;
        makeRectangle(x, y, area, area);
        roiManager ("add");
         }
    }
    
    
nROIs=roiManager("count");
for (j=0;j<nROIs;j++){
  selectImage(id);
  roiManager("Select", j);
  roiManager("Combine");
  run("Duplicate...", "title=gridded-ROI_"+j+".gif");
  dup=getTitle();
  w = getWidth();
  h = getHeight();
  if (w == 100 && h == 100){
    run("OrientationJ Vector Field", "tensor=2.0 gradient=0 radian=on vectorgrid=10 vectorscale=80.0 vectortype=0 vectoroverlay=on vectortable=on ");
    selectWindow("OJ-Table-Vector-Field-");
    saveAs("OJ-Table-Vector-Field-",  myDir + "/gridded." + j + ".csv");
    run("Flatten");
    saveAs('jpeg', myDir + "/gridded." + j + ".jpg");
    selectWindow("gridded." + j + ".csv");
    run("Close");
    selectWindow("gridded-ROI_" + j + "-1.gif");
    run("Close");
  }
  selectWindow("gridded-ROI_" + j + ".gif");
  run("Close");
}