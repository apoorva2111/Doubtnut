#import <Foundation/Foundation.h>
#import "CommonProtocols.h"

/**
 *  APXInfo - Class to store information. Identified by identifier and additional info.
 *      1) Implements Storable protocol, yet provides access to store or not with Storable api.
 *      2) By default all attributes are set with setInfo and retrived with attributes -
 *          However, subclasses (like session,chunk) can choose to have seperate attributes and info.
 *          They can provide additional methods to access their corresponding spl attributes.
 *      3) additional info keys (and identifier key) used in storable protocol is customizable via
 *
 */

/**
 *  CustoInfo : The following data types are supported for CustomInfo of an APXInfo object:
 *      a)  Number, NSString
 *      b)  NSArray with Number, String
 *      c)  NSDictionary with NSString as Keys and Number/NSString as Values [TODO]
 */

#define kCustomInfo @"__custom_info__"
#define kAdditionalInfo @"__additional_info__"


@interface APXInfo : NSObject <APXStorable>

@property (readwrite) NSMutableDictionary * _Nonnull additionalInfo;
@property (readwrite) NSString * _Nonnull identifier;

/**< Storable to Server  */
-(NSDictionary*_Nonnull) jsonDictModified;
-(NSDictionary*_Nonnull) jsonDictModifiedforInstanceWithName:(NSString *_Nonnull) instanceName;
/**< Info to Server  */

-(BOOL) isStorable; /** FIXME name change */

-(instancetype _Nonnull ) initWithId:(NSString*_Nonnull) infoIdentifier;
-(void) setInfo:(id _Nonnull )value forKey:(NSString *_Nonnull)key;

-(void) setCustomInfo:(id _Nonnull )value forKey:(NSString *_Nonnull)key;
-(void) setCustomInfo:(NSDictionary* _Nonnull ) info;
-(NSDictionary*_Nonnull) customInfo;
+(APXInfo*_Nonnull) objectFromDictionary:(NSDictionary*_Nonnull) dictionary;

@end
