macro "Save all open images" 
{
	dir = getDirectory("Choose a Directory to Save"); 
	ids=newArray(nImages); // get the IDs of all open images 
	for (i=0;i<nImages;i++) 
	{ 
		selectImage(i+1); 
		title = getTitle; 
		print(title + " is saved."); //Reminder
		ids[i]=getImageID; 
		saveAs("tiff", dir+title); 
	}
}
