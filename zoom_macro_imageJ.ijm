/*
ImageJ macro making a movie (stack) of zooming on selected rectangle (ROI)
v2 Eugene Katrukha katpyxa at gmail.com
v2a Andrey Aristov: aaristov at pasteur.fr
v2b Lachlan Whitehead: whitehead at wehi.edu.au
	distortion when scaling bug fix by Jürgen Gluch: juergen.gluch at gmail.com
*/
requires("1.48h");

function main(){
	print("\\Clear");
	if(nImages==0){
		exit("No image open");
	}

	sTitle = getTitle();
	sMovieTitle=sTitle+"_zoom_movie";
	rawID=getImageID();
	getDimensions(imageW,imageH,c,z,totalFrames);
	if(totalFrames > 1){
		isTimeLapse = true;
	}else{
		isTimeLapse = false;
	}

	if(selectionType() == -1){
		exit("No roi selected");
	}
	Stack.getPosition(dummy, dummy, targetFrame) 
	Roi.getBounds(nX, nY, nW, nH);	

	//fix Aspect ratio of roi
	nH = nW * imageH / imageW;
	makeRectangle(nX, nY, nW, nH);
	

	ratio = nW / imageW;
	
	//Display options
	OptionsMenu();

	nFinalH = nFinalW *(imageH/imageW);


	setBatchMode(true);
	print("Processing Zoom Movie");
	
	zoomStep = exp(log(ratio)/finalLength); //calculate zoom step from menu option
	
	nCenterX=nX+0.5*nW;
	nCenterY=nY+0.5*nH;
	nScaleX=nW / imageW;
	nScaleY=nH / imageH;

		
	//adjust roi x/y ratio to image x/y ratio
	//depending on user choice - not sure this is entirely necessary
	if(startsWith(sChoice, "min")){
		nScaleFin=minOf(nScaleX,nScaleY);
	}else{
		nScaleFin=maxOf(nScaleX,nScaleY);
	}

	nW=nScaleFin*imageW;
	nH=nScaleFin*imageH;
	nX=nCenterX-(nW*0.5);
	nY=nCenterY-(nH*0.5);

	
	//distance from (0,0) to left top corner of selection
	length=sqrt(nX*nX+nY*nY);
	if(nX==0){
		angle=3.14/2;
	}else{
		angle=atan(nY/nX);
	}
		
	if(startsWith(sSizeChoice,"same as")){
		nFinalW=nW;
		nFinalH=nH;
		
	}else{
	
		nMovieScaleX=nW/nFinalW;
		nMovieScaleY=nH/nFinalH;
		nFinalW=nW / nMovieScaleX;
		nFinalH=nH / nMovieScaleY;
	
	}

	
	bNotFirstIt=false;

	dCount =0;
	nScale=1;

	newW=imageW;
	newH=imageH;
	dLen = length;
	ddLen = 0;
	
	run("Set Scale...", "distance=1 known="+px+" pixel=1 unit=um");
	print("\\Update1:Calculating zoom");	
	
	//process zooming step
	currentFrame = startZoomAtFrame;
	while(newW>nW){
		selectImage(rawID);	
		if(isTimeLapse){
			Stack.setFrame(currentFrame);
		}
		offsetX=ddLen*cos(angle);
		offsetY=ddLen*sin(angle);
		
		// if selction goes outside the image, we have to shift the selection
		// otherwise the ducplicate is a cropped version and gets distorded 
		// bugfix by Jurgen Gluch
		if (newW+offsetX > imageW) {offsetX = imageW-newW;}
		if (newH+offsetY > imageH) {offsetY = imageH-newH;}
		
		run("Specify...", "width="+toString(newW)+" height="+toString(newH)+" x="+toString(offsetX)+" y="+toString(offsetY));
		
		makeNextFrame();
		
		if(addScaleBar){
			putScaleBarOn();
		}
		
		if(bNotFirstIt){
			sCurrTitle=sTitle+"x"+toString(nScale);
			rename(sCurrTitle);
			run("Concatenate...", "  title=["+sMovieTitle+"] image1=["+sMovieTitle+"] image2=["+sCurrTitle+"]");
		}else{
			rename(sMovieTitle);
			sMovieID=getImageID();
			bNotFirstIt=true;
		}
		
		//updateZoom
		dLen=dLen*zoomStep;
		ddLen = length-dLen+length*nScaleFin;
		
		newW=newW*zoomStep;
		newH=newH*zoomStep;
		if(playWhileZooming){
			currentFrame++;
		}
	
	}
	lastFrame = currentFrame;

	if(isTimeLapse && startZoomAtFrame != 1){
		print("\\Update1:Appending initial frames");
		selectImage(rawID);	
		run("Select None");
		Stack.getDimensions(x, x, nChannels, x, x);
		if(nChannels>1){
			run("Duplicate...","title=prologue duplicate frames=1-"+startZoomAtFrame-1);			
		}else{
			run("Duplicate...","title=prologue duplicate range=1-"+startZoomAtFrame-1);		
		}
			
		run("Scale...", "x=- y=- width="+toString(nFinalW)+" height="+toString(nFinalH)+" interpolation=Bicubic process average create");
			
		close("prologue");		
		if(addScaleBar){
			putScaleBarOn();			
		}
			
		run("Concatenate...", "  title=["+sMovieTitle+"] image1=[prologue-1] image2=["+sMovieTitle+"]");
	}
	
	
	//if it's a time lapse and append remaining frames has been selected, do that
	if(isTimeLapse && appendEpilogue){
		if(lastFrame<totalFrames){	
		
			print("\\Update1:Appending remaining frames");
	 	 	selectImage(rawID);	
		 	offsetX=ddLen*cos(angle);
			offsetY=ddLen*sin(angle);
			newW=newW/zoomStep;
			newH=newH/zoomStep;
			
			run("Specify...", "width="+toString(newW)+" height="+toString(newH)+" x="+toString(offsetX)+" y="+toString(offsetY));
			Stack.getDimensions(x, x, nChannels, x, x);
			if(nChannels>1){
				run("Duplicate...","title=epilogue duplicate frames="+lastFrame+"-"+totalFrames);			
			}else{
				run("Duplicate...","title=epilogue duplicate range="+lastFrame+"-"+totalFrames);		
			}
			
			selectWindow("epilogue");
			
			
			run("Scale...", "x=- y=- width="+toString(nFinalW)+" height="+toString(nFinalH)+" interpolation=Bicubic process average create");
			
			close("epilogue");		
			if(addScaleBar){
				putScaleBarOn();			
			}
			
			run("Concatenate...", "  title=["+sMovieTitle+"] image1=["+sMovieTitle+"] image2=[epilogue-1]");
		}
	}

	//Append static tiles if requested
	if(nFramesLast>0){				
		print("\\Update1:Appending static tiles");
		selectImage(sMovieTitle);
		Stack.getDimensions(blah, blah, blah, blah, nFrames);
		for(n=1;n<=nFramesLast;n++){			
			Stack.setFrame(nFrames);
			Stack.setSlice(nSlices());
			run("Duplicate...","title=staticFrame");				
			run("Concatenate...", "  title=["+sMovieTitle+"] image1=["+sMovieTitle+"] image2=[staticFrame]");			
		}
	}
	setBatchMode(false);
	print("\\Clear");
	print("Done!");
}





function OptionsMenu(){
	
	
  	Dialog.create("Zoom-in parameters:");
	//Dialog.addNumber("Zoom Step (0 to 1)",0.95);
	if(isTimeLapse){
		Dialog.addNumber("How many frames to spend zooming in? (approx)",targetFrame);
		Dialog.setInsets(0, 93, 0)
		Dialog.addCheckbox("Append the remaining frames post-zoom?",true);
		Dialog.addNumber("Start zoom on frame",1);
		Dialog.setInsets(0, 150, 15) 
		Dialog.addCheckbox("Continue playing during zoom",true);
	}else{
		Dialog.addNumber("How many frames to spend zooming in? (approx)",35);
	}
	Dialog.addNumber("Add static number of frames in the end:", 5); 
	minMax=newArray("min","max");
	Dialog.addChoice("_Zoom to min/max ROI size:", minMax); 
	sScaleChoice=newArray("Specified below","same as ROI");
	Dialog.addChoice("Final movie dimensions (px):", sScaleChoice); 
	Dialog.addNumber("_Final movie width:", 512); 
	Dialog.setInsets(10, 170, 0) 
	Dialog.addCheckbox("_Add scalebar:", false);
	Dialog.addNumber("Pixel size, um:", 0.04);
	 
	Dialog.show();
	
	//zoomStep=Dialog.getNumber();
	if(isTimeLapse){
		finalLength = Dialog.getNumber();
		appendEpilogue = Dialog.getCheckbox();
		startZoomAtFrame = Dialog.getNumber();
		playWhileZooming = Dialog.getCheckbox();
	
	}else{
		finalLength = Dialog.getNumber();
	}
	
	nFramesLast=Dialog.getNumber();
	sChoice=Dialog.getChoice();
	sSizeChoice=Dialog.getChoice();
	nFinalW=Dialog.getNumber();
	addScaleBar = Dialog.getCheckbox();
	px=Dialog.getNumber();
}

function makeNextFrame(){
	run("Duplicate...", "title="+sTitle+toString(nScale));
	unscaledID=getImageID();
	run("Scale...", "x=- y=- width="+toString(nFinalW)+" height="+toString(nFinalH)+" interpolation=Bicubic average create");
	scaledID=getImageID();
	selectImage(unscaledID);
	close();
	selectImage(scaledID);
	//run("Enhance Contrast...", "saturated=0.3");
}

function putScaleBarOn(){
	
	trueSize = newW*px;//um

	w = floor(trueSize/2);
	if(w>300){
		width = 300;
	}
	else if(w>100){
		width = 100;
	}
	else if(w>30){
		width = 30;
	}
	else if(w>10){
		width = 10;
	}
	else if(w>3){
		width = 3;
	}
	else {
		width = 1;
	}


	run("Scale Bar...", "width="+width+"  height=8 font=24 color=White background=None location=[Lower Right] bold label");

}

//Global variables - mostly for menu
var	zoomStep=1;
var	nFramesLast=1;
var	sChoice=1;
var	sSizeChoice=1;
var	nFinalW=1;
var	nFinalH=1;
var	addScaleBar = 1;
var	px=1;
var finalLength=1;
var appendEpilogue = true;
var isTimeLapse = false;
var currentFrame=1;
var startZoomAtFrame = 1;
var playWhileZooming = true;

main();