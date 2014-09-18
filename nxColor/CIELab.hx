package nxColor;

/**
 * Class for representing CIELab color and associated useful functions.
 * @author NxT
 */
class CIELab
{
	/**
	 * Lightness: 0-100
	 */
	public var L:Float;
	/**
	 * a Axis: Red to Green
	 */
	public var a:Float;
	/**
	 * b Axis: Blue to Yellow
	 */
	public var b:Float;
	
	/**
	 * Create a new CIELab Color.
	 * @param	L	Lightness, ranges from 0 (black) to 100 (white).
	 * @param	a	a Axis, ranges from -128 (green) to 127 (red).
	 * @param	b	b Axis, ranges from -128 (blue) to 127 (yellow).
	 */
	public function new(L:Float, a:Float, b:Float) 
	{
		this.L = L;
		this.a = a;
		this.b = b;
	}
	
	/**
	 * Return this CIELab color.
	 * @return	This CIELab color.
	 */
	public function toCIELab():CIELab
	{
		return new CIELab(this.L, this.a, this.b);
	}
	
	/**
	 * Convert this color to the CIELch color space.
	 * @return New CIELch color.
	 */
	public function toCIELch():CIELch
	{
		var hue:Float = Math.atan2(this.b, this.a);

		if (hue > 0) 
		{
			hue = (hue / Math.PI) * 180;
		}
		else
		{
			hue = 360 - (Math.abs(hue) / Math.PI) * 180;
		}

		var L:Float = this.L;
		var c:Float = Math.sqrt(Math.pow(this.a,2) + Math.pow(this.b,2));
		var h:Float = hue;

		return new CIELch(L, c, h);
	}
	
	/**
	 * Convert this color to the XYZ color space..
	 * @return New XYZ color.
	 */
	public function toXYZ():XYZ
	{
		var x, y, z;
	
		var xn = 95.047;
		var yn = 100.000;
		var zn = 108.883;
		
		var fy = (this.L  + 16) / 116;
		var fx = fy + (this.a / 500);
		var fz = fy - (this.b / 200);
		
		var delta = 6 / 29;
		var deltaSq = Math.pow(6 / 29, 2);
		
		//Y
		if (fy > delta)
		{
			y = yn * Math.pow(fy, 3);
		}
		else
		{
			y = (fy - 16 / 116) * 3 * deltaSq * yn;
		}
		
		//X
		if (fx > delta)
		{
			x = xn * Math.pow(fx, 3);
		}
		else
		{
			x = (fx - 16 / 116) * 3 * deltaSq * xn;
		}
	
		//Z
		if (fz > delta)
		{
			z = zn * Math.pow(fz, 3);
		}
		else
		{
			z = (fz - 16 / 116) * 3 * deltaSq * zn;
		}
		
		return new XYZ(x, y, z);
	}
	
	/**
	 * Convert this color to the RGB color space.
	 * @return New RGB color.
	 */
	public function toRGB():RGB
	{
		return this.toXYZ().toRGB();
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
	public function blend(n:Int, target:CIELab):Array<CIELab>
	{
		n--;
		var a = new Array<CIELab>();	
		var DiffL = (1 / n) * (target.L - this.L);
		var Diffa = (1 / n) * (target.a - this.a);
		var Diffb = (1 / n) * (target.b - this.b);
		
		for (i in 0...n)
		{
			a.push(new CIELab(this.L + (i * DiffL), this.a + (i * Diffa), this.b + (i * Diffb)));
		}
		a.push(target);
		
		return a;
	}

	/**
	 * Convert this color to a hex int.
	 * Useful for libraries like HaxeFlixel.
	 * @return	Int in the form 0xAARRGGBB.
	 */
	public function toNumber()
	{
		return this.toRGB().toNumber();
	}
	
	/**
	 * Convert this color to hexadecimal representation.
	 * @return	Hex in the form RRGGBB.
	 */
	public function toHex():String
	{
		return this.toRGB().toHex();
	}
}