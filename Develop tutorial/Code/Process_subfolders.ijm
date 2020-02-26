// This macro processes all the images in a folder and any subfolders.
macro "Process_subfolders" {
	path = getDirectory("Choose Source Directory ");
	setBatchMode(true);//Prevent images from showing up to speed up
	process_all(path);
	
	function process_all(path) {//Recursion function
		list = getFileList(path);
	    for (i=0; i<list.length; i++) {
	    	if (endsWith(list[i], "/")){//It's a folder.
	        	process_all(path+list[i]);}//Recurse to enter the subfolder
	        else {//It's an image.
	            dir = path + list[i];
	            print(dir);//Show processed images
	            processimage(dir);} 
	        }
	}
	function processimage(path) {//Process function
		open(path);
		title = getTitle();
		run("8-bit");
		run("Invert");
		saveAs("Tiff", path + "_after");//Prevent image overwrite
		close(title);
	}
}