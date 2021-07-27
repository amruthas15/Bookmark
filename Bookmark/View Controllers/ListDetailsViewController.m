//
//  ListDetailsViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/19/21.
//

#import "ListDetailsViewController.h"
#import "DateTools.h"
#import "Utilities.h"

@interface ListDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *listTitle;
@property (weak, nonatomic) IBOutlet UILabel *postDescriptionTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ListDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameLabel.text = self.list.author.username;
    self.listTitle.text = self.list.listTitle;
    self.postDescriptionTextView.text = self.list.postText;
    
    self.timeLabel.text = [Utilities getTimeText:self.list.createdAt];
    
    //TODO: Add collection view of books in list
}

@end
