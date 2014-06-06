nxColor
=======

Color manipulation library written in Haxe, currently very WIP. Feel free to contribute or [hit me up on Twitter](http://twitter.com/ocsims) for feature requests, ideas, etc.

Currently supports CIELch, CIELab, XYZ, RGB, and HSB color spaces, and will convert between them.
The focus of this library is palette creation for game development.

#### Usage:

Presently, I haven't put nxColor on Haxelib because it isn't feature-complete enough.
You can just pull the library off GitHub for now.

nxColor supports (and is essentially focussed on!) chaining between color spaces like so:
````haxe
//blend two RGB colors through the CIELab color space.
var a = new RGB(119, 158, 255).toCIELab().blend(50, new RGB(255, 61, 0).toCIELab());
````

You can access special functions in the 'Util' class.
makeSky() returns an array of CIELab colors that resemble 'sky-like' blends, limited to certain color ranges.
````haxe
var a = a = Util.makeSky(48);
````

#### Planned Features:
- Addition of more color spaces. (CMYK, etc.)
- Code examples.
- Addition of helper functions ('Sky' generation already in);
- Addition of more 'blend' types.
- Other useful color manipulation functions.
- Code cleanup / refactor.

#### License:
````
The MIT License

Copyright © 2014 Oscar Sims, @ocsims.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
````


