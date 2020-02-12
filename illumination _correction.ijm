//This macro is used for z-axis illumination correction.
macro "Illumination_Correction" {
	run("16-bit");//Avoid overexposure
	for (i = 0; i < nSlices; i++) {
		selectWindow("Plot Values");
		first_value = Table.get("Y0",0);//Select first slice for normalization 
		slice_value = Table.get("Y0",i);
		correction_ind = slice_value/first_value;
		setSlice(i+1);//Next slice
		run("Divide...", "value=" + correction_ind + " slice");//Divide by correction index
		print(i+1);
	}
	run("8-bit");
}

