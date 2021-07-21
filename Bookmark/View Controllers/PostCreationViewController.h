//
//  PostCreationViewController.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "XLForm.h"
#import "XLFormViewController.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostCreationViewControllerDelegate

-(void)didPost;

@end

@interface PostCreationViewController : XLFormViewController
@property (nonatomic, weak) id<PostCreationViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
