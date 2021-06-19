#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APXTooltipBuilder : NSObject

+ (instancetype)sharedBuilder;
- (void)buildAndShowInlineActionWithUIConfig:(NSDictionary*)config;
- (void)buttonClickedWithTitle:(NSString*)title;
- (void)willDismiss;
- (void)cancelWalkthrough;
- (void)willRedirectToVC:(NSString *)vcString;
- (void)targetViewTapped;

@end

NS_ASSUME_NONNULL_END
