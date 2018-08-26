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

@property (weak, nonatomic) IBOutlet UIButton *btnSort;

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
        [weakSelf updateSortButton];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.tableView reloadData];
        [weakSelf removeObserverForPopUpTextField];
    }];
    add.enabled = NO;
    
    [popUp addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"table_vc_popup_textfield_placeholder", nil);
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
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

-(void)updateSortButton {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:[self.viewModel getNameForSortButton] style:UIBarButtonItemStylePlain target:self action:@selector(sortPressed:)];
    self.navigationItem.leftBarButtonItem = leftItem;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel deleteItemFor:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - IBActions

-(IBAction)addPressed:(UIBarButtonItem *)sender {
    [self showPopUpToAddName];
}

-(IBAction)sortPressed:(UIBarButtonItem *)sender {
    [self.viewModel changeListSorting];
    [self updateSortButton];
    [self.tableView reloadData];
}

@end
