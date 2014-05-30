package nxColor;

/**
 * Class for representing RGB color and associated useful functions.
 * @author NxT
 */
class RGB
{
	/**
	 * Red: 0-255
	 */
	public var R:Float;
	/**
	 * Green: 0-255
	 */
	public var G:Float;
	/**
	 * Blue: 0-255
	 */
	public var B:Float;
	
	/**
	 * Create a new RGB color.
	 * @param	R	Red, ranges from 0 to 255
	 * @param	G	Green, ranges from 0 to 255
	 * @param	B	Blue, ranges from 0 to 255
	 */
	public function new(R:Float, G:Float, B:Float) 
	{
		this.R = Math.min(255,Math.max(R,0));
		this.G = Math.min(255,Math.max(G,0));
		this.B = Math.min(255,Math.max(B,0));
	}
	
	/**
	 * Convert this color to the XYZ color space.
	 * @return New XYZ color.
	 */
	public function toXYZ():XYZ
	{
		var red:Float = this.R / 255;
		var green:Float = this.G / 255;
		var blue:Float = this.B / 255;
		
		//convert red
		if (red > 0.04045) 
		{
			red = Math.pow(((red + 0.055) / 1.055), 2.4);
		}
		else
		{
			red = red / 12.92;
		}
		
		//convert green
		if (green > 0.04045) 
		{
			green = Math.pow(((green + 0.055) / 1.055), 2.4);
		}
		else
		{
			green = green / 12.92;
		}
		
		//convert blue
		if (blue > 0.04045)
		{
			blue = Math.pow(((blue + 0.055) / 1.055), 2.4);
		}
		else
		{
			blue = blue / 12.92;
		}
		
		red = red * 100;
		green = green * 100;
		blue = blue * 100;
		
		var X:Float = red * 0.4124 + green * 0.3576 + blue * 0.1805;
		var Y:Float = red * 0.2126 + green * 0.7152 + blue * 0.0722;
		var Z:Float = red * 0.0193 + green * 0.1192 + blue * 0.9505;
		
		return new XYZ(X,Y,Z);
	}
	
	/**
	 * Convert this color to the CIELab color space.
	 * @return New CIELab color.
	 */
	public function toCIELab():CIELab
	{
		return this.toXYZ().toCIELab();
	}
	
	/**
	 * Convert this color to the CIELch color space.
	 * @return New CIELch color.
	 */
	public function toCIELch():CIELch
	{
		return this.toXYZ().toCIELab().toCIELch();
	}
	
	/**
	 * Function which blends between two colors, including original and target.
	 * @param	n	Total number of steps.
	 * @param	target	Color to blend towards.
	 * @return	Array containing blend.
	 */
	public function blend(n:Int, target:RGB):Array<RGB>
	{
		n--;
		var a = new Array<RGB>();
		var DiffR = (1 / n) * (target.R - this.R);
		var DiffG = (1 / n) * (target.G - this.G);
		var DiffB = (1 / n) * (target.B - this.B);
		
		for (i in 0...n)
		{
			a.push(new RGB(this.R + (i * DiffR), this.G + (i * DiffG), this.B + (i * DiffB)));
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
		var x:String = StringTools.hex(Std.int(this.R), 2) + StringTools.hex(Std.int(this.G), 2) + StringTools.hex(Std.int(this.B), 2);
		return Std.parseInt("0xff" + x);
	}
	
}