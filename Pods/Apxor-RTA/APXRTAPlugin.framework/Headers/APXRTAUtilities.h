//
//  APXRTAUtilities.h
//  APXRTAPlugin
//
//  Created by Uday Koushik on 28/10/19.
//  Copyright © 2019 Apxor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APXView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, APXPosition) {
    APXTop,
    APXBottom,
    APXLeft,
    APXRight
};

typedef NS_ENUM(NSUInteger, APXNudgePosition) {
    APXNudgeLeft,
    APXNudgeRight,
    APXNudgeTopCenter,
    APXNudgeCenter,
};

@interface APXRTAUtilities : NSObject

#pragma mark - view utils
+ (NSArray *)ignoredViews;
+ (UIView *)getViewWithIdentifier:(NSString *)viewIdentifier;
+ (BOOL)shouldConsiderView:(UIView *)view;
+ (void)constructCustomViewHierarchyForView:(UIView *)parentView withRoot:(APXView *)root ignoringViews:(NSArray *)ignoreViews withAuxiliaryTableView:(UITableView *)tableView andCollectionView:(UICollectionView *)collectionView;
+ (void)logAPXViewWithRoot:(APXView *)root separator:(NSMutableString *)separator;
+ (void)sortSubViewsWithRootView:(APXView *)root;
+ (UIView *)topView;

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (void)logEventWithTitle:(NSString*)title messageName:(NSString*)messageName identifier:(NSString*)identifer;
+ (double) angleWithValue:(int) value;
+ (CGSize)getBoundingRectSizeForText:(NSString*)text withFontSize:(CGFloat)fontSize inView:(UIView*)view;
+ (CGSize)getBoundingRectSizeForText:(NSString*)text withStyle:(NSString*)style andFontSize:(CGFloat)fontSize withMaxSize:(CGSize)maxSize;
+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
+ (APXPosition)positionForString:(NSString *)direction;
+ (APXNudgePosition)nudgePositionForString:(NSString *)direction;
@end

NS_ASSUME_NONNULL_END
