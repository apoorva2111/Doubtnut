#import <Foundation/Foundation.h>
#import "ApxorSDK/ApxorPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface APXContextEvaluator : NSObject<ApxorPlugin>

@property (readwrite) dispatch_queue_t ceOpsSerialQueue;

+ (instancetype)sharedInstance;
- (void)parseConfiguration:(NSDictionary*)configuration;
- (void)updateCountForConfigWithIdentifier:(NSString *)identifier;
- (NSString*)replaceMacros:(NSString*)text;

@end

NS_ASSUME_NONNULL_END
