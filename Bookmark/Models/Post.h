//
//  Post.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/15/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSNumber *reviewStatus;

@property (nonatomic, strong) Book *book;
@property (nonatomic, strong) NSNumber *rating;

@property (nonatomic, strong) NSArray<Book *> *books;
@property (nonatomic, strong) NSString *listTitle;

@property (nonatomic, strong) NSString *postText;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

+ (void) postNewReview: ( NSString * _Nullable )review withBook: ( Book * _Nullable )book withRating: (NSNumber *)rating withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void) postNewList: ( NSString * _Nullable )listTitle withBooks: ( NSArray<Book *>* _Nullable )books withDescription: ( NSString * _Nullable )listText withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
