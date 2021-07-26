//
//  BookCell.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/21/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface BookCell : UITableViewCell

@property (strong, nonatomic) NSString *googleBookID;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverPhotoImageView;

-(void)initWithDictionary:(NSDictionary *)book;

-(void)initWithBook:(Book *)book;

@end

NS_ASSUME_NONNULL_END
