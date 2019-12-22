macro "Manual_Binary" {
	width = getWidth();
	height = getHeight();
	upper_threshold = 100;
	lower_threshold = 30;
	run("8-bit");//Set pixel value to 0~255
	
	for (i = 0; i < width; i++) {
		for (j = 0; j < height; j++) 
		{
			pixel_value = getPixel(i, j); //Get every pixel value
			if (pixel_value > lower_threshold && pixel_value < upper_threshold) {
				setPixel(i, j, 255);} 
			else {
				setPixel(i, j, 0);}
		}
	}
}
