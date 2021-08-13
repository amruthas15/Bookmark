//
//  ProfileCell.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 8/12/21.
//

#import "ProfileCell.h"

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithUser: (PFUser *)currentUser {
    self.usernameLabel.text = currentUser.username;

    self.profileImageView.file = currentUser[@"profileImage"];
    self.profileImageView.layer.cornerRadius = 20;
    [self.profileImageView loadInBackground];
    self.biographyLabel.text = currentUser[@"bioText"];
    self.reviewCountLabel.text = [currentUser[@"reviewCount"] stringValue];
    self.listCountLabel.text = [currentUser[@"listCount"] stringValue];
}

@end
