#import <Foundation/Foundation.h>
#import "APXInfo.h"

@interface APXChunkMetaInfo : APXInfo
-(instancetype) initWith:(NSString*) sid cid:(NSUInteger)cid start:(NSUInteger)start end:(NSUInteger)end reportingTimes:(NSArray*)ts;
@end
