//
//  ListDetailsViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/19/21.
//

#import "ListDetailsViewController.h"
#import "DateTools.h"
#import "Utilities.h"
#import "BookCollectionCell.h"
#import "BookDetailsViewController.h"

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
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;

    CGFloat cellsPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width / cellsPerLine) - 8;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.usernameLabel.text = self.list.author.username;
    self.listTitle.text = self.list.listTitle;
    self.postDescriptionTextView.text = self.list.postText;
    
    self.timeLabel.text = [Utilities getTimeText:self.list.createdAt];
    
    [self fetchData];
}

-(void)fetchData {
    PFQuery *bookQuery = [Book query];
    [bookQuery whereKey:@"googleBookID" containedIn:self.list.arrayOfBookIDs];
    [bookQuery orderByDescending:@"updatedAt"];
    [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
        if (books) {
            self.listOfBooks = books;
            [self.collectionView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BookCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListBookCollectionCell" forIndexPath:indexPath];
    Book *book = self.listOfBooks[indexPath.item];
    cell.googleBookID = book.googleBookID;
    cell.bookCoverImageView.image = [Utilities getBookCoverImageFromString: book.coverURL];
    cell.rankingLabel.hidden = TRUE;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listOfBooks.count;
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([sender isKindOfClass:[UICollectionViewCell class]])
     {
         UICollectionViewCell *tappedCell = sender;
         NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
         Book *currentBook = self.listOfBooks[indexPath.row];
         
         BookDetailsViewController *bookDetailsViewController = [segue destinationViewController];
         bookDetailsViewController.googleBookID = currentBook.googleBookID;
     }
 }

@end
