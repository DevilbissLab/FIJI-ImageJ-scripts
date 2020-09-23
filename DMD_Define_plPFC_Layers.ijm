// This is all in pixels not microns !!
// see Gabbott:
//Prefrontal cortex in the rat: Projections to subcortical autonomic, motor, and limbic centers
//https://dx.doi.org/10.1002/cne.20738

getPixelSize(unit, pixelWidth, pixelHeight);
top_offset = 25; //uM

Layer1_offset = 25; //uM
Layer1_width = 150; //uM
Layer1_height = 1050; //uM

Layer2_offset = 225; //uM
Layer2_width = 50; //uM
Layer2_height = 1050; //uM

Layer3_offset = 275; //uM
Layer3_width = 250; //uM
Layer3_height = 1050; //uM

Layer5_offset = 525; //uM
Layer5_width = 300; //uM - using smaller range, seems to fit better with cyto
Layer5_height = 1050; //uM

Layer6_offset = 825; //uM
Layer6_width = 250; //uM
Layer6_height = 1050; //uM

//Layer 1
makeRectangle(Layer1_offset/pixelWidth, top_offset/pixelWidth, Layer1_width/pixelWidth, Layer1_height/pixelWidth);
roiManager("Add");
roiManager("Select", 0)
roiManager("Rename", "Layer1");

makeRectangle(Layer2_offset/pixelWidth, top_offset/pixelWidth, Layer2_width/pixelWidth, Layer2_height/pixelWidth);
roiManager("Add");
roiManager("Select", 1)
roiManager("Rename", "Layer2");

makeRectangle(Layer3_offset/pixelWidth, top_offset/pixelWidth, Layer3_width/pixelWidth, Layer3_height/pixelWidth);
roiManager("Add");
roiManager("Select", 2)
roiManager("Rename", "Layer3");

//no Layer 4 in PFC

makeRectangle(Layer5_offset/pixelWidth, top_offset/pixelWidth, Layer5_width/pixelWidth, Layer5_height/pixelWidth);
roiManager("Add");
roiManager("Select", 3)
roiManager("Rename", "Layer5");

makeRectangle(Layer6_offset/pixelWidth, top_offset/pixelWidth, Layer6_width/pixelWidth, Layer6_height/pixelWidth);
roiManager("Add");
roiManager("Select", 4)
roiManager("Rename", "Layer6");