//
//  Book.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "Book.h"

@implementation Book

@dynamic bookID;
@dynamic bookTitle;
@dynamic bookAuthors;
@dynamic bookCover;

@dynamic publicationDate;
@dynamic createdAt;
@dynamic updatedAt;

+ (nonnull NSString *)parseClassName {
    return @"Book";
}

//+ (void) postNewBook: ( NSString * _Nullable )listTitle withBooks: ( NSArray<Book *>* _Nullable )books withDescription: ( NSString * _Nullable )listText withCompletion: (PFBooleanResultBlock  _Nullable)completion {
//
//    List *newList = [List new];
//    newList.author = [PFUser currentUser];
//    newList.books = books;
//    newList.listTitle = listTitle;
//    newList.listText = listText;
//    newList.likeCount = @(0);
//
//    [newList saveInBackgroundWithBlock: completion];
//}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
     self = [super init];
     if (self) {
         
         NSDictionary *volumeInfo = dictionary[@"volumeInfo"];
         self.bookTitle = volumeInfo[@"title"];
         
         NSDictionary *bookAuthorList = volumeInfo[@"authors"];
         NSMutableArray *authorList = [[NSMutableArray alloc] init];
         for(id key in bookAuthorList)
         {
             [authorList addObject:key];
         }
         self.bookAuthors = authorList;
         
         NSDictionary *coverImages = volumeInfo[@"imageLinks"];
         NSString *urlString = coverImages[@"thumbnail"];
         if([urlString containsString:@"http:"])
         {
             urlString = [urlString substringFromIndex:4];
             urlString = [@"https" stringByAppendingString:urlString];
         }
         NSURL *imageURL = [NSURL URLWithString: urlString];
         NSData* imageData = [[NSData alloc] initWithContentsOfURL: imageURL];
         UIImage *bookCoverImage = [UIImage imageWithData: imageData];
         self.bookCover = [self getPFFileFromImage:bookCoverImage];
         
         self.publicationDate = volumeInfo[@"publishedDate"];
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

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
