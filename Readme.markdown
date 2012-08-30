# AJProgressPanel

__Animated progress panel__

- No images needed, all CoreGraphics code
- Works on iPhone and iPad (resolution independent)


![AJProgressPanel](https://raw.github.com/ajerez/AJProgressPanel/master/screenshot_1.png)


## Example Usage

Add __QuartzCore.framework__ and drop the __AJProgressPanel__ folder in your project



``` objetive-c
//Default style
AJProgressPanel *panel = [AJProgressPanel showInView:self.view]; //show
//...Your code...
[panel setProgress:0.6f animated:YES]; //change progress
//...Your code...
[panel hideAnimated:YES]; //hide
```



``` objective-c
// Custom
AJProgressPanel *panel2 = [AJProgressPanel showInView:self.secondView position:AJPanelPositionBottom];
panel2.enableShadow = NO;
panel2.startGradientColor = [UIColor colorWithWhite:0.35f alpha:1.0f];
panel2.endGradientColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
panel2.stripesColor = [UIColor colorWithRed:40.0f/255 green:140.0f/255 blue:193.0f/255 alpha:1.0f];
panel2.progressColor = [UIColor colorWithRed:50.0f/255 green:170.0f/255 blue:193.0f/255 alpha:0.7f];
//...Your code...
[panel2 setProgress:0.4f animated:YES]; //change progress
//...Your code...
[panel2 hideAnimated:YES]; //hide
```




## Future improvements

* Code rafactoring
* Fix animation stop in `setProgress`

## Contact
Twitter: [@alberto_jrz](https://twitter.com/alberto_jrz)

## License - MIT


Copyright (c) 2012 Alberto Jerez - [CodeApps](http://www.codeapps.es/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
