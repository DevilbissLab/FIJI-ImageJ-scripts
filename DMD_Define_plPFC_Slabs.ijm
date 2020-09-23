//Define PFC slabs
// Dynamically allocates slabs for ROI height
// Use the same data table as plPFC Layers scripts

/*
Layer1_width = 150; //uM
Layer1_height = 1050; //uM
Layer1_xStart = 25; //uM
Layer1_yStart = 25; //uM

Layer2_width = 50; //uM
Layer2_height = 1050; //uM
Layer2_xStart = 225; //uM
Layer2_yStart = 25; //uM

Layer3_width = 250; //uM
Layer3_height = 1050; //uM
Layer3_xStart = 275; //uM
Layer3_yStart = 25; //uM

Layer5_width = 300; //uM - using smaller range, seems to fit better with cyto
Layer5_height = 1050; //uM
Layer5_xStart = 525; //uM
Layer5_yStart = 25; //uM

Layer6_width = 250; //uM
Layer6_height = 1050; //uM
Layer6_xStart = 825; //uM
Layer6_yStart = 25; //uM
 */
getPixelSize(unit, pixelWidth, pixelHeight);
nROIs = roiManager("count");
SlabHeight = 50; //uM

L1_found = 0;
L2_found = 0;
L3_found = 0;
L4_found = 0;
L5_found = 0;
L6_found = 0;

for (i = 0; i < nROIs; i++) {
	roiManager("select", i);
	curName = Roi.getName;
	Roi.getBounds(x, y, width, height)
	
	if (curName == "Layer1"){
		L1_found = 1;
		Layer1_width  = width*pixelWidth; //uM
		Layer1_height = height*pixelHeight; //uM
		Layer1_xStart = x*pixelWidth; //uM
		Layer1_yStart = y*pixelHeight; //uM 
	} else if (L1_found == 0) {
		Layer1_width = 150; //uM
		Layer1_height = 1050; //uM
		Layer1_xStart = 25; //uM
		Layer1_yStart = 25; //uM 
	}

	if (curName == "Layer2"){
		L2_found = 1;
		Layer2_width  = width*pixelWidth; //uM
		Layer2_height = height*pixelHeight; //uM
		Layer2_xStart = x*pixelWidth; //uM
		Layer2_yStart = y*pixelHeight; //uM 
	} else if (L2_found == 0) {
		Layer2_width = 50; //uM
		Layer2_height = 1050; //uM
		Layer2_xStart = 225; //uM
		Layer2_yStart = 25; //uM 
	}

	if (curName == "Layer3"){
		L3_found = 1;
		Layer3_width  = width*pixelWidth; //uM
		Layer3_height = height*pixelHeight; //uM
		Layer3_xStart = x*pixelWidth; //uM
		Layer3_yStart = y*pixelHeight; //uM 
	} else if (L3_found == 0) {
		Layer3_width = 250; //uM
		Layer3_height = 1050; //uM
		Layer3_xStart = 275; //uM
		Layer3_yStart = 25; //uM
	}

	if (curName == "Layer4"){
		L4_found = 1;
		Layer4_width  = width*pixelWidth; //uM
		Layer4_height = height*pixelHeight; //uM
		Layer4_xStart = x*pixelWidth; //uM
		Layer4_yStart = y*pixelHeight; //uM 
	} else if (L4_found == 0) {
		Layer4_width =  1; //uM
		Layer4_height = 1; //uM
		Layer4_xStart = 0; //uM
		Layer4_yStart = 0; //uM
	}

	if (curName == "Layer5"){
		L5_found = 1;
		Layer5_width  = width*pixelWidth; //uM
		Layer5_height = height*pixelHeight; //uM
		Layer5_xStart = x*pixelWidth; //uM
		Layer5_yStart = y*pixelHeight; //uM 
	} else if (L5_found == 0) {
		Layer5_width = 300; //uM - using smaller range, seems to fit better with cyto
		Layer5_height = 1050; //uM
		Layer5_xStart = 525; //uM
		Layer5_yStart = 25; //uM
	}

	if (curName == "Layer6"){
		L6_found = 1;
		Layer6_width  = width*pixelWidth; //uM
		Layer6_height = height*pixelHeight; //uM
		Layer6_xStart = x*pixelWidth; //uM
		Layer6_yStart = y*pixelHeight; //uM 
	} else if (L6_found == 0) {
		Layer6_width = 250; //uM
		Layer6_height = 1050; //uM
		Layer6_xStart = 825; //uM
		Layer6_yStart = 25; //uM
	}	
}

//Print out positions and sizes
if (L1_found == 0) { print("Layer1 not specified"); }else{ 
	print("Layer 1 UL corner (x,y): " + d2s(Layer1_xStart,0) +","+ d2s(Layer1_yStart,0) );
	print("Layer 1 height: " + d2s(Layer1_height,0) );
	print("Layer 1 width: " + d2s(Layer1_width,0) );
	}
if (L2_found == 0) { print("Layer2 not specified");}else{ 
	print("Layer 2 UL corner (x,y): " + d2s(Layer2_xStart,0) +","+ d2s(Layer2_yStart,0));
	print("Layer 2 height: " + d2s(Layer2_height,0));
	print("Layer 2 width: " + d2s(Layer2_width,0));
	}
if (L3_found == 0) { print("Layer3 not specified");}else{ 
	print("Layer 3 UL corner (x,y): " + d2s(Layer3_xStart,0) +","+ d2s(Layer3_yStart,0));
	print("Layer 3 height: " + d2s(Layer3_height,0));
	print("Layer 3 width: " + d2s(Layer3_width,0));
	}
if (L4_found == 0) { print("Layer4 not specified");}else{ 
	print("Layer 4 UL corner (x,y): " + d2s(Layer4_xStart,0) +","+ d2s(Layer4_yStart,0));
	print("Layer 4 height: " + d2s(Layer4_height,0));
	print("Layer 4 width: " + d2s(Layer4_width,0));	
	}
if (L5_found == 0) { print("Layer5 not specified");}else{ 
	print("Layer 5 UL corner (x,y): " + d2s(Layer5_xStart,0) +","+ d2s(Layer5_yStart,0));
	print("Layer 5 height: " + d2s(Layer5_height,0));
	print("Layer 5 width: " + d2s(Layer5_width,0));
	}
if (L6_found == 0) { print("Layer6 not specified");}else{ 
	print("Layer 6 UL corner (x,y): " + d2s(Layer6_xStart,0) +","+ d2s(Layer6_yStart,0));
	print("Layer 6 height: " + d2s(Layer6_height,0));
	print("Layer 6 width: " + d2s(Layer6_width,0));
	}

// Layer 1
for (i = 0; i < floor(Layer1_height/SlabHeight); i++) {
//makeRectangle(Layer1_xStart/pixelWidth, Layer1_yStart/pixelWidth, (Layer1_width/SlabHeight*SlabHeight)/pixelWidth, SlabHeight/pixelWidth );
makeRectangle(Layer1_xStart/pixelWidth, Layer1_yStart/pixelWidth, (floor(Layer1_width/SlabHeight)*SlabHeight)/pixelWidth, SlabHeight/pixelWidth ); //This update makes sure that the slab is n blocks wide. also -1 pixels since there seems to be a bug
Layer1_yStart = Layer1_yStart + SlabHeight;
roiManager("Add");
roiManager("Select", i+nROIs)
roiManager("Rename", "Layer1-Slab_" + d2s(i+1,0));
}

nROIs = roiManager("count");
// Layer 2
for (i = 0; i < floor(Layer2_height/SlabHeight); i++) {
makeRectangle(Layer2_xStart/pixelWidth, Layer2_yStart/pixelWidth, (Layer2_width/SlabHeight*SlabHeight)/pixelWidth, SlabHeight/pixelWidth );
Layer2_yStart = Layer2_yStart + SlabHeight;
roiManager("Add");
roiManager("Select", i+nROIs)
roiManager("Rename", "Layer2-Slab_" + d2s(i+1,0));
}

nROIs = roiManager("count");
// Layer 3
for (i = 0; i < floor(Layer3_height/SlabHeight); i++) {
makeRectangle(Layer3_xStart/pixelWidth, Layer3_yStart/pixelWidth, (Layer3_width/SlabHeight*SlabHeight)/pixelWidth, SlabHeight/pixelWidth );
Layer3_yStart = Layer3_yStart + SlabHeight;
roiManager("Add");
roiManager("Select", i+nROIs)
roiManager("Rename", "Layer3-Slab_" + d2s(i+1,0));
}

nROIs = roiManager("count");
// Layer 5
for (i = 0; i < floor(Layer5_height/SlabHeight); i++) {
makeRectangle(Layer5_xStart/pixelWidth, Layer5_yStart/pixelWidth, (Layer5_width/SlabHeight*SlabHeight)/pixelWidth, SlabHeight/pixelWidth );
Layer5_yStart = Layer5_yStart + SlabHeight;
roiManager("Add");
roiManager("Select", i+nROIs)
roiManager("Rename", "Layer5-Slab_" + d2s(i+1,0));
}

nROIs = roiManager("count");
// Layer 6
for (i = 0; i < floor(Layer6_height/SlabHeight); i++) {
makeRectangle(Layer6_xStart/pixelWidth, Layer6_yStart/pixelWidth, (Layer6_width/SlabHeight*SlabHeight)/pixelWidth, SlabHeight/pixelWidth );
Layer6_yStart = Layer6_yStart + SlabHeight;
roiManager("Add");
roiManager("Select", i+nROIs)
roiManager("Rename", "Layer6-Slab_" + d2s(i+1,0));
}
