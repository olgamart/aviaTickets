//
//  TicketsViewController.m
//  AviaTickets
//
//  Created by Olga Martyanova on 06/12/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"
#import "NotificationCenter.h"
#import "NSString+Localize.h"


#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()
@property (nonatomic, strong) NSMutableArray *tickets;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;
@end

@implementation TicketsViewController {
    BOOL isFavorites;
    TicketTableViewCell *notificationCell;
}

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        isFavorites = YES;
        self.tickets = [NSMutableArray new];
        self.title = @"favorites_tab".localize;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

- (instancetype)initWithTickets:(NSMutableArray *)tickets {
    self = [super init];
    if (self)
    {
        _tickets = tickets;
        self.title = @"tickets_title".localize;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.minimumDate = [NSDate date];
 
        
        _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
        _dateTextField.hidden = YES;
        _dateTextField.inputView = _datePicker;
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
        keyboardToolbar.items = @[flexBarButton, doneBarButton];
        
        _dateTextField.inputAccessoryView = keyboardToolbar;
        [self.view addSubview:_dateTextField];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFavorites) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        _tickets = [[CoreDataHelper sharedInstance] favorites];
        [self.tableView reloadData];
    }
}

- (void)doneButtonDidTap:(UIBarButtonItem *)sender
{
    NSString *strСurrency = @"rubles".localize;
    NSString *strFor = @"for".localize;
    if (_datePicker.date && notificationCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@ %@ %@ %@", notificationCell.ticket.from, notificationCell.ticket.to, strFor, notificationCell.ticket.price, strСurrency];
        
        NSURL *imageURL;
        if (notificationCell.airlineLogoView.image) {
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.ticket.airline]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *logo = notificationCell.airlineLogoView.image;
                NSData *pngData = UIImagePNGRepresentation(logo);
                [pngData writeToFile:path atomically:YES];
                
            }
            imageURL = [NSURL fileURLWithPath:path];
        }
        
        Notification notification = NotificationMake(@"ticket_reminder".localize, message, _datePicker.date, imageURL);
        
        [[NotificationCenter sharedInstance] sendNotification:notification];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour  | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:notification.date];
        
        NSString *strFormatRemainder = [NSString stringWithFormat: @" - %ld-%ld-%ld %ld:%ld:%ld", (long)dateComponents.year,    (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second]; 
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"success".localize message: [@"notification_will_be_sent".localize stringByAppendingString: strFormatRemainder] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"close".localize style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    _datePicker.date = [NSDate date];
    notificationCell = nil;
    [self.view endEditing:YES];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    if (isFavorites) {
        cell.favoriteTicket = [_tickets objectAtIndex:indexPath.row];
    } else {
        cell.ticket = [_tickets objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak TicketsViewController *weakSelf = self;
    if (!isFavorites) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"actions_with_tickets".localize message:@"actions_with_tickets_describe".localize preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *favoriteAction;
        if ([[CoreDataHelper sharedInstance] isFavorite: [_tickets objectAtIndex:indexPath.row]]) {
            favoriteAction = [UIAlertAction actionWithTitle:@"remove_from_favorite".localize style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] removeFromFavorite:[weakSelf.tickets objectAtIndex:indexPath.row]];
            }];
        } else {
            favoriteAction = [UIAlertAction actionWithTitle:@"add_to_favorite".localize style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] addToFavorite:[weakSelf.tickets objectAtIndex:indexPath.row]];
            }];
        }
        
        UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:@"remind_me".localize style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            self->notificationCell = [tableView cellForRowAtIndexPath:indexPath];
            [weakSelf.dateTextField becomeFirstResponder];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"close".localize style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:favoriteAction];
        [alertController addAction:notificationAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"actions_with_tickets".localize message:@"actions_with_tickets_describe".localize preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *favoriteAction;
        
        favoriteAction = [UIAlertAction actionWithTitle:@"remove_from_favorite".localize style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [[CoreDataHelper sharedInstance] removeTicket:[weakSelf.tickets objectAtIndex:indexPath.row]];
            weakSelf.tickets = [[CoreDataHelper sharedInstance] favorites];
            [self.tableView reloadData];
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"close".localize style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:favoriteAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
