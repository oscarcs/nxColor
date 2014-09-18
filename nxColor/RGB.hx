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
	 * Return this RGB color.
	 * @return	This RGB color.
	 */
	public function toRGB():RGB
	{
		return new RGB(this.R, this.G, this.B);
	}
	
	/**
	 * Convert this color to the XYZ color space.
	 * @return	New XYZ color.
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
	 * @return	New CIELab color.
	 */
	public function toCIELab():CIELab
	{
		return this.toXYZ().toCIELab();
	}
	
	/**
	 * Convert this color to the CIELch color space.
	 * @return	New CIELch color.
	 */
	public function toCIELch():CIELch
	{
		return this.toXYZ().toCIELab().toCIELch();
	}
	
	/**
	 * Convert this color to the HSV color space.
	 * @return	New HSV color.
	 */
	public function toHSV():HSV
	{
		var r:Float, g:Float, b:Float;
		r = this.R / 255;
		g = this.G / 255;
		b = this.B / 255;

		var h:Float, s:Float, v:Float;
		var min:Float, max:Float, delta:Float;

		min = Math.min(r, Math.min(g, b));
		max = Math.max(r, Math.max(g, b));

		v = max;
		delta = max - min;
		
		if (max != 0)
		{
			s = delta / max;
		}
		else
		{
			s = 0;
			h = -1;
			return new HSV(h, s, v);
		}
		
		if (r == max)
		{
			h = (g - b) / delta;
		}
		else if (g == max)
		{
			h = 2 + (b - r) / delta;
		}
		else
		{
			h = 4 + (r - g) / delta;
		}
		
		h *= 60;
		
		if (h < 0)
		{
			h += 360;
		}

		return new HSV(h, s*100, v*100);
	}
	
	public function setRed(r:Float)
	{
		return new RGB(r, this.G, this.B);
	}
	
	public function setGreen(g:Float)
	{
		return new RGB(this.R, g, this.B);
	}
	
	public function setBlue(b:Float)
	{
		return new RGB(this.R, this.G, b);
	}
	
	/**
	 * Convert this color to a hex int.
	 * Useful for libraries like HaxeFlixel.
	 * @return	Int in the form 0xAARRGGBB.
	 */
	public function toNumber()
	{
		var x:String = StringTools.hex(Std.int(this.R), 2) + StringTools.hex(Std.int(this.G), 2) + StringTools.hex(Std.int(this.B), 2);
		return Std.parseInt("0xff" + x);
	}
	
	/**
	 * Convert an int to a color.
	 * @param	x	Int in the form 0xAARRGGBB.
	 * @return	new RGB color.
	 */
	public static function fromNumber(x:Int):RGB
	{
		var cs = StringTools.hex(x, 6);
		
		var r = Std.parseInt("0x" + cs.substr(0, 2));
		var g = Std.parseInt("0x" + cs.substr(2, 2));
		var b = Std.parseInt("0x" + cs.substr(4, 2));
		
		var conv:RGB = new RGB(r, g, b);
		return conv;
	}
	
	
	/**
	 * Convert this color to hexadecimal representation.
	 * @return	Hex string in the form RRGGBB.
	 */
	public function toHex():String
	{
		var x:String = StringTools.hex(Std.int(this.R), 2) + StringTools.hex(Std.int(this.G), 2) + StringTools.hex(Std.int(this.B), 2);
		return x;
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
}