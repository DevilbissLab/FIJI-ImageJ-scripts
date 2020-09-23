/*Makes grid based on multi-purpose grid from Gundersen & Jensen
(J Microsc. 1987, 147:229-6) for stereological quantification as
non-destructive overlay.

Based on 
Version: 1.0
Date: 04/09/2014
Author: Aleksandr Mironov amj-box@mail.ru
Author: Theresa Swayne, tcs6@cumc.columbia.edu, 2016
*/
/*
 * Modified by DMD to be scriptable and only include the necessarry functions
 */
dimensions = "by_area_per_point";
getPixelSize(unit, pw, ph, pd);
//Grid offset
GridOffset = 1;

//grid parameters
offset = false; //Random Offset
new = true; //New Overlay
t = 1; //line thickness (1 px)
//dimens = 2500; // 50 uM - area per point
dimens = 625; // 25 uM - area per point
circ = false; //Encircled Points
dense = false; //Dense_Points_x4
rpcolor = "white"; //Regular points color
dpcolor = "orange"; //Dense_points_color
hor_seg = true; //Horizontal segmented
ver_seg = true; //Vertical segmented
hor_sol = false; //Horizontal solid (x3 of segmented)
ver_sol= false; //Vertical solid (x3 of segmented)
lcolor = "cyan"; //Line_color

//initial settings for l/p
vsg=hsg=vsl=hsl=0;

//tile size
getDimensions(width, height, channels, slices, frames);
if (dimensions=="by_tiles_density") {
	if (width>=height) {
	ss = height;
	} else {
	ss = width;
	}
	tileside = ss/dimens;
	}else {
	tileside = sqrt(4*dimens/ph/pw);
	}
pointd = tileside/4;
pointr = tileside/2;

//check overlay
if (new == true) Overlay.remove;

//creating random offset
off1 = random;
off2 = random;
if (offset == false) off1 = off2 = GridOffset;
xoff = round(pointd*off1);
yoff = round(pointd*off2);

setColor(lcolor);
setLineWidth(t);

//Horizonal solid lines
if (hor_sol == true){
	y = yoff;
	while (true && y<height) {
		Overlay.drawLine(0, y, width, y);
		Overlay.add;
		y += pointr;
		}
	Overlay.show;
	hsl = 2;
	}

//Vertical solid lines
if (ver_sol == true){
	x = xoff;
	while (true && x<width) {
		Overlay.drawLine(x, 0, x, height);
		Overlay.add;
		x += pointr;
		}
	Overlay.show;
	vsl = 2;
	}

//Horizonal segmented lines
if (hor_seg == true){
hsg = 1;

//Y loop1
y1 = yoff;
while (y1<height) {

		//X loop1
		x1 = xoff;
		while (x1<width) {
			Overlay.drawLine(x1, y1, x1+pointr, y1);
			Overlay.add;
			x1 += tileside;
		}
	Overlay.show;
	y1 += tileside;
	}

//Y loop2
y1 = yoff+pointr;
while (y1<height) {

		//X loop2
		x2 = xoff;
		x1 = 0;
		while (x1<width) {
			Overlay.drawLine(x1, y1, x2, y1);
			Overlay.add;
			x1 = x2 + pointr;
			x2 += tileside;
		}
	Overlay.show;
	y1 += tileside;
	}
}

//Vertical segmented lines
if (ver_seg == true){
vsg = 1;

//X loop1
x1 = xoff;
while (x1<width) {

		//Y loop1
		y1 = yoff;
		while (y1<height) {
			Overlay.drawLine(x1, y1, x1, y1+pointr);
			Overlay.add;
			y1 += tileside;
		}
	Overlay.show;
	x1 += tileside;
	}

//X loop2
x1 = xoff+pointr;
while (x1<width) {

		//Y loop2
		y2 = yoff;
		y1 = 0;
		while (y1<height) {
			Overlay.drawLine(x1, y1, x1, y2);
			Overlay.add;
			y1 = y2 + pointr;
			y2 += tileside;
		}
	Overlay.show;
	x1 += tileside;
	}
}

 //Regular points

setColor(rpcolor);
//Initial coordinates X
x1 = xoff;
x2 = x1 - pointd/16;
x3 = x1 + pointd/16;

//X loop
while (x1<width) {

		//initial coordinates Y
		y1 = yoff;
		y2 = y1 - pointd/16;
		y3 = y1 + pointd/16;

		//Y loop
		while (y1<height) {

			//horizontal line
			Overlay.drawLine(x2,y1,x3,y1);
			Overlay.add;
			//vertical line
			Overlay.drawLine(x1,y2,x1,y3);
			Overlay.add;
		y1 += pointr;
		y2 += pointr;
		y3 += pointr;
		}
	Overlay.show;
	x1 += pointr;
	x2 += pointr;
	x3 += pointr;
	}

//Dense points
setColor(dpcolor);
if (dense == true){
	//Initial coordinates X;
	x1 = xoff - pointd/2;
	x2 = x1 - pointd/16;
	x3 = x1 + pointd/16;

	//X loop
	while (x1<width) {

		//initial coordinates Y
		y1 = yoff - pointd/2;
		y2 = y1 - pointd/16;
		y3 = y1 + pointd/16;

		//Y loop
		while (y1<height) {
			//horizontal line
			Overlay.drawLine(x2,y1,x3,y1);
			Overlay.add;
			//vertical line
			Overlay.drawLine(x1,y2,x1,y3);
			Overlay.add;
		y1 += pointd;
		y2 += pointd;
		y3 += pointd;
		}
	Overlay.show;
	x1 += pointd;
	x2 += pointd;
	x3 += pointd;
	}
}

//Encircled points
setColor(lcolor);
if (circ == true){

	//Initial coordinates X
	x1 = xoff;
	x2 = x1 - pointd/16;

	//X loop
	while (x2<width) {

		//Initial coordinates Y
		y1 = yoff;
		y2 = y1 - pointd/16;

		//Y loop
		while (y2<height) {
			Overlay.drawEllipse(x2, y2, pointd/8, pointd/8);
			Overlay.add;
		y2 += tileside;
		}
	Overlay.show;
	x2 += tileside;
	}
}