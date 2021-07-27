//
//  FeedCell.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/14/21.
//

#import "FeedCell.h"
#import "Post.h"
#import "DateTools.h"
#import "APIManager.h"

@implementation FeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)initWithReview:(Post *)newReview {
    _post = newReview;
    [[APIManager shared] getBookInformation:newReview.bookID completion:^(NSDictionary *book, NSError *error) {
        if (book) {
            NSDictionary *volumeInfo = book[@"volumeInfo"];

            NSDictionary *coverImages = volumeInfo[@"imageLinks"];
            self.bookCoverImageView.image = [self getBookCoverImage:coverImages];
            self.postTitleLabel.text = volumeInfo[@"title"];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    self.postDescriptionLabel.text = newReview.postText;
    [self.ratingLabel setHidden:FALSE];
    self.ratingLabel.text = [[newReview.rating stringValue] stringByAppendingString:@"★"];
    self.usernameLabel.text = newReview.author.username;
    self.likeCountLabel.text = [newReview.likeCount stringValue];
    
    [self setTimeLabel:self.timeLabel];
}

-(void)initWithList:(Post *)newList {
    _post = newList;
    [[APIManager shared] getBookInformation:[newList.arrayOfBookIDs objectAtIndex:0] completion:^(NSDictionary *book, NSError *error) {
        if (book) {
            NSDictionary *volumeInfo = book[@"volumeInfo"];
            NSDictionary *coverImages = volumeInfo[@"imageLinks"];
            self.bookCoverImageView.image = coverImages ? [self getBookCoverImage:coverImages] : [UIImage systemImageNamed:@"book"];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    self.postTitleLabel.text = newList.listTitle;
    self.postDescriptionLabel.text = newList.postText;
    [self.ratingLabel setHidden:TRUE];
    self.usernameLabel.text = newList.author.username;
    self.likeCountLabel.text = [newList.likeCount stringValue];
    
    [self setTimeLabel:self.timeLabel];
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

//TODO: Move time formatting function to api manager and set label in calling function
-(void)setTimeLabel:(UILabel *)timeLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    NSString *timeDiff = [self.post.createdAt timeAgoSinceNow];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    timeLabel.text = timeDiff;
}

@end
