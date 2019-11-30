macro "Create NewImage Dialog" {
	//Create Dialog and Input Type
	Dialog.create("New Image");
	Dialog.addString("Title:", "Untitled");
	Dialog.addChoice("Type:", newArray("8-bit", "16-bit", "32-bit", "RGB"));
	Dialog.addNumber("Width:", 512);
	Dialog.addNumber("Height:", 512);
	Dialog.addCheckbox("Ramp", true);
	Dialog.show();
	//Get Value from Dialog Input
	title = Dialog.getString();
	width = Dialog.getNumber();
	height = Dialog.getNumber();
	type = Dialog.getChoice();
	ramp = Dialog.getCheckbox();
	if (ramp==true) {
		type = type + " ramp";}
	//Create Image
	newImage(title, type, width, height, 1);
}