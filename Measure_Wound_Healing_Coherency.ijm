/**
  * Measure Wound Healing using Coherency
  * Collaborators: 
  *		Kelsey Quinn
  *
  * Measure the area of a wound in a cellular tissue on a stack 
  * of images representing a time-series. The macro needs FeatureJ and
  * MorphoLibJ to be installed.
  * The coherency function has been written by Arnold Fertin.
  *
  * (c) 2016, INSERM
  * written by Volker Baecker at Montpellier RIO Imaging (www.mri.cnrs.fr)
  *
*/

var _CLOSE_RADIUS = 20;
var _OPEN_RADIUS = 20;
var _CLOSE_BIG_RADIUS = 80;
var _MIN_SIZE = 20000;
var _COHERENCY_SIGMA = 0.250; 
var _COHERENCY_WINDOW_SIZE = 5;

var helpURL = "http://dev.mri.cnrs.fr/wiki/imagej-macros/Wound_Healing_Coherency_Tool"

macro "MRI Wound Healing Coherency Help Action Tool - CaaaD03D0fD1eD21D2eD2fD30D3eD46D53D54D58D63D64D66D72D74D76D85D86D87D93D97D9bD9fDa9DaaDabDafDbbDbcDbdDbfC999D02D09D0dD18D1cD28D2dD36D7eD8fDccDcfDd4DdbDdfDfeDffCbbbD20D51D62D84Da5Da8Db1Db9DcbDd5De1De8Df0C777D14D15D16D5dD6cDdcDe2De3CbbbD04D05D10D1aD3fD43D44D4fD52D56D5fD61D67D7cD8aD8bD98D9cD9dD9eDacDadDaeDbaDbeDd9CaaaD00D06D0aD0bD11D1bD1dD1fD2bD31D32D33D34D37D38D39D3aD3bD4eD55D65D75D77D78D88D89D8cD99D9aDb3Db8Dc4Df7CcccD29D2aD69D7aD83D96Db4C666D48D49D4aD4bD4cD59D5cD6aD82Da1Da7Dc0Dd7DddDdeDeaDebDecDedDeeDf5Df6Df9DfaDfbC999D0cD0eD22D23D35D42D45D60D6fD7dD8eDa3Db2DceDf4Df8CcccD19D47D57D68D73D79D7bDdaDe0C888D01D07D08D12D13D24D25D26D2cD3cD3dD41D4dD50D5eD6eD7fD8dDc5Dc8DcdDd6Dd8De4De5DefDfdCdddD95Da0Da4Db0Dc9DcaDe7Df2Df3C444D5aD5bD70D71D80D90Da2Da6Db5Dc6Dd3De9C888D17D27D40D6dDd0De6DfcCdddD94Df1"{
    run('URL...', 'url='+helpURL);
}

macro 'Measure Wound Healing Coherency Action Tool - C000T4b12m' {
	measureTimeSeries();
}

macro 'Measure Wound Healing Coherency Action Tool Options' {
	  Dialog.create("Wound Healing Coherency Options");
	  Dialog.addNumber("radius close", _CLOSE_RADIUS);
	  Dialog.addNumber("radius open", _OPEN_RADIUS);
	  Dialog.addNumber("radius big close", _CLOSE_BIG_RADIUS);
	  Dialog.addNumber("min. size", _MIN_SIZE);
	  Dialog.addNumber("sigma for coherency", _COHERENCY_SIGMA);
	  Dialog.addNumber("window size for coherency", _COHERENCY_WINDOW_SIZE);
	  Dialog.show();
	  _CLOSE_RADIUS = Dialog.getNumber();
	  _OPEN_RADIUS = Dialog.getNumber();
	  _CLOSE_BIG_RADIUS = Dialog.getNumber();
	  _MIN_SIZE = Dialog.getNumber();
	  _COHERENCY_SIGMA = Dialog.getNumber();
	  _COHERENCY_WINDOW_SIZE = Dialog.getNumber();
}

function measureTimeSeries() {
	roiManager("Reset");
	roiManager("Associate", "true");
	for(i=1; i<=nSlices; i++) {
		setSlice(i);
		run("Select None");
		run("Duplicate...", "use");
		measureTissueArea();
		close();
		run("Restore Selection");
		roiManager("Add");
	}
	setSlice(1);
	run("Select None");
	roiManager("Show All");
}

function measureTissueArea() {
	coherency();
	run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
	selectWindow("Coherency");
	setAutoThreshold("Triangle dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Morphological Filters", "operation=Closing element=Square radius=" + _CLOSE_RADIUS);
	run("Morphological Filters", "operation=Opening element=Square radius=" + _OPEN_RADIUS);
	run("Analyze Particles...", "size="+_MIN_SIZE+"-Infinity show=Masks");
	run("Morphological Filters", "operation=Closing element=Disk radius=" + _CLOSE_BIG_RADIUS);
	run("Create Selection");
	close();
	close();
	close();
	close();
	close();
	run("Restore Selection");
	run("Make Inverse");
	run("Measure");
}

function coherency() {
	sigma = _COHERENCY_SIGMA;
	windowSize = _COHERENCY_WINDOW_SIZE;
	
	setBatchMode(true);
	
	run("FeatureJ Structure", "largest smallest smoothing=" + sigma + " integration=" + windowSize);
	
	list = getList("image.titles");
	for (i=0; i<list.length; i++)
	{
		if (endsWith(list[i], "smallest structure eigenvalues")) 
		{
			selectWindow(list[i]);
			rename("lambda2");
		}
		if (endsWith(list[i], "largest structure eigenvalues")) 
		{
			selectWindow(list[i]);
			rename("lambda1");
		}
	}
	
	imageCalculator("Subtract create", "lambda1","lambda2");
	rename("Coherency");
	imageCalculator("Add create", "lambda1","lambda2");
	rename("tmp");
	
	imageCalculator("Divide", "Coherency","tmp");
	selectWindow("Coherency");
	run("Square");
	
	selectWindow("lambda2");
	run("Macro...", "code=[if(v<0)  v = 0; else v = 1;]");
	imageCalculator("Multiply", "Coherency","lambda2");
	
	selectWindow("tmp");
	close();
	selectWindow("lambda2");
	close();
	selectWindow("lambda1");
	close();
	setBatchMode("exit and display");
}
