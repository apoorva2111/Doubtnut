#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, APXLOGLEVEL) {
    APX_INFO = 0,
    APX_DEBUG = 1,
    APX_WARN = 2,
    APX_ERROR = 3,
    APX_NONE = 9999
};

extern APXLOGLEVEL LOG_LEVEL;

#define PrintThread1 \
do {    \
if([NSThread isMainThread]) {   \
NSLog(@"***MainThread*** %s-%u",__func__,__LINE__);    \
} else {    \
NSLog(@"+++BGThread queue:%s+++ %s,%u",dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL),__func__,__LINE__);  \
}   \
} while(0)



#define Loginfo(x)  \
do  {   \
    NSLog(@"<APX INFO> %@ %s:%d\n", x, __FUNCTION__, __LINE__);   \
} while(0)

#define Logdebug(x)  \
do  {   \
    if (LOG_LEVEL <= APX_DEBUG)  \
        NSLog(@"<APX DEBUG> %@ %s:%d\n", x, __FUNCTION__, __LINE__);   \
} while(0)


#define Logwarn(x)  \
do  {   \
    if (LOG_LEVEL <= APX_WARN)  \
        NSLog(@"<APX WARN> %@ %s:%d\n", x, __FUNCTION__, __LINE__);   \
} while(0)

#define Logerr(x)  \
do  {   \
    if (LOG_LEVEL <= APX_ERROR)  \
        NSLog(@"<APX ERROR> %@ %s:%d\n", x, __FUNCTION__, __LINE__);   \
} while(0)


@interface APXLogger: NSObject
+(void) setLogLevel:(APXLOGLEVEL) logLevel;
@end
