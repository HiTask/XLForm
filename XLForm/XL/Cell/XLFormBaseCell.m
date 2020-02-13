//
//  XLFormBaseCell.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLFormBaseCell.h"


@implementation XLFormBaseCell

@synthesize nativeTitleColor = _nativeTitleColor;
@synthesize nativeTitleDisabledColor = _nativeTitleDisabledColor;
@synthesize nativeDetailColor = _nativeDetailColor;

@synthesize nativeTitleFont = _nativeTitleFont;
@synthesize nativeDetailFont = _nativeDetailFont;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		[self setDefaultNativeLabelProperties];
        [self configure];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
	[self setDefaultNativeLabelProperties];
    [self configure];
	
}

- (void)setDefaultNativeLabelProperties
{
	_nativeTitleColor = [UIColor blackColor];
	_nativeTitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	_nativeDetailFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (void)configure
{
	_nativeTitleColor = [UIColor grayColor];
}

- (void)update
{
	[self updateCellAppearance];
}

- (void)updateCellAppearance {
	UIFont *titleFont;
	UIFont *detailFont;
	if (@available(iOS 11.0, *)) {
		titleFont = [[UIFontMetrics metricsForTextStyle:UIFontTextStyleTitle2] scaledFontForFont:self.nativeTitleFont];
		detailFont = [[UIFontMetrics metricsForTextStyle:UIFontTextStyleTitle3] scaledFontForFont:self.nativeDetailFont];
	} else {
		titleFont = self.nativeTitleFont;
		detailFont = self.nativeDetailFont;
	}
	self.textLabel.font = titleFont;
	self.textLabel.adjustsFontForContentSizeCategory = YES;
	
	self.detailTextLabel.font = detailFont;
	self.detailTextLabel.adjustsFontForContentSizeCategory = YES;
	
	self.detailTextLabel.textColor = self.nativeDetailColor;
	
	if (self.rowDescriptor != nil && self.rowDescriptor.isDisabled && self.nativeTitleDisabledColor != nil) {
		self.textLabel.textColor = self.nativeTitleDisabledColor;
	} else {
		self.textLabel.textColor = self.nativeTitleColor;
	}
}

-(void)highlight
{
}

-(void)unhighlight
{
}

-(XLFormViewController *)formViewController
{
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[XLFormViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

- (void)setNativeTitleColor:(UIColor *)color UI_APPEARANCE_SELECTOR {
	_nativeTitleColor = color;
	[self updateCellAppearance];
}

- (UIColor *)nativeTitleColor {
	return _nativeTitleColor;
}

- (void)setNativeTitleDisabledColor:(UIColor *)color UI_APPEARANCE_SELECTOR {
	_nativeTitleDisabledColor = color;
	[self updateCellAppearance];
}

- (UIColor *)nativeTitleDisabledColor {
	return _nativeTitleDisabledColor;
}

- (void)setNativeDetailColor:(UIColor *)color UI_APPEARANCE_SELECTOR {
	_nativeDetailColor = color;
	[self updateCellAppearance];
}

- (UIColor *)nativeDetailColor {
	return _nativeDetailColor;
}

- (void)setNativeTitleFont:(UIFont *)font UI_APPEARANCE_SELECTOR {
	_nativeTitleFont = font;
	[self updateCellAppearance];
}

- (UIFont *)nativeTitleFont {
	return _nativeTitleFont;
}

- (void)setNativeDetailFont:(UIFont *)font UI_APPEARANCE_SELECTOR {
	_nativeDetailFont = font;
	[self updateCellAppearance];
}

- (UIFont *)nativeDetailFont {
	return _nativeDetailFont;
}

- (void)updateFormRow {
	if (self.formViewController != nil && self.rowDescriptor != nil) {
		[self.formViewController updateFormRow:self.rowDescriptor];
	}
}

#pragma mark - Navigation Between Fields

-(UIView *)inputAccessoryView
{
    UIView * inputAccessoryView = [self.formViewController inputAccessoryViewForRowDescriptor:self.rowDescriptor];
    if (inputAccessoryView){
        return inputAccessoryView;
    }
    return [super inputAccessoryView];
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return NO;
}

#pragma mark -

-(BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    if (result){
        [self.formViewController beginEditing:self.rowDescriptor];
    }
    return result;
}

-(BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    if (result){
        [self.formViewController endEditing:self.rowDescriptor];
    }
    return result;
}

@end
