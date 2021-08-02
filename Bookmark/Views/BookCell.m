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
    self.bookAuthorLabel.text = [Utilities getAuthorsOfBook:bookAuthorList];
    
    NSDictionary *coverImages = volumeInfo[@"imageLinks"];
    self.coverPhotoImageView.image = coverImages ? [Utilities getBookCoverImageFromDictionary:coverImages] : [[UIImage systemImageNamed:@"book"] imageWithTintColor:[UIColor colorNamed:@"MediumDarkAccentColor"]];
}

-(void)initWithBook:(Book *)book {
    self.googleBookID = book.googleBookID;
    self.bookTitleLabel.text = book.bookTitle;
    self.bookAuthorLabel.text = [Utilities getAuthorsOfBook:book.bookAuthors];
    self.coverPhotoImageView.image = book.coverURL ? [Utilities getBookCoverImageFromString:book.coverURL] : [[UIImage systemImageNamed:@"book"] imageWithTintColor:[UIColor colorNamed:@"MediumDarkAccentColor"]];}

@end
