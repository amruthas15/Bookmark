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

@interface Book : NSObject

@property (nonatomic, strong) NSString *bookID;
@property (nonatomic, strong) NSString *bookTitle;
@property (nonatomic, strong) NSString *bookAuthor;
//@property (nonatomic, strong) PFFileObject *bookCover;


@property (nonatomic, strong) NSNumber *publicationYear;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

@end

NS_ASSUME_NONNULL_END
