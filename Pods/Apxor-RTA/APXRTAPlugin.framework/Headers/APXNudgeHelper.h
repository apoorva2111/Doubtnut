//
//  APXNudgeHelper.h
//  APXRTAPlugin
//
//  Created by Vivek Cherukuri on 04/11/2019.
//  Copyright © 2019 Apxor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APXNudgeHelper : NSObject

+ (instancetype)sharedHelper;
- (void)buildAndShowNudgeWithUIConfig:(NSDictionary *)config;
- (void)willDismiss;

@end

@interface APXNudgeView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@end
