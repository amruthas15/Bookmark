//
//  List.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface List : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *listID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) NSArray<Book *> *books;
@property (nonatomic, strong) NSString *listTitle;
@property (nonatomic, strong) NSString *listText;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

+ (void) postNewList: ( NSString * _Nullable )listTitle withBooks: ( NSArray<Book *>* _Nullable )books withDescription: ( NSString * _Nullable )listText withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
