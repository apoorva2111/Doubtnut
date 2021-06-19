#ifndef ApxorPlugin_h
#define ApxorPlugin_h
#import "UIKit/UIKit.h"

@protocol ApxorPlugin <NSObject>

-(void) initialize:(NSDictionary *)config;
-(BOOL) start;
-(BOOL) stop;

@end

#endif /* ApxorPlugin_h */
