//Fiji/ImageJ macro for analyzing axonal density in stitched high magnification sections
//David Devilbiss
//Version 0.1 2018May30
//Version 0.2 2018Nov18
//Version 0.3 2018Dec06 - altered ridge detection threshold
//
//Depends on the following toolboxes:
//
//Requires: 
//
// Inspired by: 

// ToDo:
// Define PFC Slabs needs to aquire ROI data not assume

//This file directorys path
//curPath = "G:/Team Drives/Software Repository/Git_Repository/ImageJ";
//print("Current Macro Path: " + curPath);
curPath = getDir("file")
if (File.exists(curPath + File.separator + "DMD_Define_plPFC_Layers.ijm") == false) {
	tPath = "H:\\Shared drives\\Software Repository\\Git_Repository\\ImageJ\\DMD_Define_plPFC_Layers.ijm";
	if (File.exists(tPath) == false) {
		print("Macro Path not found: " + tPath);
		curPath = getDirectory("Choose the current macros directory.");
	} else {
		curPath = "H:\\Shared drives\\Software Repository\\Git_Repository\\ImageJ\\";
	}
}
print("Current Macro Path: " + curPath);

//Set constants and variables
nFiles = NaN;
run("Set Measurements...", "area mean bounding shape display redirect=None decimal=5");
print("Running DMD_Image Processing");

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

//Create dialog box UI to get axon channel
Dialog.create("Enter Image analysis information.");
Dialog.addString("Axon color to analyze (e.g. r,g,b):", "g");
Dialog.addCheckbox("Use Unbiased Stereology", true);
Dialog.addCheckbox("Accept Default ROIs", false);
Dialog.addCheckbox("Enhance Contrast THEN Subtract Bkgnd.", false);
Dialog.addString("Ridge Detection Upper Thresh (default = 3):", "3");
Dialog.show();
AxonColor = Dialog.getString();
doStereology = Dialog.getCheckbox();
acceptROIs = Dialog.getCheckbox();
ContrastFirst = Dialog.getCheckbox();
Ridge_UT = Dialog.getString();

//Create dialog box
PxSize = 1.324713862; // good place to start for Keyance images
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
	roiManager("reset");

	print("     Opening: " + FileList[curFile]);
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

	//Allow User to update ROIs
	if (doStereology == true) {
	ID = getImageID();
	print("Running DMD_Define_plPFC_Layers");
    runMacro(curPath + File.separator + "DMD_Define_plPFC_Layers.ijm");
    if (acceptROIs != true){
    title = "Wait For User to Select ROIs";
    msg = "If necessary, use the \"ROI Manager\" tool to\nadjust the ROIs, then click \"OK\".";
    waitForUser(title, msg);
    selectImage(ID);  //make sure we still have the same image
    // We may need to extract these ROIs for later
    }
	}

	
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
	if (ContrastFirst == false) {
    run("Subtract Background...", "rolling="+ 10/pixelWidth +" sliding disable"); //Normalize for pixel size (total 10um)
    run("Enhance Contrast...", "saturated=0.3 normalize");
	} else {
	run("Enhance Contrast...", "saturated=0.3 normalize");
    run("Subtract Background...", "rolling="+ 10/pixelWidth +" sliding disable"); //Normalize for pixel size (total 10um)
	print("Running Contrast THEN Background");	
	}

    print("Running Ridge Detection");
	run("Ridge Detection", "line_width=5 high_contrast=230 low_contrast=87 extend_line make_binary method_for_overlap_resolution=NONE sigma=1.8 lower_threshold=1.51 upper_threshold="+ Ridge_UT +" minimum_line_length=5 maximum=0");
	//run("Ridge Detection", "line_width=5 high_contrast=230 low_contrast=87 extend_line make_binary method_for_overlap_resolution=NONE minimum_line_length=5 maximum=0");

	// version 1 //run("Ridge Detection", "line_width=5 high_contrast=230 low_contrast=87 make_binary method_for_overlap_resolution=NONE sigma=1.8 lower_threshold=1.51 upper_threshold=7.99 minimum_line_length=5 maximum=0");
	//run("Ridge Detection", "line_width=3.5 high_contrast=230 low_contrast=87 make_binary method_for_overlap_resolution=NONE sigma=1.8 lower_threshold=1.51 upper_threshold=7.99 minimum_line_length=5 maximum=0");
	run("Invert LUT");
	rename("Fibers");

if (doStereology == true) {
// fiber crossing method
// First make grid and combine with fibers ("AND" operation) then threshold only the crossings
run("Duplicate...", "title=Grid");
run("Multiply...", "value=0.00000");

print("Running DMD_Multipurpose_gridMod");
runMacro(curPath + File.separator + "DMD_Multipurpose_grid.ijm");
//runMacro("H:/Team Drives/Software Repository/Git_Repository/ImageJ/TSW_Multipurpose_gridMod.ijm", "set=by_area_per_point new line=1 area=2500 regular=cyan dense_0=green horizontal vertical line_0=cyan");
//runMacro("H:/Team Drives/Software Repository/Git_Repository/ImageJ/TSW_Multipurpose_gridMod.ijm");
run("Flatten");
run("8-bit");
run("Merge Channels...", "c1=Grid-1 c2=Fibers keep ignore");
run("8-bit");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(127, 255);
setOption("BlackBackground", false);
run("Convert to Mask");
rename("Box_Crossings");

// Loop through ROIs
// this will be an AND operation between layer ROIs and 50 uM grids
//ROI manager
run("Set Scale...", "distance="+ PxSize + " known=1 pixel=1 unit="+ PxUnit +" global");
print("Running DMD_Define_plPFC_Slabs");
runMacro(curPath + File.separator + "DMD_Define_plPFC_Slabs.ijm");
// we now have all the ROIs

setOption("ExpandableArrays", true);
DataLabel = newArray;
for (i = 0; i < roiManager("count"); i++){
roiManager("Select", i);
run("Analyze Particles...", "size=0-2 clear summarize");
//DMD note: 1-4 particle size does capture more. Howoever for the paper we used 0-2 to underestimate. The logic was we wanted fiber crossings not fibers running with the staircase.
//run("Analyze Particles...", "size=0-2 display clear summarize");
//error catch because may have no data
DataLabel[i] = Roi.getName;
//DataLabel[i] = getResultLabel(0);
}
selectWindow("Summary");
IJ.renameResults("Summary","Results");
for (i=0; i<nResults; i++) {
//setResult("Label", i, DataLabel[i]);
setResult("Slice", i, DataLabel[i]);
//
// now that all slabs are counted, then save out to file.
}

// do stereology 
} else {

// all fiber method (original)
	run("Duplicate...", "title=" + FileList[curFile]);
	run("Analyze Particles...", "  show=Masks display exclude summarize");
	// selects skeleton and measures it
	run("Create Selection");
	run("Measure");
} //end doStereology

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
    // add ROIs to image
	if (doStereology == true) {
		run("Set Scale...", "distance="+ PxSize + " known=1 pixel=1 unit="+ PxUnit +" global");
		roiManager("Show All");
		runMacro(curPath + File.separator + "DMD_Multipurpose_grid.ijm");
		run("Flatten");
		roiManager("Show All");
		run("Flatten");
	}

	//run("Merge Channels...", "c1=MonoImage c5=EnhancedContrast c7=Fibers");
	saveAs("Tiff", OutputDir + File.separator + FileTitle +"_labeled.tif");
	//close("*Detected segments");
	
	//save individual image calculations
	if (doStereology == true) {
	saveAs("Results", OutputDir + File.separator + FileTitle + "_SterologyData.xls");
	} else {
	saveAs("Results", OutputDir + File.separator + FileTitle + "_TracingData.xls");
	}
	close("*");	
}
    //Organizes axon data
    if (doStereology == false) {
  	selectWindow("Summary");
  	saveAs("Text", OutputDir + File.separator + "TracingSummary.xls");
    }

if  (isOpen("Results")) {
	close("Results");
	//run("Close");
}
  