//
//  Book.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "Book.h"
#import "APIManager.h"

@implementation Book

@dynamic bookID;
@dynamic googleBookID;
@dynamic coverURL;
@dynamic bookTitle;
@dynamic bookAuthors;
@dynamic popularityIndex;
@dynamic numReviews;
@dynamic numLists;
@dynamic avgRating;

@dynamic createdAt;
@dynamic updatedAt;

+ (nonnull NSString *)parseClassName {
    return @"Book";
}

+ (void) postNewBook: ( NSString * _Nullable )bookID withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    Book *newBook = [Book new];
    newBook.googleBookID = bookID;
    
    [[APIManager shared] getBookInformation:bookID completion:^(NSDictionary *book, NSError *error) {
        if (book) {
            NSDictionary *volumeInfo = book[@"volumeInfo"];
            NSDictionary *coverImages = volumeInfo[@"imageLinks"];
            if(coverImages) {
                NSString *urlString = coverImages[@"thumbnail"];
                if([urlString containsString:@"http:"])
                {
                    urlString = [urlString substringFromIndex:4];
                    urlString = [@"https" stringByAppendingString:urlString];
                }
                newBook.coverURL = urlString;
            }
            newBook.bookTitle = volumeInfo[@"title"];
            newBook.bookAuthors = volumeInfo[@"authors"];
            
            newBook.numReviews = volumeInfo[@"ratingsCount"];
            newBook.numReviews = @(newBook.numReviews.intValue % 100);
            newBook.avgRating = volumeInfo[@"averageRating"] ?: @(3);
            newBook.popularityIndex = @(pow(newBook.avgRating.floatValue - 1, newBook.numReviews.floatValue / 10));
            [newBook saveInBackgroundWithBlock: completion];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
