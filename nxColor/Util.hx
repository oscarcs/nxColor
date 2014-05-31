package nxColor;

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
		var l:Int = 1 + Math.round(length / x.length);
		for (i in 0...x.length)
		{
			if (x[i + 1] != null)
			{
				var b:Array<T> = x[i].blend(l, x[i + 1]);
				trace(b.length);
				a = a.concat(b);
				trace("added " + a.length);
			}
		}
		return a;
	}
	
}