//
//  Post.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/15/21.
//

#import "Post.h"
#include <math.h>

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic reviewStatus;

@dynamic bookID;
@dynamic rating;

@dynamic arrayOfBookIDs;
@dynamic listTitle;

@dynamic postText;
@dynamic userLikes;
@dynamic likeCount;
@dynamic createdAt;
@dynamic updatedAt;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postNewReview: ( NSString * _Nullable )review withBook: ( NSString * _Nullable )bookID withRating: (NSNumber *)rating withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    
    Post *newReview = [Post new];
    newReview.author = [PFUser currentUser];
    newReview.reviewStatus = @(YES);
    newReview.rating = rating;
    newReview.postText = review;
    newReview.likeCount = @(0);
    newReview.bookID = bookID;
    
    PFQuery *bookQuery = [Book query];
    [bookQuery whereKey:@"googleBookID" equalTo: bookID];
    bookQuery.limit = 1;
    
    [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
        if (books.count != 0) {
            Book *modelBook = [books firstObject];
            modelBook.numReviews = @([modelBook.numReviews intValue] + 1);
            float rawAvgRating = (([modelBook.avgRating floatValue] * ([modelBook.numReviews intValue] - 1)) + [newReview.rating intValue]) / [modelBook.numReviews intValue];
            modelBook.avgRating = @(roundf(rawAvgRating*10)/10);
            modelBook.popularityIndex = @(pow(modelBook.avgRating.floatValue - 1, modelBook.numReviews.floatValue / 10));
            [modelBook saveInBackgroundWithBlock: completion];
            [newReview saveInBackgroundWithBlock: completion];
        }
        else {
            [Book postNewBook:bookID withCompletion:(PFBooleanResultBlock)^(BOOL succeeded, NSError *error) {
                [newReview saveInBackgroundWithBlock: completion];
            }];
        }
    }];
}

+ (void) postNewList: ( NSString * _Nullable )listTitle withBooks: ( NSArray<NSString *>* _Nullable )arrayOfBookIDs withDescription: ( NSString * _Nullable )listText withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newList = [Post new];
    newList.author = [PFUser currentUser];
    newList.reviewStatus = @(NO);
    newList.arrayOfBookIDs = arrayOfBookIDs;
    newList.listTitle = listTitle;
    newList.postText = listText;
    newList.likeCount = @(0);
    
    for(NSString *bookID in arrayOfBookIDs) {
        PFQuery *bookQuery = [Book query];
        [bookQuery whereKey:@"googleBookID" equalTo: bookID];
        [bookQuery orderByDescending:@"updatedAt"];
        bookQuery.limit = 5;
        
        [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
            if (books.count == 0) {
                [Book postNewBook:bookID withCompletion:(PFBooleanResultBlock)^(BOOL succeeded, NSError *error) {
                }];
            }
        }];
    }
    [newList saveInBackgroundWithBlock: completion];
}

+(void)likePost: (Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    [post addObject:[PFUser currentUser].objectId forKey:@"userLikes"];
    post.likeCount = @([post.likeCount intValue] + 1);
    [post saveInBackgroundWithBlock:completion];
    if([post.reviewStatus boolValue] == true) {
        PFQuery *bookQuery = [Book query];
        [bookQuery whereKey:@"googleBookID" equalTo: post.bookID];
        [bookQuery orderByDescending:@"updatedAt"];
        bookQuery.limit = 1;

        [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
            Book *modelBook = [books firstObject];
            int newPopularityIndex = [modelBook.popularityIndex intValue] + ([post.rating intValue] - 3);
            modelBook.popularityIndex = @(newPopularityIndex);
            [modelBook saveInBackgroundWithBlock: completion];
        }];
    }
}

+(void)unlikePost: (Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    [post removeObject:[PFUser currentUser].objectId forKey:@"userLikes"];
    post.likeCount = @([post.likeCount intValue] - 1);
    [post saveInBackgroundWithBlock:completion];
    if([post.reviewStatus boolValue] == true) {
        PFQuery *bookQuery = [Book query];
        [bookQuery whereKey:@"googleBookID" equalTo: post.bookID];
        [bookQuery orderByDescending:@"updatedAt"];
        bookQuery.limit = 1;

        [bookQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable books, NSError * _Nullable error) {
            Book *modelBook = [books firstObject];
            int newPopularityIndex = [modelBook.popularityIndex intValue] - ([post.rating intValue] - 3);
            modelBook.popularityIndex = @(newPopularityIndex);
            [modelBook saveInBackgroundWithBlock: completion];
        }];
    }
}

@end
