//
//  Utilities.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/26/21.
//

#import <Foundation/Foundation.h>
#import "Utilities.h"
#import <UIKit/UIKit.h>
#import "DateTools.h"

@implementation Utilities

+(UIImage *)getBookCoverImageFromDictionary: (NSDictionary *)coverImages {
    NSString *urlString = coverImages[@"thumbnail"];
    return [Utilities getBookCoverImageFromString:urlString];
}

+(UIImage *)getBookCoverImageFromString: (NSString *)urlString {
    if([urlString containsString:@"http:"])
    {
        urlString = [urlString substringFromIndex:4];
        urlString = [@"https" stringByAppendingString:urlString];
    }
    NSURL *imageURL = [NSURL URLWithString: urlString];
    NSData* imageData = [[NSData alloc] initWithContentsOfURL: imageURL];
    return [UIImage imageWithData: imageData];
}

+(NSString *)getTimeText:(NSDate *)timeCreated {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    NSString *timeDiff = [timeCreated timeAgoSinceNow];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    return timeDiff;
}

+(NSString *)getAuthorsOfBook: (NSDictionary *)bookAuthorList {
    NSString *authorString = @" ";
    long additionalAuthors = bookAuthorList.count - 1;
    for(id key in bookAuthorList)
    {
        authorString = [authorString stringByAppendingString:key];
        if(additionalAuthors > 0)
        {
            authorString = [authorString stringByAppendingString:@", "];
        }
        additionalAuthors--;
    }
    return authorString;
}

@end
