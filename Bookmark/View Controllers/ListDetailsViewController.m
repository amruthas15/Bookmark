//
//  ListDetailsViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/19/21.
//

#import "ListDetailsViewController.h"
#import "DateTools.h"
#import "Utilities.h"
#import "PopularCollectionCell.h"

@interface ListDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *listTitle;
@property (weak, nonatomic) IBOutlet UILabel *postDescriptionTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *listOfBooks;

@end

@implementation ListDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.usernameLabel.text = self.list.author.username;
    self.listTitle.text = self.list.listTitle;
    self.postDescriptionTextView.text = self.list.postText;
    
    self.timeLabel.text = [Utilities getTimeText:self.list.createdAt];
    
    for(NSString *googleBookID in self.list.arrayOfBookIDs)
    {
        PFQuery *bookQuery = [Book query];
        [bookQuery whereKey:@"googleBookID" equalTo: googleBookID];
        [bookQuery orderByDescending:@"updatedAt"];
        bookQuery.limit = 1;
        
        [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
            if (books) {
                NSMutableArray *bookInfo = [[NSMutableArray alloc] initWithArray:self.listOfBooks];
                [bookInfo addObject:[books firstObject]];
                self.listOfBooks = bookInfo;
                [self.collectionView reloadData];
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    //TODO: Add collection view of books in list
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PopularCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PopularCollectionCell" forIndexPath:indexPath];
    Book *book = self.listOfBooks[indexPath.item];
    cell.googleBookID = book.googleBookID;
    cell.bookCoverImageView.image = [Utilities getBookCoverImageFromString: book.coverURL];
    cell.rankingLabel.hidden = TRUE;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listOfBooks.count;
}

@end
