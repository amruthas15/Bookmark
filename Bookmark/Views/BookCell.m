//
//  BookCell.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/21/21.
//

#import "BookCell.h"
#import "Book.h"
#import "APIManager.h"

@implementation BookCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)initWithDictionary:(NSDictionary *)book {
    self.bookID = book[@"id"];
    
    NSDictionary *volumeInfo = book[@"volumeInfo"];
    self.bookTitleLabel.text = volumeInfo[@"title"];
    
    NSDictionary *bookAuthorList = volumeInfo[@"authors"];
    self.bookAuthorLabel.text = [self getAuthorsOfBook:bookAuthorList];
    
    NSDictionary *coverImages = volumeInfo[@"imageLinks"];
    NSString *urlString = coverImages[@"thumbnail"];
    self.coverPhotoImageView.image = [self getBookCoverImage:urlString];
}

-(void)initWithBook:(Book *)book {
    self.bookID = book.googleBookID;
    self.bookTitleLabel.text = book.bookTitle;
    self.bookAuthorLabel.text = [self getAuthorsOfBook:book.bookAuthors];
    self.coverPhotoImageView.image = [self getBookCoverImage:book.coverURL];
}

-(NSString *)getAuthorsOfBook: (NSDictionary *)bookAuthorList {
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

-(UIImage *)getBookCoverImage: (NSString *)urlString {
    if([urlString containsString:@"http:"])
    {
        urlString = [urlString substringFromIndex:4];
        urlString = [@"https" stringByAppendingString:urlString];
    }
    NSURL *imageURL = [NSURL URLWithString: urlString];
    NSData* imageData = [[NSData alloc] initWithContentsOfURL: imageURL];
    return [UIImage imageWithData: imageData];
}

@end
