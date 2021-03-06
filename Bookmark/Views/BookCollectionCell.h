//
//  PopularCollectionCell.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/22/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImageView;
@property (weak, nonatomic) IBOutlet UITextField *rankingLabel;
@property (weak, nonatomic) NSString *googleBookID;


@end

NS_ASSUME_NONNULL_END
