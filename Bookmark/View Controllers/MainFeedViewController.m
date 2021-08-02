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
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;


@end

@implementation MainFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchInitialData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
        
    [self fetchInitialData];
}

-(void)fetchInitialData {
    [self fetchMoreData:0];
}

-(void)fetchMoreData:(NSInteger *)querySkip {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"createdAt"];
    postQuery.limit = 20;
    postQuery.skip = querySkip;

    [postQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            if(querySkip == 0)
            {
                self.posts = posts;
            }
            else
            {
                self.posts = [self.posts arrayByAddingObjectsFromArray:posts];
            }
            self.isMoreDataLoading = false;
            [self.tableView reloadData];
            
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
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

- (void)didPost {
    [self fetchInitialData];
}
- (IBAction)didPanCell:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:self.tableView];
        NSIndexPath *cellIndexPath = [self.tableView indexPathForRowAtPoint:location];
        UITableViewCell *tappedCell = [self.tableView cellForRowAtIndexPath:cellIndexPath];
        Post *currentPost = self.posts[cellIndexPath.row];
        if(currentPost.reviewStatus.boolValue){
            [self performSegueWithIdentifier:@"feedReviewCellSegue" sender:tappedCell];
        }
        else {
            [self performSegueWithIdentifier:@"feedListCellSegue" sender:tappedCell];
        }
    }
}

#pragma mark - Table View Delegate Methods

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

#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
            
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self fetchMoreData:self.posts.count];
        }
    }
    
    NSArray *visibleCells = [self.tableView visibleCells];

    if (visibleCells != nil  &&  [visibleCells count] != 0) {

        UITableViewCell *topCell = [visibleCells objectAtIndex:0];
        UITableViewCell *bottomCell = [visibleCells lastObject];

        
        for (UITableViewCell *cell in visibleCells) {
            cell.contentView.alpha = 1.0;
        }

        NSInteger cellHeight = topCell.frame.size.height - 1;
        NSInteger tableViewTopPosition = self.tableView.frame.origin.y;
        NSInteger tableViewBottomPosition = self.tableView.frame.origin.y + self.tableView.frame.size.height;

        CGRect topCellPositionInTableView = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:topCell]];
        CGRect bottomCellPositionInTableView = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:bottomCell]];
        CGFloat topCellPosition = [self.tableView convertRect:topCellPositionInTableView toView:[self.tableView superview]].origin.y;
        CGFloat bottomCellPosition = ([self.tableView convertRect:bottomCellPositionInTableView toView:[self.tableView superview]].origin.y + cellHeight);

        CGFloat fadingModifier = 1.5;
        CGFloat topCellOpacity = (1.0f - ((tableViewTopPosition - topCellPosition) / cellHeight) * fadingModifier);
        CGFloat bottomCellOpacity = (1.0f - ((bottomCellPosition - tableViewBottomPosition) / cellHeight) * fadingModifier);

        if (topCell) {
            topCell.contentView.alpha = topCellOpacity;
        }
        if (bottomCell) {
            bottomCell.contentView.alpha = bottomCellOpacity;
        }
    }
}

@end
