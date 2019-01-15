//
//  NSString+Localize.m
//  AviaTickets
//
//  Created by Olga Martyanova on 24/12/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

#import "NSString+Localize.h"

@implementation NSString (Localize)

- (NSString *)localize {
    return NSLocalizedString(self, nil);
}

@end
