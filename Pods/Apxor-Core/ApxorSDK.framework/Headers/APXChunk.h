#import "APXInfo.h"

@interface APXChunk : APXInfo

+(NSString*) CMID:(NSString*) sid cid:(NSUInteger) cid;

-(instancetype) initWithIndex:(NSUInteger)chunkIndex sessionId:(NSString*) sessionId;
-(void) setChunkAttribute:(id)value forKey:(NSString *)key;
-(NSDictionary*) chunkAttributes;

@end


