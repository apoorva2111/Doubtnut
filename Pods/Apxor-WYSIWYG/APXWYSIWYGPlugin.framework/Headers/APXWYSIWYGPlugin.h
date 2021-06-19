#import <UIKit/UIKit.h>
#import "ApxorSDK/ApxorPlugin.h"

extern const int kWYSIWYGPluginVersion;

@interface APXWYSIWYGPlugin : NSObject<ApxorPlugin, APXEventListener>

+ (instancetype)sharedInstance;
- (void)selectScreenTapped;
- (void)addAsTestDevice;
- (void)removeTestDevice;

@end
