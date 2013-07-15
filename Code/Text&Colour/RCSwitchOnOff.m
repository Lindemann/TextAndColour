/*
 Copyright (c) 2010 Robert Chin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "RCSwitchOnOff.h"


@implementation RCSwitchOnOff

- (void)initCommon
{
	[super initCommon];
	onText = [UILabel new];
	onText.text = @"ON";
	onText.textColor = [UIColor whiteColor];
    onText.font = [UIFont systemFontOfSize:14];
	onText.shadowColor = [UIColor colorWithRed:0.47f green:0.44f blue:0.70f alpha:1.00f];
    onText.shadowOffset = CGSizeMake(0, -1);
	
	offText = [UILabel new];
	offText.text = @"OFF";
    offText.textColor = [UIColor whiteColor];
	offText.font = [UIFont systemFontOfSize:14];
    offText.shadowColor = [UIColor colorWithRed:0.56f green:0.60f blue:0.61f alpha:1.00f];
    offText.shadowOffset = CGSizeMake(0, -1);
	
}


- (void)drawUnderlayersInRect:(CGRect)aRect withOffset:(float)offset inTrackWidth:(float)trackWidth {
    
    int ON_OFFSET_X = - 2;
    int ON_OFFSET_Y = 10;
    
    int OFF_OFFSET_X = 19;
    int OFF_OFFSET_Y = 10;
    
	{
        // ON
		CGRect textRect = [self bounds];
        textRect.size = CGSizeMake(63, 23);
		textRect.origin.x += 14.0 + (offset - trackWidth) + ON_OFFSET_X;
        textRect.origin.y = textRect.origin.y + ON_OFFSET_Y;
		[onText drawTextInRect:textRect];	
	}
	
	{
        // OFF
		CGRect textRect = [self bounds];
        textRect.size = CGSizeMake(63, 23);
		textRect.origin.x += (offset + trackWidth) - 12.0 + OFF_OFFSET_X;
        textRect.origin.y = textRect.origin.y + OFF_OFFSET_Y;
		[offText drawTextInRect:textRect];
	}	
}

@end
