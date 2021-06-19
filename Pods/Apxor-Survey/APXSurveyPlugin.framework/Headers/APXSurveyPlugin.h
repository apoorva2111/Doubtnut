#import <Foundation/Foundation.h>
#import "ApxorSDK/ApxorPlugin.h"
#import "ApxorSDK/APXEvent.h"


@protocol SurveyProtocol <NSObject>

-(void) willShowSurvey;
-(void) willDismissSurvey;

@end

@interface APXSurveyPlugin :NSObject<ApxorPlugin,SurveyProtocol,APXEventListener>

@end

