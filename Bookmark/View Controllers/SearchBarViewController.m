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
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    PFQuery *bookQuery = [Book query];
    [bookQuery orderByDescending:@"updatedAt"];
    [bookQuery includeKey:@"bookAuthor"];
    [bookQuery includeKey:@"bookTitle"];
    bookQuery.limit = 20;


    // fetch data asynchronously
    [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
        if (books) {
            self.data = books;
            self.filteredData = self.data;

            NSLog(@"😎😎😎 Successfully loaded search bar table");

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
    
    BookCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"
                                                                 forIndexPath:indexPath];
    NSDictionary *currentBook = self.filteredData[indexPath.row];
    cell.bookID = currentBook[@"id"];
    
    NSDictionary *volumeInfo = currentBook[@"volumeInfo"];
    cell.bookTitleLabel.text = volumeInfo[@"title"];
    
    NSDictionary *bookAuthorList = volumeInfo[@"authors"];
    cell.bookAuthorLabel.text = [self getAuthorsOfBook:bookAuthorList];
    
    NSDictionary *coverImages = volumeInfo[@"imageLinks"];
    cell.coverPhotoImageView.image = [self getBookCoverImage:coverImages];
    return cell;
}

-(NSString *)getAuthorsOfBook: (NSDictionary *)bookAuthorList {
    NSString *authorString = @" ";
    int additionalAuthors = bookAuthorList.count - 1;
    for(id key in bookAuthorList)
    {
        authorString = [authorString stringByAppendingString:key];
        if(additionalAuthors > 0)
        {
            authorString = [authorString stringByAppendingString:@", "];
        }
    }
    return authorString;
}

-(UIImage *)getBookCoverImage: (NSDictionary *)coverImages {
    NSString *urlString = coverImages[@"thumbnail"];
    if([urlString containsString:@"http:"])
    {
        urlString = [urlString substringFromIndex:4];
        urlString = [@"https" stringByAppendingString:urlString];
    }
    NSURL *imageURL = [NSURL URLWithString: urlString];
    NSData* imageData = [[NSData alloc] initWithContentsOfURL: imageURL];
    return [UIImage imageWithData: imageData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    
    if (searchText.length != 0) {
        
        [[APIManager shared] getBookSearchQueries:searchText completion:^(NSArray *books, NSError *error) {
            if (books) {
                self.filteredData = [[NSMutableArray alloc] initWithArray:books];
                NSLog(@"😎😎😎 Successfully loaded search bar table");
                
                self.tableView.dataSource = self;
                self.tableView.delegate = self;
                
                [self.tableView reloadData];
            } else {
                NSLog(@"😫😫😫 Error getting search bar table: %@", error.localizedDescription);
            }
        }];
        
        NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.data;
    }
    
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
