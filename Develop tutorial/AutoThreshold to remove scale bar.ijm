macro "AutoThreshold to remove scale bar"{
//First Open Your Samples
run("8-bit");
//run("Threshold...");
setAutoThreshold("Default dark"); 
getThreshold(lower, upper); 
setThreshold(lower, upper-1); 
run("Measure");
close();
}
