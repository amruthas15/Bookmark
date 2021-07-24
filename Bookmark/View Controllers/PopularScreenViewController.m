//
//  PopularScreenViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "PopularScreenViewController.h"
#import "PopularCollectionCell.h"
#import "Book.h"

@interface PopularScreenViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) NSArray *books;

@end

@implementation PopularScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchPopularBooks];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;

    CGFloat cellsPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (cellsPerLine - 1)) / cellsPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
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
            for(Book *book in books){
                NSLog(book.bookTitle);
            }
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
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
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
