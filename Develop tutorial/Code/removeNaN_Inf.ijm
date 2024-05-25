// This macro removes the NaN and Infinity in the image
width = getWidth();
height = getHeight();
for (i = 0; i < width; i++) {	
	for (j = 0; j < height; j++) {
		value = getPixel(i, j);
		if (isNaN(value)) {
			setPixel(i, j, 0);
		}
		if (value>1000) {
			setPixel(i, j, 0);
		}
	}
}

