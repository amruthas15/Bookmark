//
//  PopularScreenViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "PopularScreenViewController.h"
#import "PopularCollectionCell.h"
#import "Book.h"
#import "UIImageView+AFNetworking.h"

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

    // fetch data asynchronously
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PopularCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PopularCollectionCell" forIndexPath:indexPath];
    Book *book = self.books[indexPath.item];
    cell.googleBookID = book.googleBookID;
    cell.bookCoverImageView.image = [self getBookCoverImage: book.coverURL];
    cell.rankingLabel.text = [@(indexPath.item + 1) stringValue];
//    [cell.bookCoverImageView setImageWithURL:[NSURL URLWithString: book.coverURL]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.books.count;
}

-(UIImage *)getBookCoverImage: (NSString *)urlString {
    if([urlString containsString:@"http:"])
    {
        urlString = [urlString substringFromIndex:4];
        urlString = [@"https" stringByAppendingString:urlString];
    }
    NSURL *imageURL = [NSURL URLWithString: urlString];
    NSData* imageData = [[NSData alloc] initWithContentsOfURL: imageURL];
    return [UIImage imageWithData: imageData];
}

@end
