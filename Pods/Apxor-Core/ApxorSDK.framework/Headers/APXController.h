#import <Foundation/Foundation.h>
#import "CommonProtocols.h"
#import "APXEvent.h"
#import "APXChunk.h"
#import "APXSession.h"
#import "APXUser.h"
#import "APXChunkMetaInfo.h"
#import "APXAppInfo.h"
#import "APXDeviceInfo.h"
#import "APXSDKInfo.h"


/**
 *  Holds Core Plugin components
 *  Holds Configuration Manager, APXDataHandler, APXEventHandler
 *  SPOC for all modules - All API are expected to be threadsafe
 */
NS_ASSUME_NONNULL_BEGIN

@interface APXController : NSObject<APXEventListener>

@property (readonly) BOOL enableSDK;
@property (readonly) BOOL isSDKInitCalled;
@property (readonly) NSString * _Nonnull applicationIdentifier;

// Convinience methods (removes unnecessary computations)
@property (readonly) APXSession * _Nonnull session;
@property (readonly) APXUser * _Nonnull user;
@property (readonly) APXAppInfo * _Nonnull appInfo;
@property (readonly) APXDeviceInfo * _Nonnull deviceInfo;
@property (readonly) APXSDKInfo * _Nonnull sdkInfo;


#pragma mark -  Lifecycle methods
+ (instancetype _Nonnull) sharedController;
-(void) initialize;
-(void) initializeWithApxorID:(NSString *)appId;

#pragma mark - Public APIS
-(void) setUserIdentifier:(NSString * __nonnull)identifier;
-(void) logScreenWithName:(NSString *)title;
-(void) logClientEventWithName:(NSString * __nonnull)eventName info:(NSDictionary *)info;
-(void) logClientEventWithName:(NSString * __nonnull)eventName info:(NSDictionary *)info shouldFlatten:(BOOL)flatten;
-(void) logAppEventWithName:(NSString * __nonnull)eventName info:(NSDictionary *)info;
-(void) logAppEventWithName:(NSString * __nonnull)eventName info:(NSDictionary *)info isAggregate:(BOOL)isAggregate;
-(void) logAppEventWithName:(NSString * __nonnull)eventName info:(NSDictionary *)info shouldFlatten:(BOOL)flatten isAggregate:(BOOL)isAggregate;
-(void) setUserCustomInfo:(NSDictionary * __nonnull)userCustomInfo;
-(void) setSessionCustomInfo:(NSDictionary*_Nonnull)sessionCustomInfo;
-(void) reportCustomError:(NSError*_Nonnull)error withInfo:(NSDictionary* __nullable)info;
-(NSString*) getDeviceID;
-(NSString*) getHardwareModel;
-(void) markAsCordova;
-(BOOL) isCordova;

#pragma mark - Timer methods
- (void) registerForTimerNotificationWithInterval:(double)interval closure:(void (^)(NSTimer * _Nonnull timer))block;

#pragma mark - Event Handling methods
-(void) dispatchEvent:(APXEvent *_Nonnull)event;
-(void) registerForEventWithType:(APXEventType) event listener:(id<APXEventListener> _Nonnull) listener;
-(void) deregisterForEventWithType:(APXEventType) event listener:(id<APXEventListener> _Nonnull) listener;
-(void) registerIdentifer:(NSString*_Nonnull) identifier withListener:(id<APXEventListener> _Nonnull) listener;
-(void) deRegisterIdentifer:(NSString*_Nonnull) identifier withListener:(id<APXEventListener>_Nonnull) listener;
-(void) executeAfterDelay:(NSTimeInterval) delayInSeconds block:(dispatch_block_t _Nonnull ) block;
-(APXTime) currentSDKTimeInMillis;

#pragma mark - Session handling methods
-(void) startSessionWithLaunchType:(NSString*_Nonnull) launchType;
-(void) updateChunkEndTime;

#pragma mark - User info sending method
-(void) sendUserInfo;

#pragma mark - Sync manager methods
-(void) getSyncDataForActionType:(NSString*_Nonnull) actionType version:(NSString*_Nonnull) version withCompletionHandler:(void(^_Nonnull)(void)) callback;

#pragma mark - Networking proxy methods
-(void) getDataFromURLPath:(NSString*_Nonnull)configURL completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))block;
-(void) postDataToURL:(NSString*) configURL withRequestBodyDictionary:(NSDictionary*)requestData headerFields:(NSDictionary* _Nullable)headers completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler;
-(void) makeDeleteRequestToURLPath:(NSString*_Nonnull)configURL headerFields:(NSDictionary* _Nullable)headers completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))block;

#pragma mark - Datahandler proxy methods
-(void) setAndSaveEnableSDKState:(BOOL) status;
-(void) saveUserInfo;
-(void) saveSessionInfoWithIndentifier:(NSString *_Nonnull) sessionId;
-(void) saveEvent:(APXEvent *_Nonnull)event;
-(void) processAggregateEventWithEvent:(APXEvent*)event;
-(NSArray*_Nonnull) retrieveAggregateEventsWithSessionIdentifier:(NSString*)identifier;
-(void) saveEvent:(APXEvent *_Nonnull)event inSession:(NSString *_Nonnull) sessionId;
-(NSString *_Nonnull) getSessionId;
-(void) markFatalAndUpdateDuration:(NSDate *_Nullable) duration inSession:(NSString *_Nonnull) identifier;
-(void) saveChunkMetaInfo:(APXChunkMetaInfo*_Nonnull) event;
-(void) updateChunkMetaInfo:(APXChunkMetaInfo*_Nonnull) event;
-(void) updateChunkMetaStatus:(APXChunk*_Nonnull) event;
-(NSArray*_Nonnull) getEventsBetween:(NSUInteger) start endInterval:(NSUInteger) end withIdentifier:(NSString*_Nonnull) identifier eventType:(NSString*_Nullable) eventType;
-(NSUInteger) numberOfEventsWithIdentifier:(NSString*_Nonnull) sessionIdentifier;
-(void) deleteChunkMetaInfo:(APXChunk*_Nonnull) event;
-(void) deleteAggregateEventsWithSessionId:(NSString*)sessionId;
-(NSArray*_Nonnull) retrieveChunkMetaInfo;
-(NSArray*_Nonnull) getSessions;
-(void) deleteSession:(NSString*_Nonnull) sessionIdentifier;
-(APXUser*_Nonnull) retrieveUser;
-(APXAppInfo*_Nonnull) retrieveAppInfoWithIdentifier:(NSString *_Nonnull) identifier;
-(APXDeviceInfo *_Nonnull) retrieveDeviceInfo;
-(APXSDKInfo *_Nonnull) retrieveSDKInfoWithIdentifier:(NSString *_Nonnull) identifier;
-(APXSession *_Nonnull) retrieveSessionInfoWithIdentifier:(NSString *_Nonnull) identifier;
-(void) deleteItemAtPath:(NSString *_Nonnull) path;

@end

NS_ASSUME_NONNULL_END
