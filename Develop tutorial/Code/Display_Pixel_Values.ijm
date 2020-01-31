macro "Display_Pixel_Values" {
	getSelectionBounds(xbase, ybase, width, height);//Get selection information, if there is no selection, xbase and ybase equal to 0 
	print("The xbase is "+xbase, ", The ybase is "+ybase);//Get the start point(Top left)
	ImageType = bitDepth() ;//bitDepth = 8->8bit, 16->16bit, 24->RGB
	
	if (ImageType != 24){//Not RGB image
		ShowValue(xbase, ybase, width, height, "Gray");//Call the ShowValue function
		print("This not an RGB image.");}
	else {//RGB image
		ShowValue(xbase, ybase, width, height, "Red");
		ShowValue(xbase, ybase, width, height, "Green");
		ShowValue(xbase, ybase, width, height, "Blue");
		print("This an RGB image.");}
	
	function ShowValue(xbase, ybase, width, height, channel) {	
		for (i = 0; i < width; i++) {	
			x_position = i + xbase;	
			for (j = 0; j < height; j++) {
				setOption("ShowRowNumbers", false);//Don't show the y axis
				setResult("Coordinate",j,j);//Set y coordinate
				y_position = j + ybase;
				value = getPixel(x_position, y_position);
				if (channel == "Gray") {
					setResult(i, j, value);}
				else if(channel == "Red"){
					setResult(i, j, (value>>16)&0xff);}//(..>>16)&0xff) represents the red channel
				else if(channel == "Green"){
					setResult(i, j, (value>>8)&0xff);}//(..>>8)&0xff) represents the green channel
				else if(channel == "Blue"){
					setResult(i, j, value&0xff);}//(..&0xff) represents the blue channel
			}
		}
		Table.rename("Results", channel);//Important for separate different results
	}	
}
