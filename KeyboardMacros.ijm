// macro for ImageJ Keyboard shortcuts
// David Devilbiss
//
// Note that keyboard shortcuts will not work unless the macros are installed and the "ImageJ" window, or an image window, is the active 
// (front) window and has keyboard focus. You install macros using the macro editor's Macros>Install Macros command or the 
// Plugins>Macros>Install command. Install the two macros in the above example and you will see that the commands
//
//    Macro 1 [a]
//    Macro 2 [1]
//get added to Plugins>Macros submenu. Save these macros in a file named "StartupMacros.txt" in the macros folder and ImageJ will
//automatically install them when it starts up. Function keys ([f1], [f2]...[f12]) and numeric keypad keys ([n0], [n1]..[n9],
//[n/], [n*], [n-], [n+] or [n.]) can also be used for shortcuts.
//
// Also see https://imagej.nih.gov/ij/docs/shortcuts.html

//Notes: Rotate image until midline is verticle
//		crop image to midline and include all ROI's
//		Press the space bar to Temporarily switch to the "hand" (scrolling) tool
//
// macro for ImageJ Keyboard shortcuts
// David Devilbiss
// Macro Definitions
//
//      SetBoxValues [S] - Opens dialog to specify values in plPFC or OFC extraction boxes
//		RunAnalysis [R] - runs the imaging processing macro (maynot work if path is not correct)
//
//		SetScale [n.] - Opens dialog to set the scale pixels per uM scale
//		RemoveBox [n0] - Used to Clear the box on the screen 
//		OpenFile [n1] - Use this to Open Files for processing (stores important file information)
//		ExtractPlPFC [n4] - Macro to extract image from box and save in directory
//		ExtractOlPFC [n5] - Macro to extract image from box and save in directory
//		CropImage [n8] - Used to crop image (usually after rotating left or right)
//		RotateRight [n9]
//		RotateLeft [n7]
//		MakeGrid [n*]
//		RemoveGrid [n/]

var dir = "";
var FileTitle = "";
var def_plPFC_DV = 2.3; // 3 mm
var def_plPFC_ML = 0; // 0 mm
var def_plPFC_width = 1.1; // 0 mm
var def_plPFC_height = 1.1; // 0 mm
var def_olPFC_DV = 3.7; // 3 mm
var def_olPFC_ML = 2.25; // 0 mm
var def_olPFC_width = 1.1; // 0 mm
var def_olPFC_height = 1.1; // 0 mm
//
var plPFC_DV = def_plPFC_DV;
var plPFC_ML = def_plPFC_ML;
var plPFC_width = def_plPFC_width;
var plPFC_height = def_plPFC_height;
var olPFC_DV = def_olPFC_DV;
var olPFC_ML = def_olPFC_ML;
var olPFC_width = def_olPFC_width;
var olPFC_height = def_olPFC_height;


macro "Macro SetBoxValues [S]" {
	//Create dialog box
	Dialog.create("Enter the Box Locations ( Upper Left Corner - mm)");
	Dialog.addNumber("plPFC DV:", plPFC_DV);
	Dialog.addNumber("plPFC ML:", plPFC_ML);
	Dialog.addNumber("olPFC DV:", olPFC_DV);
	Dialog.addNumber("olPFC ML:", olPFC_ML);
	Dialog.addCheckbox("Reset Values",false);
	Dialog.show();
	temp_plPFC_DV = Dialog.getNumber();
	temp_plPFC_ML = Dialog.getNumber();
	temp_olPFC_DV = Dialog.getNumber();
	temp_olPFC_ML = Dialog.getNumber();
	reset_ck = Dialog.getCheckbox();

    if (reset_ck) {
    	    plPFC_DV = def_plPFC_DV;
    	    plPFC_ML = def_plPFC_ML;
    	    plPFC_width = def_plPFC_width;
    	    plPFC_height = def_plPFC_height;
    	    olPFC_DV = def_olPFC_DV;
    	    olPFC_ML = def_olPFC_ML;
    	    olPFC_width = def_olPFC_width;
    	    olPFC_height = def_olPFC_height;    
    	} else {
			plPFC_DV = temp_plPFC_DV;
			plPFC_ML = temp_plPFC_ML;
			olPFC_DV = temp_olPFC_DV;
			olPFC_ML = temp_olPFC_ML;
    	}
}

macro "Macro Rotate90 [1]" {
	    print("Rotate the Image Clockwise 90 Degrees");
        //run("Select None");
		run("Rotate 90 Degrees Right");
}

macro "Macro OpenFile [n1]" {
		print("______________________________________");
		run("Get_Time");
		print("Fiji/ImageJ version: " + getVersion());
        print("Opening File");
        run("Open...");
        dir = getDirectory("image");
		FileName=getTitle;
		FileTitle = "";
		
		// get nice file name
		dot = indexOf(FileName, ".");
		if (dot >= 0) {
			FileTitle = substring(FileName, 0, dot);
		}
    }

macro "Macro SetScale [n.]" {
		getPixelSize(unit, pixelWidth, pixelHeight);
		print("Current Unit: "+ unit +" Current px Width: "+ pixelWidth);
		CalValue = 1/pixelHeight;
		// UI to get pixel value
		PxSize = getString("Enter calibration value (px/um): //", CalValue);
		PxUnit = getString("Enter calibration unit (e.g. micron): //", unit);
		run("Set Scale...", "distance="+ PxSize + " known=1 pixel=1 unit="+ PxUnit +" global");
		getPixelSize(unit, pixelWidth, pixelHeight);
        print("Setting Calibration to "+ PxSize +" pixels/"+ unit);
        print("New Unit: "+ unit +" New px Width: "+ pixelWidth);
        //run("Set Scale...", "distance=58 known=100 pixel=1 unit=um");
    }

macro "Macro RotateRight [n9]" {
        print("Rotate the Image Clockwise 0.5 Degrees");
        run("Select None");
		run("Rotate... ", "angle=0.5 grid=1 interpolation=None");
    }

macro "Macro RotateLeft [n7]" {
        print("Rotate the Image Counterclockwise 0.5 Degrees");
        run("Select None");
		run("Rotate... ", "angle=-0.5 grid=1 interpolation=None");
    } 

macro "Macro MakeGrid [n*]" {
		// area is in um and is calculated from the global calibration
        //print("Create 100x100 uM Grid");
        //run("Grid...", "grid=Lines area=10000 color=Cyan");
        print("Create 50x50 uM Grid");
        run("Grid...", "grid=Lines area=2500 color=Magenta");
        //run("Grid...", "grid=Lines area=5000 color=Magenta"); // use for images mTBI 
    }

macro "Macro RemoveGrid [n/]" {
        print("Removing Grid");
        run("Remove Overlay");
    } 

macro "Macro CropImage [n8]" {
        print("Croping Image");
        run("Crop");
        IJ.redirectErrorMessages();
        //run("Stack to RGB");
        close("\\Others")
    } 

macro "Macro RemoveBox [n0]" {
		print("Removing Selection");
        run("Select None");
    }

macro "Macro RunAnalysis [R]" {
		print("Running DMD_Image Processing");
        runMacro("D:/Team Drives/Software Repository/Git_Repository/ImageJ/DMD_Image Processing.ijm")
    }

macro "Macro ExtractPlPFC [n4]" {
	    run("Select None");
		print("Extracting plPFC");

		//Create output folder
		OutputDir = dir + "plPFC";
    	File.makeDirectory(OutputDir);
    	if (!File.exists(OutputDir)) {
    	    exit("Unable to create directory");
    	} else {
			//prints values just to check in the log
			print("Created: " + OutputDir);
    	}
        imageTitle=getTitle();//returns a string with the image title
        run("Duplicate...", "title=" + FileTitle + "_plPFC.tif");
        getPixelSize(unit, pixelWidth, pixelHeight);
        CalValue = 1/pixelHeight;
		px_plPFC_DV = 1000*plPFC_DV*CalValue;
		px_plPFC_ML = 1000*plPFC_ML*CalValue;
		px_plPFC_width = 1000*plPFC_width*CalValue;
		px_plPFC_height = 1000*plPFC_height*CalValue;
		print("Making Rectangle (um): " + plPFC_width +"(W) x " + plPFC_height + "(H) at " + plPFC_DV + "(DV) x " + plPFC_ML +"(ML)");
		print("Making Rectangle (px): " + px_plPFC_width +"(W) x " + px_plPFC_height + "(H) at " + px_plPFC_DV + "(DV) x " + px_plPFC_ML +"(ML)");
        makeRectangle(px_plPFC_ML, px_plPFC_DV, px_plPFC_width, px_plPFC_height);
        //makeRectangle(0*pixelWidth, 1184*pixelWidth, 1576*pixelWidth, 1328*pixelWidth);
        //makeRectangle(x, y, width, height)
        //The x and y arguments are the coordinates (in pixels) 
        run("Crop");
        print("Saving to: " + OutputDir + File.separator + FileTitle +"_plPFC.tif" );
        saveAs("Tiff", OutputDir + File.separator + FileTitle +"_plPFC.tif");
        //Redraw window for validation
        selectWindow(imageTitle);
        //makeRectangle(0*pixelWidth, 1184*pixelWidth, 1576*pixelWidth, 1328*pixelWidth);
        makeRectangle(px_plPFC_ML, px_plPFC_DV, px_plPFC_width, px_plPFC_height);
    }

macro "Macro ExtractOlPFC [n5]" {
		run("Select None");
		print("Extracting olPFC");
//		dir = getDirectory("image");
//		FileName=getTitle;
//		FileTitle = "";
//		
//		// get nice file name
//		dot = indexOf(FileName, ".");
//		if (dot >= 0) {
//			FileTitle = substring(FileName, 0, dot);
//		}

		//Create output folder
		OutputDir = dir + "olPFC";
    	File.makeDirectory(OutputDir);
    	if (!File.exists(OutputDir)) {
    	    exit("Unable to create directory");
    	} else {
			//prints values just to check in the log
			print("Created: " + OutputDir);
    	}
        imageTitle=getTitle();//returns a string with the image title
        run("Duplicate...", "title=" + FileTitle + "_olPFC.tif");
        getPixelSize(unit, pixelWidth, pixelHeight);
        CalValue = 1/pixelHeight;
		px_olPFC_DV = 1000*olPFC_DV*CalValue;
		px_olPFC_ML = 1000*olPFC_ML*CalValue;
		px_olPFC_width = 1000*olPFC_width*CalValue;
		px_olPFC_height = 1000*olPFC_height*CalValue;
		print("Making Rectangle (um): " + olPFC_width +"(W) x " + olPFC_height + "(H) at " + olPFC_DV + "(DV) x " + olPFC_ML +"(ML)");
		print("Making Rectangle (px): " + px_olPFC_width +"(W) x " + px_olPFC_height + "(H) at " + px_olPFC_DV + "(DV) x " + px_olPFC_ML +"(ML)");
        makeRectangle(px_olPFC_ML, px_olPFC_DV, px_olPFC_width, px_olPFC_height);
        //makeRectangle(0*pixelWidth, 608*pixelWidth, 788*pixelWidth, 680*pixelWidth); in pixels
        //makeRectangle(0*pixelWidth, 1184*pixelWidth, 1576*pixelWidth, 1328*pixelWidth);
        //makeRectangle(x, y, width, height)
        //The x and y arguments are the coordinates (in pixels) 
        run("Crop");
        print("Saving to: " + OutputDir + File.separator + FileTitle +"_olPFC.tif" );
        saveAs("Tiff", OutputDir + File.separator + FileTitle +"_olPFC.tif");
        //Redraw window for validation
        selectWindow(imageTitle);
        //makeRectangle(0*pixelWidth, 1184*pixelWidth, 1576*pixelWidth, 1328*pixelWidth);
        makeRectangle(px_olPFC_ML, px_olPFC_DV, px_olPFC_width, px_olPFC_height);
    }

  macro "Get_Time" {
     MonthNames = newArray("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
     DayNames = newArray("Sun", "Mon","Tue","Wed","Thu","Fri","Sat");
     getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
     TimeString ="Date: "+DayNames[dayOfWeek]+" ";
     if (dayOfMonth<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+dayOfMonth+"-"+MonthNames[month]+"-"+year+"\nTime: ";
     if (hour<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+hour+":";
     if (minute<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+minute+":";
     if (second<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+second;
     print(TimeString);
  	}
    