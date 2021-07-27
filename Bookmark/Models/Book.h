//
//  Book.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface Book : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *bookID;
@property (nonatomic, strong) NSString *googleBookID;
@property (nonatomic, strong) NSString *coverURL;
@property (nonatomic, strong) NSString *bookTitle;
@property (nonatomic, strong) NSDictionary *bookAuthors;
@property (nonatomic, strong) NSNumber *popularityIndex;
@property (nonatomic, strong) NSNumber *numReviews;
@property (nonatomic, strong) NSNumber *numLists;
@property (nonatomic, strong) NSNumber *avgRating;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

+ (void) postNewBook: ( NSString * _Nullable )bookID withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
