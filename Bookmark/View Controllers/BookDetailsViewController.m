//
//  BookDetailsViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 8/2/21.
//

#import "BookDetailsViewController.h"
#import "Utilities.h"
#import "APIManager.h"

@interface BookDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *biographyLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *listCountLabel;

@end

@implementation BookDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.googleBookID);
    PFQuery *bookQuery = [Book query];
    [bookQuery whereKey:@"googleBookID" equalTo: self.googleBookID];
    [bookQuery orderByDescending:@"updatedAt"];
    bookQuery.limit = 1;
    
    [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
        if (books) {
            Book *book = [books firstObject];
            self.bookCoverImageView.image = book.coverURL ? [Utilities getBookCoverImageFromString:book.coverURL] : [UIImage systemImageNamed:@"book"];
            self.bookTitleLabel.text = book.bookTitle;
            self.bookAuthorLabel.text = [Utilities getAuthorsOfBook:book.bookAuthors];
            self.averageRatingLabel.text = [[book.avgRating stringValue] stringByAppendingString:@"★"];
            self.reviewCountLabel.text = [book.numReviews stringValue];
            self.listCountLabel.text = [book.numLists stringValue];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [[APIManager shared] getBookInformation:self.googleBookID completion:^(NSDictionary *book, NSError *error) {
        if (book) {
            NSDictionary *volumeInfo = book[@"volumeInfo"];
            self.publicationDateLabel.text = volumeInfo[@"publishedDate"];
            NSAttributedString *bioText = [[NSAttributedString alloc] initWithData:[volumeInfo[@"description"] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
            self.biographyLabel.text = [bioText string];

        } else {
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

@end
