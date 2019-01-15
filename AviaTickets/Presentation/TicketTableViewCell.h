//
//  TicketTableViewCell.h
//  AviaTickets
//
//  Created by Olga Martyanova on 06/12/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "FavoriteTicket+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;

@end

NS_ASSUME_NONNULL_END
