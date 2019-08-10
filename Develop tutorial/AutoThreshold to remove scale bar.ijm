//First Open Your Samples
run("8-bit");
setAutoThreshold("Default dark"); 
getThreshold(lower, upper); //Get lower and upper threshold
setThreshold(lower, upper-1); //Reset the threshold
//run("Threshold...");
run("Measure");
close();
