//
//  PostCreationViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "PostCreationViewController.h"
#import "Review.h"
#import "List.h"
#import "Post.h"

@interface PostCreationViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *postTypeSegmentControl;

@end

@implementation PostCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)typePickedAndNextButtonClicked:(id)sender {
    [self.postTypeSegmentControl setHidden:TRUE];
}

- (IBAction)confirmPostButtonClicked:(id)sender {
    if(self.postTypeSegmentControl.selectedSegmentIndex == 0){
        [Post postNewReview:@"SwitchTestReview" withBook:Nil withRating:@2 withCompletion:(PFBooleanResultBlock)^(BOOL succeeded, NSError *error) {
                //[self performSegueWithIdentifier:@"feedSegue" sender:nil];

            }
         ];
    } else {
        [Post postNewList:@"SwitchTestList" withBooks:Nil withDescription:@"Very Fun Books" withCompletion:(PFBooleanResultBlock)^(BOOL succeeded, NSError *error) {
            //            //[self performSegueWithIdentifier:@"feedSegue" sender:nil];
            //
                    }
            ];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
