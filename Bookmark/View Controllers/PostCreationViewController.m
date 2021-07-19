//
//  PostCreationViewController.m
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/13/21.
//

#import "PostCreationViewController.h"
#import "Post.h"

@interface PostCreationViewController ()

@end

@implementation PostCreationViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [self initializeForm];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm {
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;

    form = [XLFormDescriptor formDescriptorWithTitle:@"New Post"];

    // Main section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    // Type of Post
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"postType" rowType:@"selectorSegmentedControl" title:@"Post Type"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Review"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"List"]
                            ];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Review"];
    [section addFormRow:row];

    // Review Section
    section = [XLFormSectionDescriptor formSection];
    section.hidden = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"($postType.value.formValue == 1)"]];;
    [form addFormSection:section];
    
    //Book Picker
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"reviewBook" rowType:@"text" title:@"Book-Picking Placeholder for Review"];
    [section addFormRow:row];

    //Rating
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ratingStep" rowType:@"stepCounter" title:@"Book Rating (1-5 stars)"];
        row.value = @3;
        [row.cellConfigAtConfigure setObject:@YES forKey:@"stepControl.wraps"];
        [row.cellConfigAtConfigure setObject:@1 forKey:@"stepControl.stepValue"];
        [row.cellConfigAtConfigure setObject:@1 forKey:@"stepControl.minimumValue"];
        [row.cellConfigAtConfigure setObject:@5 forKey:@"stepControl.maximumValue"];
    [section addFormRow:row];
    
    //Review Text
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"reviewText" rowType:@"textView" title:@"Review:"];
    [section addFormRow:row];

    // List Section
    section = [XLFormSectionDescriptor formSection];
    section.hidden = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"($postType.value.formValue == 0)"]];;
    [form addFormSection:section];

    //List Title
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"listTitle" rowType:@"text" title:@"List Title"];
    [section addFormRow:row];
    
    //List Text
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"listText" rowType:@"textView" title:@"Description:"];
    [section addFormRow:row];
    
    //Books Picker
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"listBooks" rowType:@"text" title:@"Book-Picking Placeholder for List"];
    [section addFormRow:row];
    

    self.form = form;
}

- (IBAction)confirmPostButtonClicked:(id)sender {
    NSDictionary *formResults = [self.form formValues];
    NSString *postType = [formResults valueForKey:@"postType"];
    if(postType.intValue == 0){
        NSString *reviewText = [formResults valueForKey:@"reviewText"];
        NSNumber *reviewRating = [formResults valueForKey:@"ratingStep"];
        [Post postNewReview:reviewText withBook:Nil withRating:reviewRating withCompletion:(PFBooleanResultBlock)^(BOOL succeeded, NSError *error) {
            [self dismissViewControllerAnimated:true completion:nil];
        }];
    }
    else if(postType.intValue == 1){
        NSString *listTitle = [formResults valueForKey:@"listTitle"];
        NSString *listText = [formResults valueForKey:@"listText"];
        [Post postNewList:listTitle withBooks:Nil withDescription:listText withCompletion:(PFBooleanResultBlock)^(BOOL succeeded, NSError *error) {
            [self dismissViewControllerAnimated:true completion:nil];
        }];
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
