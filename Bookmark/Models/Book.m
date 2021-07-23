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
            newBook.avgRating = volumeInfo[@"averageRating"];
            newBook.numReviews = volumeInfo[@"ratingsCount"];
            newBook.numReviews = @(newBook.numReviews.intValue % 100);

            NSDictionary *coverImages = volumeInfo[@"imageLinks"];
            NSString *urlString = coverImages[@"thumbnail"];
            if([urlString containsString:@"http:"])
            {
                urlString = [urlString substringFromIndex:4];
                urlString = [@"https" stringByAppendingString:urlString];
            }
            newBook.coverURL = urlString;
            [newBook saveInBackgroundWithBlock: completion];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
     self = [super init];
     if (self) {
//
//         NSDictionary *volumeInfo = dictionary[@"volumeInfo"];
//         self.bookTitle = volumeInfo[@"title"];
//
//         NSDictionary *bookAuthorList = volumeInfo[@"authors"];
//         NSMutableArray *authorList = [[NSMutableArray alloc] init];
//         for(id key in bookAuthorList)
//         {
//             [authorList addObject:key];
//         }
//         self.bookAuthors = authorList;
//
//         NSDictionary *coverImages = volumeInfo[@"imageLinks"];
//         NSString *urlString = coverImages[@"thumbnail"];
//         if([urlString containsString:@"http:"])
//         {
//             urlString = [urlString substringFromIndex:4];
//             urlString = [@"https" stringByAppendingString:urlString];
//         }
//
//         self.coverURL = urlString;
//
//         self.publicationDate = volumeInfo[@"publishedDate"];
     }
     return self;
 }

+ (NSMutableArray *)booksWithArray:(NSDictionary *)dictionaries{
    NSMutableArray *books = [NSMutableArray array];
    NSArray *bookResults = dictionaries[@"items"];
    for (NSDictionary *dictionary in bookResults) {
        Book *book = [[Book alloc] initWithDictionary:dictionary];
        [books addObject:book];
    }
    return books;
}

- (UIImage *)getCoverImage {
 
    NSURL *imageURL = [NSURL URLWithString: self.coverURL];
    NSData* imageData = [[NSData alloc] initWithContentsOfURL: imageURL];
    UIImage *bookCoverImage = [UIImage imageWithData: imageData];
    return bookCoverImage;
}

@end
