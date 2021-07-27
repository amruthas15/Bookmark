//
//  PopularScreenViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "PopularScreenViewController.h"
#import "PopularCollectionCell.h"
#import "Book.h"
#import "Utilities.h"

@interface PopularScreenViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *books;

@end

@implementation PopularScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchPopularBooks];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;

    CGFloat cellsPerLine = 3;
    CGFloat itemWidth = self.collectionView.frame.size.width / cellsPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth - 8, itemHeight);
}

-(void)fetchPopularBooks {
    PFQuery *bookQuery = [Book query];
    [bookQuery orderByDescending:@"popularityIndex"];
    [bookQuery includeKey:@"coverURL"];
    [bookQuery includeKey:@"googleBookID"];
    bookQuery.limit = 12;

    [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
        if (books) {
            self.books = books;
            [self.collectionView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PopularCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PopularCollectionCell" forIndexPath:indexPath];
    Book *book = self.books[indexPath.item];
    cell.googleBookID = book.googleBookID;
    cell.bookCoverImageView.image = [Utilities getBookCoverImageFromString: book.coverURL];
    cell.rankingLabel.text = [@(indexPath.item + 1) stringValue];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.books.count;
}

@end
