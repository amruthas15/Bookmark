//
//  BookCell.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/21/21.
//

#import "BookCell.h"
#import "Book.h"
#import "APIManager.h"
#import "Utilities.h"

@implementation BookCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)initWithDictionary:(NSDictionary *)book {
    self.googleBookID = book[@"id"];
    
    NSDictionary *volumeInfo = book[@"volumeInfo"];
    self.bookTitleLabel.text = volumeInfo[@"title"];
    
    NSDictionary *bookAuthorList = volumeInfo[@"authors"];
    self.bookAuthorLabel.text = [self getAuthorsOfBook:bookAuthorList];
    
    NSDictionary *coverImages = volumeInfo[@"imageLinks"];
    self.coverPhotoImageView.image = coverImages ? [Utilities getBookCoverImageFromDictionary:coverImages] : [UIImage systemImageNamed:@"book"];
}

-(void)initWithBook:(Book *)book {
    self.googleBookID = book.googleBookID;
    self.bookTitleLabel.text = book.bookTitle;
    self.bookAuthorLabel.text = [self getAuthorsOfBook:book.bookAuthors];
    self.coverPhotoImageView.image = book.coverURL ? [Utilities getBookCoverImageFromString:book.coverURL]: [UIImage systemImageNamed:@"book"];
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

@end
