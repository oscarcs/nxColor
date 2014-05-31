package nxColor;

/**
 * Class for representing CIELch color and associated useful functions.
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
	 * Convert this color to the XYZ color space.
	 * @return New XYZ color.
	 */
	public function toXYZ():XYZ
	{
		var xReference:Float = 95.047;
		var yReference:Float = 100.000;
		var zReference:Float = 108.883;

		var yVar:Float = (this.L + 16 ) / 116;
		var xVar:Float = this.a / 500 + yVar;
		var zVar:Float = yVar - this.b / 200;
		
		//convert y
		if (Math.pow(yVar,3) > 0.008856){
			yVar = Math.pow(yVar,3);
		}
		else
		{
			yVar = (yVar - 16 / 116) / 7.787;
		}
		//convert x
		if (Math.pow(xVar, 3) > 0.008856)
		{
			xVar = Math.pow(xVar,3);
		}
		else 
		{
			xVar = (xVar - 16 / 116) / 7.787;
		}
		//convert z
		if (Math.pow(zVar, 3) > 0.008856)
		{
			zVar = Math.pow(zVar,3);
		}
		else
		{
			zVar = (zVar - 16 / 116) / 7.787;
		}
		
		var X:Float = xReference * xVar;
		var Y:Float = yReference * yVar;
		var Z:Float = zReference * zVar;
		return new XYZ(X, Y, Z);
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
	public function toNumber():Int
	{
		return this.toRGB().toNumber();
	}
}