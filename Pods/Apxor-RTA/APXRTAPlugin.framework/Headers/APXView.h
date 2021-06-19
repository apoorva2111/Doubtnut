//
//  APXView.h
//  APXRTAPlugin
//
//  Created by Uday Koushik on 6/11/20.
//  Copyright © 2020 Apxor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APXView : NSObject

@property (readwrite) UIView *view;
@property (readwrite) NSString *name;
@property (readwrite) NSMutableArray<APXView*> *subviews;

- (instancetype)initWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
