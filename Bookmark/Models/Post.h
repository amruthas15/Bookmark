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

@property (nonatomic, strong) NSString *bookID;
@property (nonatomic, strong) NSNumber *rating;

@property (nonatomic, strong) NSArray<NSString *> *arrayOfBookIDs;
@property (nonatomic, strong) NSString *listTitle;

@property (nonatomic, strong) NSString *postText;
@property (nonatomic, strong) NSArray<NSString *> *userLikes;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

+ (void) postNewReview: ( NSString * _Nullable )review withBook: ( NSString * _Nullable )bookID withRating: (NSNumber *)rating withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void) postNewList: ( NSString * _Nullable )listTitle withBooks: ( NSArray<NSString *>* _Nullable )arrayOfBookIDs withDescription: ( NSString * _Nullable )listText withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+(void)likePost: (Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+(void)unlikePost: (Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
