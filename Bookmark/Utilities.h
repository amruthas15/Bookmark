//
//  Utilities.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/26/21.
//

#ifndef Utilities_h
#define Utilities_h
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

+(UIImage *)getBookCoverImageFromDictionary: (NSDictionary *)coverImages;

+(UIImage *)getBookCoverImageFromString: (NSString *)urlString;

+(NSString *)getTimeText:(NSDate *)timeCreated;

@end

#endif /* Utilities_h */

