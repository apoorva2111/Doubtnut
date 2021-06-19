#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import "APXTypes.h"


@class UIApplication;
@interface APXUtilities : NSObject

+(void) initializeDateFormatter;
+(APXTime) installationDate;
+(BOOL) isFirstSession;
+(NSString* _Nullable) deviceName;

+(NSDictionary*_Nonnull) addTwoDictionaries:(NSDictionary*_Nonnull) one and: (NSDictionary*_Nonnull) two;
+(NSDate*_Nullable) dateFromAPXDateString:(NSString*_Nonnull) dateString;
+(NSString*_Nullable) dateAPXStringFromNSDate:(NSDate*_Nonnull) date;
+(APXTime) timeIntervalFromAPXDateString:(NSString*_Nonnull) dateString;
+(NSString*_Nullable) dateAPXStringFromTimeInterval:(APXTime) timeInterval;
+(NSString*_Nullable) getHashForModule:(NSString*_Nonnull) module;
+(void) saveHash:(NSString*_Nonnull) value ForModule:(NSString*_Nonnull) module;
+(BOOL) saveConfig:(NSData*_Nonnull) config atPath:(NSString*_Nonnull) path;
+(NSDictionary *_Nullable) readConfig:(NSString*_Nonnull) filePath;

#pragma mark - JSON Utility Methods
+(NSData*_Nullable) jsonDataFromNSDictionary:(NSDictionary*_Nonnull) dictionary;
+(NSDictionary*_Nullable) dictionaryFromNSData:(NSData*_Nonnull) data;
+(NSDictionary*_Nullable) dictionaryFromJsonString:(NSString*_Nonnull) string;
+(NSString*_Nullable) jsonStringFromNSDictionary:(NSDictionary*_Nonnull) dictionary;
+(NSArray*_Nullable) arrayFromJsonString:(NSString*_Nonnull) string;
+(NSString*_Nullable) jsonStringFromNSArray:(NSArray*_Nonnull) array;

#pragma mark - vc methods
+ (UIViewController *_Nullable)topViewController:(UIViewController *_Nonnull)rootViewController;

#pragma mark - text utils
+ (BOOL)isnumericString:(NSString*_Nonnull)string;
+ (BOOL)isNonEmptyString:(NSString*_Nonnull)string;

#pragma mark - Window utils
+(UIWindow* _Nullable)keyWindow;

@end
