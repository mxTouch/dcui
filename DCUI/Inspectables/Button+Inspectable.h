//
//  DCUI
//

#import <MPUI/MPUI.h>

@interface Button (Inspectable)
@property(nonatomic,strong) IBInspectable NSString* localizedTitle;
@property(nonatomic,strong) IBInspectable UIColor*  color;
@property(nonatomic,strong) IBInspectable UIColor*  highlightedColor;
@property(nonatomic,strong) IBInspectable UIColor*  selectedColor;
@property(nonatomic,strong) IBInspectable UIColor*  disabledColor;
@end
