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
@property (nonatomic, strong) NSString *bookTitle;
@property (nonatomic, strong) NSArray *bookAuthors;
@property (nonatomic, strong) PFFileObject *bookCover;


@property (nonatomic, strong) NSNumber *publicationDate;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)booksWithArray:(NSDictionary *)dictionaries;

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END
