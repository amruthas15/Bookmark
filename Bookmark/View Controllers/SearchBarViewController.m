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
#import "MBProgressHUD.h"
#import "BookDetailsViewController.h"


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
    [self scrollViewDidScroll:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

    self.filteredData = self.data;
}

-(NSArray *)filterDuplicateBooks:(NSArray *)books {
    NSMutableArray *filteredBooks = [[NSMutableArray alloc] initWithArray:books];
    NSMutableArray *filteredTitles = [[NSMutableArray alloc] init];
    NSMutableArray *filteredAuthors = [[NSMutableArray alloc] init];
    for(NSDictionary *book in books)
    {
        NSDictionary *volumeInfo = book[@"volumeInfo"];
        NSUInteger titleIndex = [filteredTitles indexOfObject:volumeInfo[@"title"]];
        if((titleIndex != NSNotFound) && ([[filteredAuthors objectAtIndex:titleIndex] isEqualToArray:volumeInfo[@"authors"]]))
        {
            [filteredBooks removeObject:book];
        }
        else
        {
            [filteredTitles addObject:volumeInfo[@"title"]];
            [filteredAuthors addObject:volumeInfo[@"authors"]];
        }
    }
    return filteredBooks;
}

#pragma mark - Navigation

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    
    if (searchText.length != 0) {
        
        [[APIManager shared] getBookSearchQueries:searchText completion:^(NSArray *books, NSError *error) {
            if (books) {
                self.filteredData = [self filterDuplicateBooks:books];
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

#pragma mark - Table View Delegate Methods

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


- (IBAction)didPanCell:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:self.tableView];
        NSIndexPath *cellIndexPath = [self.tableView indexPathForRowAtPoint:location];
        UITableViewCell *tappedCell = [self.tableView cellForRowAtIndexPath:cellIndexPath];
        if([self.filteredData[cellIndexPath.row] isMemberOfClass:[Book class]])
        {
            [self performSegueWithIdentifier:@"searchToBookCellSegue" sender:tappedCell];
        }
    }
}


#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *visibleCells = [self.tableView visibleCells];

    if (visibleCells != nil  &&  [visibleCells count] != 0) {

        UITableViewCell *topCell = [visibleCells objectAtIndex:0];
        UITableViewCell *bottomCell = [visibleCells lastObject];

        
        for (UITableViewCell *cell in visibleCells) {
            cell.contentView.alpha = 1.0;
        }

        NSInteger cellHeight = topCell.frame.size.height - 1;
        NSInteger tableViewTopPosition = self.tableView.frame.origin.y;
        NSInteger tableViewBottomPosition = self.tableView.frame.origin.y + self.tableView.frame.size.height;

        CGRect topCellPositionInTableView = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:topCell]];
        CGRect bottomCellPositionInTableView = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:bottomCell]];
        CGFloat topCellPosition = [self.tableView convertRect:topCellPositionInTableView toView:[self.tableView superview]].origin.y;
        CGFloat bottomCellPosition = ([self.tableView convertRect:bottomCellPositionInTableView toView:[self.tableView superview]].origin.y + cellHeight);

        CGFloat fadingModifier = 1.5;
        CGFloat topCellOpacity = (1.0f - ((tableViewTopPosition - topCellPosition) / cellHeight) * fadingModifier);
        CGFloat bottomCellOpacity = (1.0f - ((bottomCellPosition - tableViewBottomPosition) / cellHeight) * fadingModifier);

        if (topCell) {
            topCell.contentView.alpha = topCellOpacity;
        }
        if (bottomCell) {
            bottomCell.contentView.alpha = bottomCellOpacity;
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Book *currentBook = self.filteredData[indexPath.row];
        
        BookDetailsViewController *bookDetailsViewController = [segue destinationViewController];
        bookDetailsViewController.googleBookID = currentBook.googleBookID;
    }
}

@end
