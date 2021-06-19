#import <Foundation/Foundation.h>

@protocol APXStorable <NSObject>
-(NSDictionary*) jsonDict;          /**< Storable to persistant store */
+(id) objectFromJsonDict:(NSDictionary *) jsonDict; /**< Persistant store to Storable   */
@end


