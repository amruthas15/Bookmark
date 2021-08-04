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

-(void)prepareForReuse{
    [super prepareForReuse];
    self.usernameLabel.text = @"";
    self.timeLabel.text = @"";
    self.postTitleLabel.text = @"";
    self.postDescriptionLabel.text = @"";
    self.likeCountLabel.text = @"";

    self.bookCoverImageView.image = [UIImage systemImageNamed:@"book"];
    self.ratingLabel.text = @"";
}

-(void)initWithReview:(Post *)newReview {
    _post = newReview;
    PFQuery *bookQuery = [Book query];
    [bookQuery whereKey:@"googleBookID" equalTo: newReview.bookID];
    [bookQuery orderByDescending:@"updatedAt"];
    bookQuery.limit = 1;
    
    [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
        if (books) {
            Book *book = [books firstObject];
            self.postTitleLabel.text = book.bookTitle;
            self.bookCoverImageView.image = book.coverURL ? [Utilities getBookCoverImageFromString:book.coverURL] : [UIImage systemImageNamed:@"book"];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    self.postDescriptionLabel.text = newReview.postText;
    [self.ratingLabel setHidden:FALSE];
    self.ratingLabel.text = [[newReview.rating stringValue] stringByAppendingString:@"★"];
    self.usernameLabel.text = newReview.author.username;
    self.timeLabel.text = [Utilities getTimeText:self.post.createdAt];
    
    self.likeCountLabel.text = [newReview.likeCount stringValue];
    if([newReview.likeCount intValue] > 0)
    {
        BOOL check = [newReview.userLikes containsObject:[PFUser currentUser].objectId];
        if(check) {
            NSLog(@"Yes");
        } else {
            NSLog(@"No");
        }
        self.likeButton.selected = check;
    }
}

-(void)initWithList:(Post *)newList {
    _post = newList;
    PFQuery *bookQuery = [Book query];
    [bookQuery whereKey:@"googleBookID" equalTo: [newList.arrayOfBookIDs firstObject]];
    [bookQuery orderByDescending:@"updatedAt"];
    bookQuery.limit = 1;

    [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
        if (books) {
            Book *book = [books firstObject];
            self.bookCoverImageView.image = book.coverURL ? [Utilities getBookCoverImageFromString:book.coverURL] : [UIImage systemImageNamed:@"book"];
        }
        else {
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

- (IBAction)didTapLikeButton:(id)sender {
    if(self.likeButton.selected) {
        self.likeButton.selected = false;
        self.likeCountLabel.text = [NSString stringWithFormat:@"%d",([self.likeCountLabel.text intValue] - 1)];
        //[self.likeButton setSelected:false];
        [Post unlikePost:_post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
              if(succeeded) {
                  NSLog(@"Yes");
              } else {
                  NSLog(@"No");
              }
        }];
    } else {
        self.likeButton.selected = true;
        //[self.likeButton setSelected:false];
        self.likeCountLabel.text = [NSString stringWithFormat:@"%d",([self.likeCountLabel.text intValue] + 1)];
        [Post likePost:_post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
              if(succeeded) {
                  NSLog(@"Yes");
              } else {
                  NSLog(@"No");
              }
        }];
    }
}


@end
