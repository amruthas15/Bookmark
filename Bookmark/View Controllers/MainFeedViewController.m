//
//  MainFeedViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "MainFeedViewController.h"
#import "FeedCell.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "Book.h"
#import "ReviewDetailsViewController.h"
#import "ListDetailsViewController.h"
#import "PostCreationViewController.h"

@interface MainFeedViewController () <UITableViewDelegate, UITableViewDataSource, PostCreationViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *posts;


@end

@implementation MainFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchData];
    
    //TODO: get rid of following book posting once posting functionality through form is finished
//    [Book postNewBook:@"J74zCwAAQBAJ" withCompletion:(PFBooleanResultBlock)^(BOOL succeeded, NSError *error) {
//        NSLog(@"Book out");
//    }];
//    NSArray *bookList = [[NSArray alloc] initWithObjects:@"uU3sPAAACAAJ", @"l51szQEACAAJ", nil];
//    [Post postNewList:@"Wow" withBooks:bookList withDescription:@"Wow" withCompletion:(PFBooleanResultBlock)^(BOOL succeeded, NSError *error) {
//        NSLog(@"Book out");
//    }];
}

-(void)fetchData {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"createdAt"];
    postQuery.limit = 20;

    [postQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = posts;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)composeButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"postSegue" sender:nil];
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([sender isKindOfClass:[UITableViewCell class]])
     {
         UITableViewCell *tappedCell = sender;
         NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
         Post *currentPost = self.posts[indexPath.row];
         
         if([segue.identifier isEqualToString: @"feedReviewCellSegue"]) {
             ReviewDetailsViewController *reviewDetailsViewController = [segue destinationViewController];
             reviewDetailsViewController.review = currentPost;
         }
         else if([segue.identifier isEqualToString: @"feedListCellSegue"]){
             ListDetailsViewController *listDetailsViewController = [segue destinationViewController];
             listDetailsViewController.list = currentPost;
         }
     }
     else if ([segue.identifier isEqualToString: @"postSegue"])
     {
         UINavigationController *navigationController = [segue destinationViewController];
         PostCreationViewController *postCreationViewController = (PostCreationViewController*)navigationController.topViewController;
         postCreationViewController.delegate = self;

     }
 }

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedCell" forIndexPath:indexPath];
    Post *currentPost = self.posts[indexPath.row];
    
    if(currentPost.reviewStatus.boolValue == TRUE) {
        [cell initWithReview:self.posts[indexPath.row]];
    }
    else if(currentPost.reviewStatus.boolValue == FALSE) {
        [cell initWithList:self.posts[indexPath.row]];
    }

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *currentPost = self.posts[indexPath.row];
    if(currentPost.reviewStatus.boolValue){
        [self performSegueWithIdentifier:@"feedReviewCellSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    else {
        [self performSegueWithIdentifier:@"feedListCellSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
}
- (void)didPost {
    [self fetchData];
}

@end
