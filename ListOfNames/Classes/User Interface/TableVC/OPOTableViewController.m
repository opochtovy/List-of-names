//
//  OPOTableViewController.m
//  ListOfNames
//
//  Created by Aleh Pachtovy on 8/26/18.
//  Copyright © 2018 Aleh Pachtovy. All rights reserved.
//

#import "OPOTableViewController.h"
#import "OPOTableVM.h"

@interface OPOTableViewController ()

@property (nonatomic) OPOTableVM *viewModel;

@end

@implementation OPOTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewModel];
    [self setupNavBarTitle];
}

#pragma mark - Private Methods

-(void)setupViewModel {
    self.viewModel = [[OPOTableVM alloc] init];
}

-(void)setupNavBarTitle {
    self.title = NSLocalizedString(@"table_vc_screen_title", nil);
}

-(void)showPopUpToAddName
{
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *popUp = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"table_vc_popup_title", nil)
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"table_vc_popup_cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf removeObserverForPopUpTextField];
    }];
    UIAlertAction *add = [UIAlertAction actionWithTitle:NSLocalizedString(@"table_vc_popup_add", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *textfields = popUp.textFields;
        UITextField *nameField = textfields[0];
        [weakSelf.viewModel saveAddedName:nameField.text];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.tableView reloadData];
        [weakSelf removeObserverForPopUpTextField];
    }];
    add.enabled = NO;
    
    [popUp addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"table_vc_popup_textfield_placeholder", nil);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            add.enabled = textField.text.length > 0;
        }];
    }];
    
    [popUp addAction:cancel];
    [popUp addAction:add];
    
    [self presentViewController:popUp animated:YES completion:nil];
}

-(void)removeObserverForPopUpTextField {
    [[NSNotificationCenter defaultCenter] removeObserver:UITextFieldTextDidChangeNotification];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSLocalizedString(@"table_vc_reuse_id", nil) forIndexPath:indexPath];
    cell.textLabel.text = [self.viewModel getItemNameFor:indexPath.row];    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - IBActions

-(IBAction)addPressed:(UIBarButtonItem *)sender {
    [self showPopUpToAddName];
}

@end
