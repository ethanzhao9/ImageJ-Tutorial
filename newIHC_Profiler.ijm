// This macro has been developed to calculate the number of pixels of
// different color intensities and based on that it plots a histogram
// profile and assigns a grade to the image. 
// Modiied by Ethan Zhao
// First, do Color Deconvolution to seperate the channel to be analyzed
// Then, run this macro to get the results

title = getTitle();
print(title);

  Region2=0;
  Region3=0;
  Region4=0;
  Region1=0;
  Region0=0;
  TotalPixel=0;
  PercentRegion1=0;
  PercentRegion2=0;
  PercentRegion4=0;
  PercentRegion3=0;
  PercentRegion0=0;
  bins = 256;
  maxCount = 0;
  histMin = 0;
  histMax = 0;

  if (histMax>0)
  	getHistogram(values, counts, bins, histMin, histMax);
  else
  	getHistogram(values, counts, bins);

  min = 9999999;
  max = -9999999;

  for (i=0; i<bins; i++) 
	{
         count = counts[i];
         if (count>0) 
		{
          	 n += count;
          	 sum += count*i;
          	 if (i<min) min = i;
          	 if (i>max) max = i;
                }
  	}


	 for (i=0; i<bins; i++)
		{
	         if (i>=0 && i<61)
	   	      Region4=Region4+counts[i];
	 	 if (i>60 && i<121)	
          	      Region3=Region3+counts[i];
	  	 if (i>120 && i<181)	
          	      Region2=Region2+counts[i];
	  	 if (i>180 && i<236)	
          	      Region1=Region1+counts[i];
          	 if (i>235 && i<=256)	
          	      Region0=Region0+counts[i];
  		}
  		
  		  TotalPixel=TotalPixel+Region1+Region2+Region3+Region4+Region0;
  
  PixelUnderConsideration=TotalPixel-Region0;
  
  PercentRegion3=(Region3/PixelUnderConsideration)*100; 
  
  PercentRegion2=(Region2/PixelUnderConsideration)*100;
  
  PercentRegion1=(Region1/PixelUnderConsideration)*100;
  
  PercentRegion4=(Region4/PixelUnderConsideration)*100;
  
  print("Percentage contibution of High Positive:  "+PercentRegion4);
  
  print("Percentage contibution of Positive:  "+PercentRegion3);
  
  print("Percentage contibution of Low Positive:  "+PercentRegion2);

  print("Percentage contibution of Negative:  "+PercentRegion1);

