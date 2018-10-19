//Fiji/ImageJ macro for analyzing axonal density in low magnification sections
//David Devilbiss
//Version 0.1 2018May30
//
//Depends on the following toolboxes:
//
//
//
// Inspired by: 

//Set constants and variables
nFiles = NaN;

run("Clear Results");
if  (isOpen("Summary")) {
	close("Summary");
	//run("Close");
}

//Open a directory of files to process
DataDir = getDirectory("Choose the image directory for analysis");
FileList = getFileList(DataDir);
//prints values just to check in the log
print("Processing: " + DataDir);

//remove subdir links
for (i = FileList.length; i > 0; i--) {
	//DEBUG - print(DataDir + FileList[i-1]);
	if (File.isDirectory(DataDir + FileList[i-1])) {
		if (i == FileList.length) {
			//this is the last element so do not cat post list
			FileList = Array.slice(FileList, 0, i-1);
		} else if (i == 0) {
			//this is the first element in the list
			FileList = Array.slice(FileList, i);
		} else { 
			preList = Array.slice(FileList, 0, i-1);
			postList = Array.slice(FileList, i);
			FileList =Array.concat(preList ,postList);
		}	
	}
}
nFiles = FileList.length;

// UI to get axon channel
AxonColor = getString("enter the color of your axons(r,b,g): //", "r");

//Create dialog box
PxSize = 1;
PxUnit = "micron";
Dialog.create("Enter the ImageJ scale for these images (px/um)");
Dialog.addNumber("Pixel Size:", PxSize);
Dialog.addString("Unit (e.g. micron):", PxUnit);
Dialog.show();
PxSize = Dialog.getNumber();
PxUnit = Dialog.getString();

//Create output folder
OutputDir = DataDir + "Traced_Images";
    File.makeDirectory(OutputDir);
    if (!File.exists(OutputDir)) {
        exit("Unable to create directory");
    } else {
		//prints values just to check in the log
		print("Created: " + OutputDir);
    }
    
//Process images
for (curFile = 0; curFile < nFiles; curFile++) {
	run("Clear Results");
	open(DataDir + FileList[curFile]);
	// get nice file name
	dot = indexOf(FileList[curFile], ".");
	if (dot >= 0) {
		FileTitle = substring(FileList[curFile], 0, dot);
	}
	//wait(25);
	run("Set Scale...", "distance="+ PxSize + " known=1 pixel=1 unit="+ PxUnit +" global");
    //run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
    // Since this is 1 then all "calculations" are worthless. 
    // add dialog box for user input https://imagej.nih.gov/ij/macros/DialogDemo.txt
    

	//may choose to temp rename so easier to manage channels
	run("Split Channels");
        if (AxonColor == "r") {
            close();
            close();
        }
        if (AxonColor == "g") {
            close();
            close("\\Others"); //all images except the front image are closed.
        }
        if (AxonColor == "b") {
            close("\\Others"); //all images except the front image are closed.
        }

  	rename("MonoImage");
	run("Duplicate...", "title=EnhancedContrast");
	//v1
    //run("Subtract Background...", "rolling=50 sliding disable");
    //run("Enhance Contrast...", "saturated=0.3 normalize");
	//v1.1
	getPixelSize(unit, pixelWidth, pixelHeight);
    run("Subtract Background...", "rolling="+ 10/pixelWidth +" sliding disable"); //Normalize for pixel size (total 10um)
    run("Enhance Contrast...", "saturated=0.3 normalize");

	run("Ridge Detection", "line_width=5 high_contrast=230 low_contrast=87 make_binary method_for_overlap_resolution=NONE sigma=1.8 lower_threshold=1.51 upper_threshold=7.99 minimum_line_length=5 maximum=0");
	//run("Ridge Detection", "line_width=3.5 high_contrast=230 low_contrast=87 make_binary method_for_overlap_resolution=NONE sigma=1.8 lower_threshold=1.51 upper_threshold=7.99 minimum_line_length=5 maximum=0");
	run("Invert LUT");
	rename("Fibers");
	run("Duplicate...", "title=" + FileList[curFile]);
	run("Analyze Particles...", "  show=Masks display exclude summarize");
	// selects skeleton and measures it
	run("Create Selection");
	run("Measure");

	// save images in folder
	if (AxonColor == "r") {
	run("Merge Channels...", "c1=MonoImage c5=EnhancedContrast c7=Fibers create"); //create adds it as a segmented image
	}
    if (AxonColor == "g") {
    	run("Merge Channels...", "c2=MonoImage c5=EnhancedContrast c7=Fibers create"); //create adds it as a segmented image
    }
    if (AxonColor == "b") {
    	run("Merge Channels...", "c3=MonoImage c5=EnhancedContrast c7=Fibers create"); //create adds it as a segmented image
    }
	//run("Merge Channels...", "c1=MonoImage c5=EnhancedContrast c7=Fibers");
	saveAs("Tiff", OutputDir + File.separator + FileTitle +"_labeled.tif");
	//close("*Detected segments");
	
	//save individual image calculations
	saveAs("Results", OutputDir + File.separator + FileTitle + "_TracingData.xls");
	close("*");
	
}
    //Organizes axon data
  selectWindow("Summary");
  saveAs("Text", OutputDir + File.separator + "TracingSummary.xls");

  if  (isOpen("Results")) {
	close("Results");
	//run("Close");
}
  