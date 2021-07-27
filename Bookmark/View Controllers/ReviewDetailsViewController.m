//
//  ReviewDetailsViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/19/21.
//

#import "ReviewDetailsViewController.h"
#import "DateTools.h"

@interface ReviewDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDescriptionTextView;

@end

@implementation ReviewDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameLabel.text = self.review.author.username;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    NSString *timeDiff = [self.review.createdAt timeAgoSinceNow];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.timeLabel.text = timeDiff;
    
    self.ratingLabel.text = [[self.review.rating stringValue] stringByAppendingString:@"★"];
    self.postDescriptionTextView.text = self.review.postText;
    
    //TODO: Add Book information label and image updating
}

@end
