//
//  ProfileCell.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 8/12/21.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
@import Parse;


NS_ASSUME_NONNULL_BEGIN

@interface ProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *biographyLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *listCountLabel;

- (void)initWithUser: (PFUser *)currentUser;

@end

NS_ASSUME_NONNULL_END
