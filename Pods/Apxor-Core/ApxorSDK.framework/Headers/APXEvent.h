#import "APXInfo.h"
#import "APXTypes.h"

typedef NS_ENUM(NSUInteger, APXEventType) {
    APXEventTypeSystem,
    APXEventTypeCENavigation,
    APXEventTypeNavigation,
    APXEventTypeUserInteraction,
    APXEventTypeApp,
    APXEventTypeClient,
    APXEventTypeAggregate,
    APXEventTypePush,
    APXEventTypeInApp,
    APXEventTypeInline,
    APXEventTypeNudge,
    APXEventTypeInlineText,
    APXEventTypeInlineCoachmark,
    APXEventTypeWalkthrough,
    APXEventTypeScreenshot,
    APXEventTypeSurvey,
    APXEventTypeUser,
    APXEventTypeSession,
    APXEventTypeChunk,
    APXEventTypeCustomError,
    APXEventTypeCrash
};

#define APXENUMSTRING(x)   [APXEvent typeToString(x)]

@class APXEvent;

@protocol APXEventListener <NSObject>

-(void) onEvent: (APXEvent*) event;

@end

@protocol APXEventSource <NSObject>

-(void) logEvent:(NSString *) eventName info:(NSDictionary *) info time:(APXTime) time;

@end


@interface APXEvent : APXInfo 

+ (NSString*)stringFromType:(APXEventType)type;
+ (APXEventType)typeFromString:(NSString*)string;

- (instancetype)initWithType:(APXEventType)type;
- (APXTime)createdTime;
- (void)setCreatedTime:(APXTime)time;
- (APXEventType)eventType;
- (void)setEventType:(APXEventType)type;

@end


@interface APXSessionEvent : APXEvent

@end

@interface APXChunkEvent : APXEvent

@end

@interface APXSurveyEvent : APXEvent

@end

@interface APXInlineEvent : APXEvent

@end

@interface APXInAppEvent : APXEvent

@end

@interface APXNudgeEvent : APXEvent

@end

@interface APXClientEvent : APXEvent

@end

@interface APXAggregateEvent : APXEvent

@end
