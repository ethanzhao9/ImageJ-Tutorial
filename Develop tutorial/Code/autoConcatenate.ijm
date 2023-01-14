// This macro shows how to auto-concatenate stacks by constructing strings
prefix = "t1-head-"; // prefix before number
startIdx = 2;
stopIdx = 3;
imgNum = stopIdx - startIdx + 1;
finalString = "  ";

for (i = 0; i < imgNum; i++) {
	tmpImgIdx = i + 1;
	tmpFileIdx = startIdx + i;
	tmpString = "image" + tmpImgIdx + "=" + prefix + tmpFileIdx + ".tif ";
	finalString = finalString + tmpString;
}
run("Concatenate...", finalString);


