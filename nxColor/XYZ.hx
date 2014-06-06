package nxColor;

/**
 * Class for representing CIE XYZ color and associated useful functions.
 * @author NxT
 */
class XYZ
{
	public var X:Float;
	public var Y:Float;
	public var Z:Float;
	/**
	 * Create a new XYZ Color.
	 * @param	X
	 * @param	Y
	 * @param	Z
	 */
	public function new(X:Float, Y:Float, Z:Float) 
	{
		this.X = X;
		this.Y = Y;
		this.Z = Z;
	}
	
	/**
	 * Return this XYZ color.
	 * @return	This XYZ color.
	 */
	public function toXYZ():XYZ
	{
		return this;
	}
	
	/**
	 * Convert this color to the RGB color space.
	 * @return New RGB color.
	 */
	public function toRGB():RGB
	{
		var xVar:Float = this.X / 100;
		var yVar:Float = this.Y / 100;
		var zVar:Float = this.Z / 100;

		var red:Float = (xVar *  3.2406) + (yVar * -1.5372) + (zVar * -0.4986);
		var green:Float = (xVar * -0.9689) + (yVar *  1.8758) + (zVar * 0.0415);
		var blue:Float = (xVar *  0.0557) + (yVar * -0.2040) + (zVar * 1.0570);
		
		//convert Red
		if (red > 0.0031308)
		{
			red = 1.055 * Math.pow(red,(1/2.4)) - 0.055;
		}
		else 
		{
			red = 12.92 * red;
		}
		
		//convert Green
		if (green > 0.0031308)
		{
			green = 1.055 * Math.pow(green,(1/2.4)) - 0.055;
		}
		else
		{
			green = 12.92 * green;
		}
		
		//convert Blue
		if (blue > 0.0031308)
		{
			blue = 1.055 * Math.pow(blue,(1/2.4)) - 0.055;
		}
		else
		{
			blue = 12.92 * blue;
		}
		
		var R:Int = Math.round(red * 255);
		var G:Int = Math.round(green * 255);
		var B:Int = Math.round(blue * 255);

		return new RGB(R, G, B);
	}
	
	/**
	 * Convert this color to the CIELab color space.
	 * @return New CIELab color.
	 */
	public function toCIELab():CIELab
	{
		var Xn:Float =  95.047;
		var Yn:Float = 100.000;
		var Zn:Float = 108.883;

		var x:Float = this.X / Xn;
		var y:Float = this.Y / Yn;
		var z:Float = this.Z / Zn;

		//convert x
		if (x > 0.008856)
		{
			x = Math.pow(x, 1/3);
		}
		else
		{
			x = (7.787 * x) + (16 / 116);
		}
		
		//convert y
		if (y > 0.008856)
		{
			y = Math.pow(y, 1 / 3);
		}
		else
		{
			y = (7.787 * y) + (16 / 116);
		}
		
		//convert z
		if (z > 0.008856)
		{
			z = Math.pow(z, 1 / 3);
		}
		else
		{
			z = (7.787 * z) + (16 / 116);
		}
		
		var L:Float;
		if (y > 0.008856)
		{
			L = (116 * y) - 16;
		}
		else 
		{
			L = 903.3 * y;
		}
		
		var a:Float = 500 * (x - y);
		var b:Float = 200 * (y - z);

		return new CIELab(L, a, b);
	}
	
	/**
	 * Convert this color to the CIELch color space.
	 * @return New CIELch color.
	 */
	public function toCIELch():CIELch
	{
		return this.toCIELab().toCIELch();
	}
	
	/**
	 * Convert this color to the HSV color space.
	 * @return	New HSV color.
	 */
	public function toHSV():HSV
	{
		return this.toRGB().toHSV();
	}
	
	/**
	 * Function which blends between two colors, including original and target.
	 * @param	n	Total number of steps.
	 * @param	target	Color to blend towards.
	 * @return	Array containing blend.
	 */
	public function blend(n:Int, target:XYZ):Array<XYZ>
	{
		n--;
		var a = new Array<XYZ>();
		var DiffX = (1 / n) * (target.X - this.X);
		var DiffY = (1 / n) * (target.Y - this.Y);
		var DiffZ = (1 / n) * (target.Z - this.Z);
		
		for (i in 0...n)
		{
			a.push(new XYZ(this.X + (i * DiffX), this.Y + (i * DiffY), this.Z + (i * DiffZ)));
		}
		a.push(target);
		
		return a;
	}

	/**
	 * Convert this color to a hex int.
	 * Useful for libraries like HaxeFlixel.
	 * @return	Int in the form 0xAARRGGBB.
	 */
	public function toNumber():Int
	{
		return this.toRGB().toNumber();
	}
}