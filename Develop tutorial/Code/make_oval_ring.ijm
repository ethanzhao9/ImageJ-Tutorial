macro "make_oval_ring" {
//Create a Dialog
Dialog.create("Initialization");
Dialog.addNumber("x_center:", 524);
Dialog.addNumber("y_center:", 502);
Dialog.addNumber("diameter:", 913);
Dialog.addNumber("step:", 30);
Dialog.show();

x_center = Dialog.getNumber();
y_center = Dialog.getNumber();
diameter = Dialog.getNumber();
step = Dialog.getNumber();
radius = diameter/2;
num_oval = floor(radius/step)+1;//Decide the Number of Oval
//Create Oval
for (i = 0; i < num_oval; i++) 
{
	diameter_num = 2*step*(i+1);
	radius = diameter_num/2;
	makeOval(x_center-radius, y_center-radius, diameter_num, diameter_num);
	roiManager("Add");
	roiManager("Select", i);
	roiManager("Rename", i+1);
}
//Create Ring
for (j = 1; j <num_oval-1; j++) {
	roiManager("Select", newArray(j,j+1));
	roiManager("XOR");
	roiManager("Add");
	ring_number = num_oval+j-1;
	roiManager("Select",ring_number);
	roiManager("Rename", "ring"+j);	
	}
}