//
//  SearchBarViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "SearchBarViewController.h"
#import "Parse/Parse.h"
#import "Book.h"
#import "APIManager.h"
#import "BookCell.h"

@interface SearchBarViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *filteredData;

@end

@implementation SearchBarViewController

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchBookTableViewCell"
                                                                 forIndexPath:indexPath];
    NSDictionary *book = self.filteredData[indexPath.row];
    if([book isMemberOfClass:[Book class]]) {
        Book *modelBook = book;
        [cell initWithBook:modelBook];
    }
    else {
        [cell initWithDictionary:book];
    }
    return cell;
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
