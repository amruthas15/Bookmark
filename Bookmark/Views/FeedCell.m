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
#import "Utilities.h"

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
            self.bookCoverImageView.image = coverImages ? [Utilities getBookCoverImageFromDictionary:coverImages] : [UIImage systemImageNamed:@"book"];
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
    
    self.timeLabel.text = [Utilities getTimeText:self.post.createdAt];
}

-(void)initWithList:(Post *)newList {
    _post = newList;
    [[APIManager shared] getBookInformation:[newList.arrayOfBookIDs objectAtIndex:0] completion:^(NSDictionary *book, NSError *error) {
        if (book) {
            NSDictionary *volumeInfo = book[@"volumeInfo"];
            NSDictionary *coverImages = volumeInfo[@"imageLinks"];
            self.bookCoverImageView.image = coverImages ? [Utilities getBookCoverImageFromDictionary:coverImages] : [UIImage systemImageNamed:@"book"];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    self.postTitleLabel.text = newList.listTitle;
    self.postDescriptionLabel.text = newList.postText;
    [self.ratingLabel setHidden:TRUE];
    self.usernameLabel.text = newList.author.username;
    self.likeCountLabel.text = [newList.likeCount stringValue];
    
    self.timeLabel.text = [Utilities getTimeText:self.post.createdAt];
}

@end
