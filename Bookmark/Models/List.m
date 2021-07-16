//
//  List.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "List.h"

@implementation List

@dynamic listID;
@dynamic userID;
@dynamic author;

@dynamic books;
@dynamic listTitle;
@dynamic listText;
@dynamic likeCount;
@dynamic createdAt;
@dynamic updatedAt;

+ (nonnull NSString *)parseClassName {
    return @"List";
}

+ (void) postNewList: ( NSString * _Nullable )listTitle withBooks: ( NSArray<Book *>* _Nullable )books withDescription: ( NSString * _Nullable )listText withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    List *newList = [List new];
    newList.author = [PFUser currentUser];
    newList.books = books;
    newList.listTitle = listTitle;
    newList.listText = listText;
    newList.likeCount = @(0);
    
    [newList saveInBackgroundWithBlock: completion];
}

@end
