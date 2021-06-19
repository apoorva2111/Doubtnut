#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@protocol APXCoachMarkProtocol <NSObject>

-(void)willDismiss;
-(void)willRedirectToVc:(NSString *)identifier;

@end

@interface APXCoachMarkHelper : NSObject<APXCoachMarkProtocol,UIGestureRecognizerDelegate>

+(instancetype)sharedHelper;
- (void)buildAndShowCoachMarkWithUIConfig:(NSDictionary *)config;
- (void)buttonClickedWithTitle:(NSString*)title;
- (void)cancelWalkthrough;
- (void)targetViewTapped;

@end

