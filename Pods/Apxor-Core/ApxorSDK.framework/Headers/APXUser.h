#import <Foundation/Foundation.h>
#import "CommonProtocols.h"
#import "APXInfo.h"
#import "APXEvent.h"

@interface APXUser : APXInfo
-(void) setUserAttribute:(id)value forKey:(NSString *)key;
-(NSDictionary*) userAttributes;

@end
