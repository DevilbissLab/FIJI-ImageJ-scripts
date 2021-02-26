// DMD_Image Manuscript Processing (i.e. partial process images to use in manuscripts)
curPath = getDir("file")
print("Current Macro Path: " + curPath);

//Set constants and variables
nFiles = NaN;
run("Set Measurements...", "area mean bounding shape display redirect=None decimal=5");
print("Running DMD_Image Manuscript Processing");


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
OutputDir = DataDir + "Enhanced_Images_forManuscript";
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

// Process in the same way as DMD_Image Processing
	getPixelSize(unit, pixelWidth, pixelHeight);
    run("Subtract Background...", "rolling="+ 10/pixelWidth +" sliding disable"); //Normalize for pixel size (total 10um)
    run("Enhance Contrast...", "saturated=0.3 normalize");

	saveAs("Tiff", OutputDir + File.separator + FileTitle +"_Enhanced4Manuscript.tif");
	close("*");
}

	