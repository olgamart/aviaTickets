//
//  TicketsViewController.h
//  AviaTickets
//
//  Created by Olga Martyanova on 06/12/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketsViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initFavoriteTicketsController;

@end

NS_ASSUME_NONNULL_END
