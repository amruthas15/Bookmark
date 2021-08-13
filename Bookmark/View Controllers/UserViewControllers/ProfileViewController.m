//
//  ProfileViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "ProfileViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "InfiniteScrollActivityView.h"
#import "MBProgressHUD.h"
#import "ProfileCell.h"
#import "FeedCell.h"
@import Parse;

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) InfiniteScrollActivityView *loadingMoreView;
@property (assign, nonatomic) BOOL isMoreDataLoading;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchInitialData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.tableView addSubview:self.loadingMoreView];
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    PFUser *user = [PFUser currentUser];

    //PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    //[query whereKey:@"user" equalTo:user];
    //NSArray *usersPosts = [query findObjects];
    
    [postQuery whereKey:@"author" equalTo:user];
    postQuery.skip = querySkip;

    [postQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            if(posts.count != 0) {
                if(querySkip == 0)
                {
                    self.posts = posts;
                }
                else
                {
                    self.posts = [self.posts arrayByAddingObjectsFromArray:posts];
                }
                [self.tableView reloadData];
            }
            self.isMoreDataLoading = false;
            [self.loadingMoreView stopAnimating];
            [self.refreshControl endRefreshing];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Navigation

- (IBAction)logOutButtonClicked:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
}

#pragma mark - Table View Delegate Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.row == ((NSInteger) 0)) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
        [((ProfileCell*) cell) initWithUser:[PFUser currentUser]];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"feedCell" forIndexPath:indexPath];
        Post *currentPost = self.posts[indexPath.row - 1];
        if(currentPost.reviewStatus.boolValue == TRUE) {
            [((FeedCell*) cell) initWithReview:self.posts[indexPath.row - 1]];
        }
        else if(currentPost.reviewStatus.boolValue == FALSE) {
            [((FeedCell*) cell) initWithList:self.posts[indexPath.row - 1]];
        }
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
            
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            
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
