//
//  FavoriteTicket+CoreDataProperties.m
//  
//
//  Created by Olga Martyanova on 18/12/2018.
//
//

#import "FavoriteTicket+CoreDataProperties.h"

@implementation FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
}

@dynamic flightNumber;
@dynamic price;
@dynamic to;
@dynamic from;
@dynamic airline;
@dynamic returnDate;
@dynamic expires;
@dynamic departure;
@dynamic created;

@end
