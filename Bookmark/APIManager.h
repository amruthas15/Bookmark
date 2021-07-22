//
//  APIManager.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/20/21.
//

#import "AFNetworking.h"

@interface APIManager : AFHTTPSessionManager

+ (instancetype)shared;

- (void)getBookSearchQueries:(NSString *)searchQuery completion:(void(^)(NSArray *books, NSError *error))completion;

- (void)getBookInformation:(NSString *)bookID completion:(void(^)(NSDictionary *book, NSError *error))completion;

@end
