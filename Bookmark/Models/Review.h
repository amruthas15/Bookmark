//
//  Review.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Review : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *reviewID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) Book *book;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *reviewText;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;


+ (void) postNewReview: ( NSString * _Nullable )review withBook: ( Book * _Nullable )book withRating: (NSNumber *)rating withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
