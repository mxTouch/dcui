//
//  DCUI
//

#import <MPUI/MPUI.h>

@interface UINavigationController(NavigationInspectable)
@property(nonatomic,assign) IBInspectable BOOL      useNavigationRules;
@end

@interface UIViewController(NavigationInspectable)
@property(nonatomic,strong) IBInspectable UIColor*  navigationBarTintColor;
@property(nonatomic,assign) IBInspectable BOOL      clearBackButtonTitle;
@property(nonatomic,assign) IBInspectable BOOL      navigationBarHidden;
@property(nonatomic,assign) IBInspectable BOOL      navigationBarCleared;
@end
