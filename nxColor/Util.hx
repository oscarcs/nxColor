package nxColor;

import nxColor.*;

/**
 * Utility class for miscellaneous color manipulation.
 * @author NxT
 */
typedef CanBlend =
{
	function blend(n:Int, target:Dynamic):Dynamic;
}
 
class Util
{
	public function new()
	{
		
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
	
	/* Under construction!
	public function randomBlendRatio(start:Dynamic, end:Dynamic, length:Int):Array<Dynamic>
	{
		var a:Array<Dynamic> = start.blend(Std.int(length / 2), end);
		var x = Std.random(a.length - 1);
		var b:Array<Dynamic> = start.blend(Std.int(length / 2), a[x]);
		var c:Array<Dynamic> = a[x].blend(Std.int(length / 2), end);
		a = b.concat(c);
		return a;
	}
	*/
	
	/**
	 * Blend between an arbitrary number of colors in an array.
	 * @param	x	Array of colors to blend between.
	 * @param	length	Number of colors to have in the final array (currently inaccurate!)
	 * @return	new array containing final blend.
	 */
	public static function blendMultiple<T:(CanBlend)>(x:Array<T>, length:Int):Array<T>
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
		x = x.toHSV().setHue(180 + Std.random(210)).setSaturation(Std.random(25) + 60).setValue(90 + Std.random(10)).toCIELab();
		
		var y:CIELab = new CIELab(0, 0, 0);
		y = y.toHSV().setHue(180 + Std.random(210)).setSaturation(Std.random(25) + 60).setValue(90 + Std.random(10)).toCIELab();
		
		//juggle the colors a little; probably unnecessary, but w/e. 
		while (y.toHSV().getHueDiff(x.toHSV()) > 100 && y.toHSV().getValueDiff(x.toHSV()) > 5)
		{
			y = y.toHSV().setHue(180 + Std.random(210)).setSaturation(Std.random(25) + 60).setValue(90 + Std.random(10)).toCIELab();
		}
		
		if (x.toHSV().V < y.toHSV().V)
		{
			x = x.toHSV().setValue(y.toHSV().V - 10).toCIELab();
			trace("l");
		}

		a = x.blend(n, y);
		return a;
	}
	
}