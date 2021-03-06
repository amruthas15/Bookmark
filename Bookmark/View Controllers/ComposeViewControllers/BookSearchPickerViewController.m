//
//  BookSearchPickerViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/26/21.
//

#import "BookSearchPickerViewController.h"
#import "Parse/Parse.h"
#import "BookCell.h"
#import "Book.h"
#import "APIManager.h"

@interface BookSearchPickerViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *filteredData;

@end

@implementation BookSearchPickerViewController
@synthesize rowDescriptor = _rowDescriptor;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    PFQuery *bookQuery = [Book query];
    [bookQuery orderByDescending:@"updatedAt"];
    [bookQuery includeKey:@"bookAuthor"];
    [bookQuery includeKey:@"bookTitle"];
    bookQuery.limit = 20;

    [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
        if (books) {
            self.data = books;
            self.filteredData = self.data;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];

    self.filteredData = self.data;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BookCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BookPickerTableViewCell"
                                                                 forIndexPath:indexPath];
    NSDictionary *book = self.filteredData[indexPath.row];
    if([book isMemberOfClass:[Book class]]) {
        Book *modelBook = book;
        [cell initWithBook:modelBook];
    }
    else {
        [cell initWithDictionary:book];
    }
    
    NSString *valueGoogleBookID;
    if([self.rowDescriptor.value isMemberOfClass:[Book class]]) {
        Book *valueBook = self.rowDescriptor.value;
        valueGoogleBookID = valueBook.googleBookID;
    }
    else {
        valueGoogleBookID = self.rowDescriptor.value[@"id"];
    }
    cell.accessoryType = [valueGoogleBookID isEqual:cell.googleBookID] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *book = self.filteredData[indexPath.row];
    self.rowDescriptor.value = book;
    
    UIViewController *popoverController = self.presentedViewController;
    if (popoverController && popoverController.modalPresentationStyle == UIModalPresentationPopover) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([self.presentingViewController isKindOfClass:[BookSearchPickerViewController class]]) {
        [[self.presentingViewController navigationController] popViewControllerAnimated:YES];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    
    if (searchText.length != 0) {
        
        [[APIManager shared] getBookSearchQueries:searchText completion:^(NSArray *books, NSError *error) {
            if (books) {
                self.filteredData = [[NSMutableArray alloc] initWithArray:books];
                self.tableView.dataSource = self;
                self.tableView.delegate = self;
                [self.tableView reloadData];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    else {
        self.filteredData = self.data;
    }
    
    [self.tableView reloadData];
}

@end
