//This macro fills ROI with certain color by its pixel value.
macro "fill_ROI" {
	run("Select None");//Remove all the selections
	roiManager("reset");//Reset the ROI manager
	
	image_roi = getTitle();
	run("Duplicate...", "duplicate"); //Duplicate the image stack
	image_fill = getTitle();
	run("RGB Color");
	
	fill_ROI(1,"1","#d05151"); //Call the self-defined function
	fill_ROI(2,"2","#26a526"); //You should input three parameters: 
	fill_ROI(3,"3","#a6a627"); //Pixel value, ROI_Label_name and Color Code
	
	function fill_ROI(value,label,color) {
		//Get the ROI by its gray value
		for (i = 1; i < nSlices+1; i++) { //Loop to traverse all slices
			selectWindow(image_roi);
			setSlice(i); //
			setThreshold(value, value); //Threshold to select certain pixel value
			run("Create Selection");
			if (selectionType() ==-1) { //If there is on selection
				print("There is no " + label +" in " + i +" slice.");
			}
			else { 
				roi_name = label+"_"+i;
				Roi.setName(roi_name);
				roiManager("Add");
				roiManager("Measure");
				} 
			}
		//Fill ROI with certain color
		n = roiManager("count"); 
		for (j = 0; j < n; j++) { //Loop to traverse all ROI
			selectWindow(image_fill);
			roiManager("select", j);
			setColor(color);
			fill();
		}
		run("Select None"); //Remove all the selections
		roiManager("reset"); //Reset the ROI manager
	}
}
