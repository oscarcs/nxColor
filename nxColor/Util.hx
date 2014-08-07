package nxColor;

import nxColor.*;

/**
 * Utility class for miscellaneous color manipulation.
 * @author NxT
 */
typedef IsColor =
{
	function blend(n:Int, target:Dynamic):Dynamic;
	function toHSV():HSV;
	function toRGB():RGB;
	function toXYZ():XYZ;
	function toCIELch():CIELch;
	function toCIELab():CIELab;
	function toHex():String;
}
 /**
  * Singleton-style class of useful color functions.
  */
class Util
{
	/**
	 * Gets the complementary / inverse color. 
	 * @param	color
	 * @return	Complementary color.
	 */
	public static function getInverse(color:IsColor)
	{
		var rgb:RGB = color.toRGB();
		rgb.R = 255 - rgb.R;
		rgb.G = 255 - rgb.G;
		rgb.B = 255 - rgb.B;
		var x = makeType(rgb, color);
		return x;
	}
	
	/**
	 * Create an array of colors with equally spaced hues.
	 * @param	color
	 * @param	vertices
	 * @param	Lch	If true, use CIELch; else use HSV.
	 * @return
	 */
	public static function makePolygonal(color:IsColor, vertices:Int, ?Lch:Bool = false):Array<Dynamic>
	{
		var space:Dynamic;
		var hue:Float;
		if (Lch == true)
		{
			space = color.toCIELch();
			hue = space.h;
			trace("k");
		}
		else
		{
			space = color.toHSV();
			hue = space.H;
		}
		var a = new Array<Dynamic>();
		var r = 360 / vertices;
		a.push(color);
		for (i in 0...(vertices-1))
		{
			a.push(makeType(space.setHue(hue + (r * (i + 1))), color));
			//a.push(
		}
		return a;
	}
	
	/**
	 * Set a value to loop through a set length.
	 * @param	x	Value to loop.
	 * @param	length	length of the loop (e.g. 360 degrees).
	 * @return	New looped x value
	 */
	public static function loop(x:Float, length:Float):Float {
	if (x < 0)
		x = length + x % length;

	if (x >= length)
		x %= length;
	return x;
	}
	
	/**
	 * Blend between an arbitrary number of colors in an array.
	 * @param	x	Array of colors to blend between.
	 * @param	length	Number of colors to have in the final array (not perfectly accurate)
	 * @return	new array containing final blend.
	 */
	public static function blendMultiple<T:IsColor>(x:Array<T>, length:Int):Array<T>
	{
		var a:Array<T> = new Array<T>();
		var b:Array<T> = new Array<T>();
		var l:Int = Math.round(length / (x.length - 1));
		for (i in 0...x.length)
		{
			if (x[i + 1] != null)
			{
				b = x[i].blend(l, x[i + 1]);
				a = a.concat(b);
			}
		}
		return a;
	}
	
	/**
	 * Function to do fancy interpolation between colors that could be used as a sky, in CIELab space.
	 * @param	n	Length of the final array.
	 * @return	new Array of CIELab colors.
	 */
	public static function makeSky(n:Int):Array<CIELab>
	{
		var a:Array<CIELab> = new Array<CIELab>();
		
		var x:CIELab = new CIELab(0, 0, 0);
		x = x.toHSV().setHue(180 + randomFloat(210, 5)).setSaturation(randomFloat(25, 5) + 60).setValue(90 + randomFloat(10, 5)).toCIELab();
		
		var y:CIELab = new CIELab(0, 0, 0);
		y = y.toHSV().setHue(180 + randomFloat(210,5)).setSaturation(randomFloat(25, 5) + 60).setValue(90 + randomFloat(10, 5)).toCIELab();
		
		//juggle the colors a little; probably unnecessary, but w/e. 
		while (y.toHSV().getHueDiff(x.toHSV()) > 100 && y.toHSV().getValueDiff(x.toHSV()) > 5)
		{
			y = y.toHSV().setHue(180 + randomFloat(210, 5)).setSaturation(randomFloat(25,5) + 60).setValue(90 + randomFloat(10, 5)).toCIELab();
		}
		
		if (x.toHSV().V < y.toHSV().V)
		{
			x = x.toHSV().setValue(y.toHSV().V - 10).toCIELab();
			trace("l");
		}

		a = x.blend(n, y);
		return a;
	}
	
	/*
	public static function makeDaytime()
	{
		var a = new Array<CIELab>();
		var x = new CIELab(randomFloat(40, 2) + 60, randomFloat(80, 2) - 20 , randomFloat(70, 2) - 128);
		//x = x.toHSV().setSaturation(x.toHSV().S - Std.random(70)).toCIELab();
		if (x.toHSV().V > 95) { x = x.toHSV().setValue(x.toHSV().V - 20).toCIELab(); } 
		//trace(x.toHSV());
		a.push(x);
		var q = a[0];
		return q;
	}
	
	public static function makeTransition()
	{
		
	}
	
	public static function makeNighttime()
	{
		
	}
	*/
		
	/**
	 * Function that returns a random Float to a certain number of decimal places.
	 * @param	x	Integer maximum, not inclusive.
	 * @param	decimalPlaces	Number of decimal places to return.
	 * @return	New random Float.
	 */
	private static function randomFloat(x:Int, decimalPlaces:Int):Float
	{
		var z:Int = Std.int(Math.pow(10, decimalPlaces));
		var y = Std.random(x * z);
		var a = y / z;
		return a;
	}
	
	/**
	 * Helper function to make color x the same type as color y.
	 * @param	x	Color to modify and return.
	 * @param	y	Reference color.
	 * @return	x converted to type of y.
	 */
	public static function makeType(x:IsColor, y:IsColor):Dynamic
	{
		if (Std.is(y, CIELab))
		{
			return x.toCIELab();
		}
		
		else if (Std.is(y, CIELch))
		{
			return x.toCIELch();
		}
		
		else if (Std.is(y, HSV))
		{
			return x.toHSV();
		}
		
		else if (Std.is(y, RGB))
		{
			return x.toRGB();
		}

		else if (Std.is(y, XYZ))
		{
			return x.toXYZ();
		}
		
		else
		{
			return null;
		}
	}
	
}