//
//  FeedCell.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/14/21.
//

#import "FeedCell.h"
#import "Post.h"
#import "DateTools.h"

@implementation FeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initWithReview:(Post *)newReview {
    _post = newReview;
    //self.bookCoverImageView.file = newReview.book[@"bookCover"];
    //[self.photoImageView loadInBackground];

    self.postTitleLabel.text = newReview.book.bookTitle;
    self.postDescriptionTextView.text = newReview.postText;
    [self.ratingLabel setHidden:FALSE];
    self.ratingLabel.text = [[newReview.rating stringValue] stringByAppendingString:@"★"];
    self.usernameLabel.text = newReview.author.username;
    self.likeCountLabel.text = [newReview.likeCount stringValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    NSString *timeDiff = [self.post.createdAt timeAgoSinceNow];
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    // Convert Date to String
    self.timeLabel.text = timeDiff;
}

-(void)initWithList:(Post *)newList {
    _post = newList;
    //self.bookCoverImageView.file = newReview.book[@"bookCover"];
    //[self.photoImageView loadInBackground];
    self.postTitleLabel.text = newList.listTitle;
    self.postDescriptionTextView.text = newList.postText;
    [self.ratingLabel setHidden:TRUE];
    self.usernameLabel.text = newList.author.username;
    self.likeCountLabel.text = [newList.likeCount stringValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    NSString *timeDiff = [self.post.createdAt timeAgoSinceNow];
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    // Convert Date to String
    self.timeLabel.text = timeDiff;
}

@end
