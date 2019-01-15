//
//  CoreDataHelper.h
//  AviaTickets
//
//  Created by Olga Martyanova on 18/12/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSMutableArray *)favorites;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;
- (void)removeTicket:(Ticket *)ticket;
@end

NS_ASSUME_NONNULL_END
