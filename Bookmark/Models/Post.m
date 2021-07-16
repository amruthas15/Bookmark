//
//  Post.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/15/21.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic reviewStatus;

@dynamic book;
@dynamic rating;

@dynamic books;
@dynamic listTitle;

@dynamic postText;
@dynamic likeCount;
@dynamic createdAt;
@dynamic updatedAt;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postNewReview: ( NSString * _Nullable )review withBook: ( Book * _Nullable )book withRating: (NSNumber *)rating withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    
    Post *newReview = [Post new];
    newReview.author = [PFUser currentUser];
    newReview.reviewStatus = @(YES);
    newReview.book = book;
    newReview.rating = rating;
    newReview.postText = review;
    newReview.likeCount = @(0);
    
    [newReview saveInBackgroundWithBlock: completion];
}

+ (void) postNewList: ( NSString * _Nullable )listTitle withBooks: ( NSArray<Book *>* _Nullable )books withDescription: ( NSString * _Nullable )listText withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newList = [Post new];
    newList.author = [PFUser currentUser];
    newList.reviewStatus = @(NO);
    newList.books = books;
    newList.listTitle = listTitle;
    newList.postText = listText;
    newList.likeCount = @(0);
    
    [newList saveInBackgroundWithBlock: completion];
}

@end
