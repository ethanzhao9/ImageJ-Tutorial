macro "Auto_Measure_Count" {
	function Measure_Fluo(title) { 
		selectWindow(title);
		setAutoThreshold("Default dark");  
		run("Measure");
		close(title);
	}
	function Count_Num(title) {
		selectWindow(title);
		setAutoThreshold("Default dark"); 
		run("Convert to Mask");
		run("Fill Holes");
		run("Watershed");
		run("Analyze Particles...", "size=100-Infinity show=Overlay exclude summarize");
		close(title);
	}
	dir = getDirectory("Choose a Directory");
	list = getFileList(dir);//Get a List of Images
	for(i = 0; i < list.length; i++) 
	{
		open(list[i]);//Open each image
		title = getTitle();
		run("Split Channels");//The type of image has to be RGB rather than composite!
		//Count nucleus number
		selectWindow(title + " (blue)");
		DAPI = getTitle();
		Count_Num(DAPI);
		//Measure fluorescence
		selectWindow(title + " (green)");
		GFP = getTitle();
		Measure_Fluo(GFP);
		close();
	}
	print("Mission Complete");
}
