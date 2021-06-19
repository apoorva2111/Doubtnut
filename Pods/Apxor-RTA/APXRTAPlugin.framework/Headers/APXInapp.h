#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ApxorSDK/ApxorPlugin.h"
#import "ApxorSDK/APXEvent.h"
@import WebKit;

@interface APXInapp : NSObject

+ (instancetype)sharedInstance;
- (void)buildAndShowInAppWithUIConfig:(NSDictionary *)config;
- (void)willDismiss;

@end

@interface APXWebView : WKWebView<WKNavigationDelegate>
-(void)setUpConfig:(NSDictionary*)configuration;
@end
