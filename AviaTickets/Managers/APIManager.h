//
//  APIManager.h
//  AviaTickets
//
//  Created by Olga Martyanova on 06/12/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

#define AirlineLogo(iata) [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png", iata]];
#define API_URL_MAP_PRICE @"https://map.aviasales.ru/prices.json?origin_iata="

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (instancetype)sharedInstance;
- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;
- (void)cityForCurrentIP:(void (^)(City *city))completion;
- (void)mapPricesFor:(City *)origin withCompletion:(void (^)(NSArray *prices))completion;

@end
NS_ASSUME_NONNULL_END
