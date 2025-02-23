macro "String Process" {
	path = getDirectory("Choose a Directory to proess");
	list = getFileList(path);
	
	for (i = 0; i < list.length; i++) {
	label = substring(list[i], 9); //Get the different title labels
	blue_label = "_ch00.tif"; //DAPI
	green_label = "_ch01.tif"; //GFP
			
	if(label == blue_label){ //If the image label is "_ch00.tif"
		open(list[i]);
		DAPI = getTitle(); 
		Count_Num(DAPI); //Count the nuclei
		}
	else if(label == green_label){
		open(list[i]);
		GFP = getTitle();
		Measure_Fluo(GFP); //Measure the fluorescence
		}
	}
	
	function Measure_Fluo(title) { 
	selectWindow(title);
	run("8-bit");
	run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel"); // Remove the scale
	setAutoThreshold("Default dark");  
	run("Measure");
	close(title);
	}
	
	function Count_Num(title) {
	selectWindow(title);
	run("8-bit");
	run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
	setAutoThreshold("Default dark"); 
	run("Convert to Mask"); 
	run("Fill Holes");
	run("Watershed");
	run("Analyze Particles...", "size=400-Infinity show=Overlay exclude summarize");
	close(title);
	}
	

}
