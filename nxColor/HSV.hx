package nxColor;

/**
 * Class for representing HSV color and associated useful functions.
 * @author Oscar C. S.
 */
class HSV
{
	/**
	 * Hue: 0-360
	 */
	public var H:Float;
	
	/**
	 * Saturation: 0-100
	 */
	public var S:Float;
	
	/**
	 * Value: 0-100
	 */
	public var V:Float;
	
	/**
	 * Create a new HSV color.
	 * @param	H	Hue, ranges from 0 to 360
	 * @param	S	Saturation, ranges from 0 to 100
	 * @param	V	Value, ranges from 0 to 100
	 */
	public function new(H:Float, S:Float, V:Float) 
	{
		this.H = Util.loop(H, 360);
		this.S = S;
		this.V = V;
	}
	
	/**
	 * Return this HSV color.
	 * @return	This HSV color.
	 */
	public function toHSV():HSV
	{
		return new HSV(this.H, this.S, this.V);
	}
	
	/**
	 * Convert this color to the RGB color space.
	 * @return	New RGB color.
	 */
	public function toRGB():RGB
	{
		var H:Float = this.H / 360;
		var S:Float = this.S / 100;
		var V:Float = this.V / 100;
		var R:Float;
		var G:Float;
		var B:Float;
		var hVar:Float, iVar:Float, var1:Float, var2:Float, var3:Float, rVar:Float, gVar:Float, bVar:Float;
		
		if (S == 0) 
		{
			R = V * 255;
			G = V * 255;
			B = V * 255;
		}
		else 
		{
			hVar = H * 6;
			iVar = Math.floor(hVar);
			var1 = V * (1 - S);
			var2 = V * (1 - S * (hVar - iVar));
			var3 = V * (1 - S * (1 - (hVar - iVar)));

			if (iVar == 0) { rVar = V; gVar = var3; bVar = var1; }
			else if (iVar == 1) { rVar = var2; gVar = V; bVar = var1; }
			else if (iVar == 2) { rVar = var1; gVar = V; bVar = var3; }
			else if (iVar == 3) { rVar = var1; gVar = var2; bVar = V; }
			else if (iVar == 4) { rVar = var3; gVar = var1; bVar = V; }
			else { rVar = V; gVar = var1; bVar = var2; };

			R = rVar * 255;
			G = gVar * 255;
			B = bVar * 255;
		}
		return new RGB(R, G, B);
	}

	/**
	 * Convert this color to the XYZ color space.
	 * @return	New XYZ color.
	 */
	public function toXYZ():XYZ
	{
		return this.toRGB().toXYZ();
	}
	
	/**
	 * Convert this color to the CIELch color space.
	 * @return	New CIELch color.
	 */
	public function toCIELch():CIELch
	{
		return this.toRGB().toCIELch();
	}
	
	/**
	 * Convert this color to the CIELab color space.
	 * @return	New CIELab color.
	 */
	public function toCIELab():CIELab
	{
		return this.toRGB().toCIELab();
	}
	
	/**
	 * Convert this color to an int.
	 * @return	Int in the form 0xAARRGGBB.
	 */
	public function toNumber()
	{
		return this.toRGB().toNumber();
	}
	
	/**
	 * Convert this color to a hex string.
	 * @return	Hex in the form RRGGBB.
	 */
	public function toHex():String
	{
		return this.toRGB().toHex();
	}
	
	/**
	 * Function which blends between two colors, including original and target.
	 * @param	n	Total number of steps.
	 * @param	target	Color to blend towards.
	 * @return	Array containing blend.
	 */
	public function blend(n:Int, target:HSV):Array<HSV>
	{
		n--;
		
		if (this.V == 0 || this.V == 100)
		{
			this.H = this.S = 0;
		}
		
		var a = new Array<HSV>();
		//var DiffH = (1 / n) * (target.H - this.H);
		var DiffS = (1 / n) * (target.S - this.S);
		var DiffV = (1 / n) * (target.V - this.V);
		
		var DiffH = target.H - this.H;
		if (DiffH > 180 || DiffH < -180)
		{
			DiffH = Util.loop(360 + DiffH, 360);
		}
		DiffH = (1 / n) * DiffH;
		
		if (this.V == 0 || this.V == 100)
		{
			DiffS = DiffH = 0;
		}
		
		for (i in 0...n)
		{
			a.push(new HSV(Util.loop(this.H + (i * DiffH), 360), this.S + (i * DiffS), this.V + (i * DiffV)));
		}
		if (this.V == 0 || this.V == 100)
		{
			a.push(new HSV(0, this.S + (n * DiffS), this.V + (n * DiffV)));
		}
		else
		{
			a.push(target);	
		}
		
		return a;
	}
	
	/**
	 * Helper function for setting hue. Useful for chaining.
	 * @param	x	Amount of hue.
	 * @return	New HSV color.
	 */
	public function setHue(x:Float):HSV
	{
		x = Util.loop(x, 360);
		return new HSV(x, this.S, this.V);
	}
	
	/**
	 * Helper function for setting saturation. Useful for chaining.
	 * @param	x	Amount of saturation.
	 * @return	New HSV color.
	 */
	public function setSaturation(x:Float):HSV
	{
		if (x > 100)
			x = 100;
		x = Util.loop(x, 100);
		return new HSV(this.H, x, this.V);
	}
	
	/**
	 * Helper function for setting value. Useful for chaining.
	 * @param	x	Amount of value.
	 * @return	New HSV color.
	 */
	public function setValue(x:Float):HSV
	{
		if (x > 100)
			x = 100;
		x = Util.loop(x, 100);
		return new HSV(this.H, this.S, x);
	}
	
	/**
	 * Helper function for getting the hue difference between two HSV colors. Useful for chaining.
	 * @param	x	Color to compare against.
	 * @return	Absolute difference between two hue values.
	 */
	public function getHueDiff(x:HSV):Float
	{
		return Math.abs(this.H - x.H);
	}
	
	/**
	 * Helper function for getting the value difference between two HSV colors. Useful for chaining.
	 * @param	x	Color to compare against.
	 * @return	Absolute difference between two value values.
	 */
	public function getValueDiff(x:HSV):Float
	{
		return Math.abs(this.V - x.V);
	}
}