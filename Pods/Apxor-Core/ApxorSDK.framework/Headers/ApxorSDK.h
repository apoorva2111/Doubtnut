#import <UIKit/UIKit.h>


// SDK interface
@interface ApxorSDK : NSObject

//Public API
+ (void)initializeApxorWithID:(NSString *_Nonnull)appId;
+ (void)setUserIdentifier:(NSString * __nonnull)identifier;
+ (void)logScreenWithName:(NSString *__nonnull)title;
+ (void)setUserCustomInfo:(NSDictionary * __nonnull)userCustomInfo;
+ (void)setSessionCustomInfo:(NSDictionary* __nonnull)sessionCustomInfo;
+ (void)reportCustomError:(NSError*_Nullable)error withInfo:(NSDictionary * _Nullable)info;
+ (void)logClientEventWithName:(NSString * __nonnull)eventName info:(NSDictionary * _Nullable)info;
+ (void)logClientEventWithName:(NSString * __nonnull)eventName info:(NSDictionary * _Nullable)info shouldFlatten:(BOOL)flatten;
+ (void)logAppEventWithName:(NSString * __nonnull)eventName info:(NSDictionary *_Nullable)info;
+ (void)logAppEventWithName:(NSString * __nonnull)eventName info:(NSDictionary *_Nullable)info isAggregate:(BOOL)isAggregate;
+ (void)logAppEventWithName:(NSString * __nonnull)eventName info:(NSDictionary *_Nullable)info shouldFlatten:(BOOL)flatten isAggregate:(BOOL)isAggregate;
+ (NSString *_Nonnull)getDeviceID;

@end
