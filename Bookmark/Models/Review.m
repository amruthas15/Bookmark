//
//  Review.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "Review.h"

@implementation Review

@dynamic reviewID;
@dynamic userID;
@dynamic author;

@dynamic book;
@dynamic rating;
@dynamic reviewText;
@dynamic likeCount;
@dynamic createdAt;
@dynamic updatedAt;

+ (nonnull NSString *)parseClassName {
    return @"Review";
}

+ (void) postNewReview: ( NSString * _Nullable )review withBook: ( Book * _Nullable )book withRating: (NSNumber *)rating withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    
    Review *newReview = [Review new];
    newReview.author = [PFUser currentUser];
    newReview.book = book;
    newReview.rating = rating;
    newReview.reviewText = review;
    newReview.likeCount = @(0);
    
    [newReview saveInBackgroundWithBlock: completion];
}

@end
