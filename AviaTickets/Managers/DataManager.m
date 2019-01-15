//
//  DataManager.m
//  AviaTickets
//
//  Created by Olga Martyanova on 30/11/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()

@property (nonatomic, strong, readwrite) NSArray *countries;
@property (nonatomic, strong, readwrite) NSArray *cities;
@property (nonatomic, strong, readwrite) NSArray *airports;

@end

@implementation DataManager

+(instancetype)shared
{
    static DataManager *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[DataManager alloc] init];
    });
    
    return instance;
}

- (void)loadData
{
    __weak DataManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSArray *countriesJSONArray = [self arrayFromFileName:@"countries" ofType:@"json"];
        weakSelf.countries = [self createObjectsFromArray:countriesJSONArray withType:DataSourceTypeCountry];
        
        NSArray *citiesJSONArray = [self arrayFromFileName:@"cities" ofType:@"json"];
        weakSelf.cities = [self createObjectsFromArray:citiesJSONArray withType:DataSourceTypeCity];
        
        NSArray *airportsJSONArray = [self arrayFromFileName:@"airports" ofType:@"json"];
        weakSelf.airports = [self createObjectsFromArray:airportsJSONArray withType:DataSourceTypeAirport];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoadDataDidComplete object:nil];
        });
    });
}

- (City *)cityForLocation:(CLLocation *)location {
    for (City *city in _cities) {
        if (ceilf(city.coordinate.latitude) == ceilf(location.coordinate.latitude) && ceilf(city.coordinate.longitude) == ceilf(location.coordinate.longitude)) {
            return city;
        }
    }
    return nil;
}

- (NSMutableArray *)createObjectsFromArray:(NSArray *)array withType:(DataSourceType)type
{
    NSMutableArray *results = [NSMutableArray new];
    
    for (NSDictionary *jsonObject in array) {
        switch (type) {
            case DataSourceTypeCountry:
            {
                Country *country = [[Country alloc] initWithDictionary: jsonObject];
                [results addObject: country];
                break;
            }
            case DataSourceTypeCity:
            {
                City *city = [[City alloc] initWithDictionary: jsonObject];
                [results addObject: city];
                break;
            }
            case DataSourceTypeAirport:
            {
                Airport *airport = [[Airport alloc] initWithDictionary: jsonObject];
                [results addObject: airport];
                break;
            }
            default:
                break;
        }
    }
    
    return results;
}

- (City *)cityForIATA:(NSString *)iata {
    if (iata) {
        for (City *city in _cities) {
            if ([city.code isEqualToString:iata]) {
                return city;
            }
        }
    }
    return nil;
}


- (NSArray *)arrayFromFileName:(NSString *)fileName ofType:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

@end
