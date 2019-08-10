macro "AutoThreshold to remove scale bar"{
//First Open Your Samples
run("8-bit");
setAutoThreshold("Default dark"); 
getThreshold(lower, upper); 
setThreshold(lower, upper-1); 
//run("Threshold...");
run("Measure");
close();
}
