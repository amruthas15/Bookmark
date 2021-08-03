//
//  ReviewDetailsViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/19/21.
//

#import "ReviewDetailsViewController.h"
#import "DateTools.h"
#import "APIManager.h"
#import "Utilities.h"
#import "BookDetailsViewController.h"

@interface ReviewDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;


@end

@implementation ReviewDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameLabel.text = self.review.author.username;
    self.timeLabel.text = [Utilities getTimeText:self.review.createdAt];
    
    self.ratingLabel.text = [[self.review.rating stringValue] stringByAppendingString:@"★"];
    self.postDescriptionTextView.text = self.review.postText;
    
    PFQuery *bookQuery = [Book query];
    [bookQuery whereKey:@"googleBookID" equalTo: self.review.bookID];
    [bookQuery orderByDescending:@"updatedAt"];
    bookQuery.limit = 5;
    
    [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
        if (books) {
            Book *book = [books firstObject];
            self.bookTitleLabel.text = book.bookTitle;
            self.bookCoverImageView.image = book.coverURL ? [Utilities getBookCoverImageFromString:book.coverURL] : [UIImage systemImageNamed:@"book"];
            self.authorLabel.text = [Utilities getAuthorsOfBook:book.bookAuthors];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapBookCover:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"reviewCellToBookDetailSegue" sender:nil];
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString: @"reviewCellToBookDetailSegue"])
     {
         BookDetailsViewController *bookDetailsViewController = [segue destinationViewController];
         bookDetailsViewController.googleBookID = self.review.bookID;
     }
 }

@end
