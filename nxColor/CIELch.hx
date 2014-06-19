package nxColor;

import nxColor.*;

/**
 * Class for representing CIELch color and associated useful functions.
 * @author NxT
 */
class CIELch
{
	/**
	 * Lightness: 0-100
	 */
	public var L:Float;
	/**
	 * Chroma: 0-100
	 */
	public var c:Float;
	/**
	 * Hue: 0-360 degrees
	 */
	public var h:Float;
	
	/**
	 * Create a new CIELch color.
	 * @param	L	Lightness, ranges from 0 (black) to 100 (white).
	 * @param	c	Chroma, ranges from 0 (desaturated) to 100 (pure color).
	 * @param	h	Hue, ranges from 0 to 360 degrees.
	 */
	public function new(L:Float, c:Float, h:Float) 
	{
		this.L = L;
		this.c = c;
		this.h = h<360?h:(h-360);
	}
	
	/**
	 * Return this CIELch color.
	 * @return	This CIELch color.
	 */
	public function toCIELch():CIELch
	{
		return new CIELch(this.L, this.c, this.h);
	}
	
	/**
	 * Convert this color to the CIELab color space.
	 * @return New CIELab color.
	 */
	public function toCIELab():CIELab
	{
		var L:Float = this.L;
		var hradi:Float = this.h * (Math.PI/180);
		var a:Float = Math.cos(hradi) * this.c;
		var b:Float = Math.sin(hradi) * this.c;
		return new CIELab(L,a,b);
	}
	
	/**
	 * Convert this color to the XYZ color space.
	 * @return New XYZ color.
	 */
	public function toXYZ():XYZ
	{
		return this.toCIELab().toXYZ();
	}
	
	/**
	 * Convert this color to the RGB color space.
	 * @return New RGB color.
	 */
	public function toRGB():RGB
	{
		return this.toCIELab().toRGB();
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
	 * @return	Array containting blend.
	 */
	public function blend(n:Int, target:CIELch):Array<CIELch>
	{
		n--;
		var a = new Array<CIELch>();
		var DiffL = (1 / n) * (target.L - this.L);
		var Diffc = (1 / n) * (target.c - this.c);
		var Diffh = (1 / n) * (target.h - this.h);
				
		for (i in 0...n)
		{
			a.push(new CIELch(this.L + (i * DiffL), this.c + (i * Diffc), this.h + (i * Diffh)));
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