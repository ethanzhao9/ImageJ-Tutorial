macro "Auto Measure and Save"
{
	dir_saving = getDirectory("Choose a Directory to save");
	dir_processing = getDirectory("Choose a Directory to proess");
	list = getFileList(dir_processing);//Get a List of Images
	for(i = 0; i < list.length; i++) 
	{
		open(list[i]);//Open each image
		//Measure the Fluorescence
		run("8-bit");
		setAutoThreshold("Default dark"); 
		getThreshold(lower, upper);
		setThreshold(lower, upper-1); 
		run("Measure");
		//Add Fake Color
		run("Spectrum");
		saveAs("tiff", dir_saving + getTitle);
		close();
	}
}