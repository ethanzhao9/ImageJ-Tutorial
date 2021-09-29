// This macro creates multiple donut shaped ROI of pre-defined selection
bandSize = 10;
bandNum = 5;
roiManager("Add"); //Add pre-defined selection

for (i = 0; i < bandNum; i++) {
	roiManager("Select", 0);
	run("Make Band...", "band="+bandSize*(i+1)); //Create band
	roiManager("Add");
}

for (i = 0; i < bandNum-1; i++) {
	roiManager("Select", newArray(i+1,i+2)); //Select neighboring bands
	roiManager("XOR"); //Create ring
	roiManager("Add");
}

x = Array.getSequence(bandNum-1); //Create number sequence

for (i=0; i<x.length; i++){
	x[i] = x[i] + 2; //First unnecessary band starts at 2(The 3rd)
}
roiManager("Select", x);
roiManager("Delete"); //Delete unnecessary bands



