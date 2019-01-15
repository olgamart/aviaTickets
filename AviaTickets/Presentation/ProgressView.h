//
//  ProgressView.h
//  AviaTickets
//
//  Created by Olga Martyanova on 21/12/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressView : UIView

+ (instancetype)sharedInstance;

- (void)show:(void (^)(void))completion;
- (void)dismiss:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
