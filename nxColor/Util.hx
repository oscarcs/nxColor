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
	 * Create a palette distributed using the golden ratio.
	 * See http://gamedev.stackexchange.com/a/46469 for an explanation.
	 * Noe that this is not the optimum method for distributing color, however.
	 * @param	length
	 * @param	saturation
	 * @param	value
	 * @return	Array of HSV colors.
	 */
	public static function goldenRatio(length:Int, saturation:Float, value:Float):Array<HSV>
	{
		var a:Array<HSV> = [];
		saturation = loop(saturation, 100);
		value = loop(value, 100);
		
		var golden = 1/((1 + Math.sqrt(5)) / 2);
		trace(golden + " GOLDEN");
		
		var r = Std.random(360);
		for (i in 0...length)
		{
			a.push(new HSV((360 * i * golden) + r, saturation, value));
			trace(a[i].H);
		}
		return a;
	}
	
	/**
	 * Display a color as it would appear to someone who is green-colorblind.
	 * @param	color
	 * @return
	 */
	public static function testGreenBlindness(color:IsColor):Dynamic
	{
		var rgb = color.toRGB();
		rgb.R = Math.pow(rgb.R, 2.2);
		rgb.G = Math.pow(rgb.G, 2.2);
		rgb.B = Math.pow(rgb.B, 2.2);
		
		var R = Math.pow(0.02138 + (0.677 * rgb.G) + (0.2802 * rgb.R), 1 / 2.2);
		var B = Math.pow(0.02138 * (1 + rgb.G - rgb.R) + (0.9572 * rgb.B), 1 / 2.2);
		
		var adjusted = new RGB(R, R, B);
		return makeType(adjusted, color);
	}
	
	/**
	 * Display a color as it would appear to someone who is red-colorblind.
	 * @param	color
	 * @return
	 */
	public static function testRedBlindness(color:IsColor):Dynamic
	{
		var rgb = color.toRGB();
		rgb.R = Math.pow(rgb.R, 2.2);
		rgb.G = Math.pow(rgb.G, 2.2);
		rgb.B = Math.pow(rgb.B, 2.2);
		
		var R = Math.pow(0.003974 + (0.8806 * rgb.G) + (0.1115 * rgb.R), 1 / 2.2);
		var B = Math.pow(0.003974 * (1 - rgb.G + rgb.R) + (0.9921 * rgb.B), 1 / 2.2);
		
		var adjusted = new RGB(R, R, B);
		return makeType(adjusted, color);
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
	 * Set a value to loop through a set length.
	 * @param	x	Value to loop.
	 * @param	length	length of the loop (e.g. 360 degrees).
	 * @return	New looped x value
	 */
	public static function loop(x:Float, length:Float):Float
	{ 
		if (x < 0)
			x = length + x % length;

		if (x >= length)
			x %= length;
		return x;
	}
		
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