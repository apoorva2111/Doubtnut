#import "ApxorSDK/ApxorPlugin.h"
#import "ApxorSDK/APXLogger.h"
#import "ApxorSDK/APXEvent.h"

extern const int kAPXRTAPluginVersion;


@interface UIViewController (APXExtension)

- (NSString *)apxTitle;

@end


@interface APXRTAPlugin : NSObject<ApxorPlugin, APXEventListener>

@property (readwrite) BOOL actionInProgress;
@property (readwrite) NSString *currentScreen;
@property (nonatomic) void (^actionShownCompletionHandler)(NSDictionary *data);
@property (nonatomic) void (^actionDismissedCompletionHandler)(NSDictionary *data);
@property (readwrite) dispatch_queue_t rtaOpsDispatchSerialQueue;

+ (instancetype)sharedInstance;
+ (void)setActionDidShowCompletionHandler:(void (^)(NSDictionary *data))completionHandler;
+ (void)setActionDidDismissCompletionHandler:(void (^)(NSDictionary *data))completionHandler;

- (void)didShowActionWithName:(NSString *)name configID:(NSString *)configId type:(NSString *)type;
- (void)didDismissActionWithName:(NSString *)name configID:(NSString *)configId type:(NSString *)type;
- (void)getViewWithIdentifier:(NSString *)viewId retryTime:(NSInteger)retryTime timeout:(NSInteger)timeout withCompletionHandler:(void(^)(UIView *target)) callback;
- (void)processTerminateInfo:(NSDictionary *)terminateConfig forType:(NSString *)type;

@end
