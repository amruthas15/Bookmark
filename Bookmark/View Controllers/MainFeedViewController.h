//
//  MainFeedViewController.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "FeedCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FeedCellProtocol

-(void)didLike: (FeedCell *)cell;

@end

@interface MainFeedViewController : UIViewController <UIScrollViewDelegate>

@end

NS_ASSUME_NONNULL_END
