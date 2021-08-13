//
//  ProfileViewController.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "FeedCell.h"

@protocol FeedCellProtocol

-(void)didLike: (FeedCell *)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController <UIScrollViewDelegate>

@end

NS_ASSUME_NONNULL_END
