//
//  Airport.h
//  AviaTickets
//
//  Created by Olga Martyanova on 30/11/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Airport : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *timezone;
@property (nonatomic, strong) NSString *translations;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, getter=isFlightable) BOOL flightable;
@property (nonatomic) CLLocationCoordinate2D coordinate;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
