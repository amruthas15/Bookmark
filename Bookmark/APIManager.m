//
//  APIManager.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/20/21.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"
#import "Book.h"

static NSString * const baseURLString = @"https://www.googleapis.com/books/v1/volumes";


@interface APIManager()
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    
    if (self = [super initWithBaseURL:baseURL]) {
        
    }
    return self;
}

- (void)getBookSearchQueries:(NSString *)searchQuery completion:(void(^)(NSArray *books, NSError *error))completion {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *formattedQuery = [searchQuery stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *urlString = [baseURLString stringByAppendingString: @"?q="];
    urlString = [urlString stringByAppendingString:[formattedQuery stringByAppendingString:@"&maxResults=20"]];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                   uploadProgress:nil
                                                 downloadProgress:nil
                                                completionHandler:^(NSURLResponse *response, NSDictionary *  _Nullable bookDictionaries, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"Error: %@", error);
                                                        } else {
                                                            NSLog(@"%@ %@", response, bookDictionaries);
                                                            NSMutableArray *bookResults = bookDictionaries[@"items"];
                                                            
                                                            completion(bookResults, nil);
                                                        }
                                                }];
    [dataTask resume];
}

- (void)getBookInformation:(NSString *)bookID completion:(void(^)(NSDictionary *book, NSError *error))completion {
    if(bookID)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSString *urlString = [baseURLString stringByAppendingString:[@"/" stringByAppendingString:bookID]];
        
        NSURL *URL = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                       uploadProgress:nil
                                                     downloadProgress:nil
                                                    completionHandler:^(NSURLResponse *response, NSDictionary *  _Nullable bookDictionary, NSError *error) {
                                                            if (error) {
                                                                NSLog(@"Error: %@", error);
                                                            } else {
                                                                NSLog(@"%@ %@", response, bookDictionary);
                                                                
                                                                completion(bookDictionary, nil);
                                                            }
                                                    }];
        [dataTask resume];
    }
}
@end
