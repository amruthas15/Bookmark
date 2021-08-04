//
//  BookSearchPickerViewController.h
//  Bookmark
//
//  Created by Amrutha Srikanth on 7/26/21.
//

#import <UIKit/UIKit.h>
#import "XLFormRowDescriptor.h"


NS_ASSUME_NONNULL_BEGIN

@interface BookSearchPickerViewController : UIViewController
 <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, XLFormRowDescriptorViewController>

@end

NS_ASSUME_NONNULL_END
