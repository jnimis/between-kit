//
//  FluidUIViewController.m
//  19. Fluid UI
//
//  Created by Stephen Fortune on 28/12/2014.
//  Copyright (c) 2014 IceCube Software Ltd. All rights reserved.
//

#import "FluidUIViewController.h"
#import "FormButtonCell.h"
#import "FormTextFieldCell.h"
#import "FormTextAreaCell.h"
#import "FormSwitchCell.h"
#import "FormItem.h"
#import <BetweenKit/I3GestureCoordinator.h>
#import <BetweenKit/I3BasicRenderDelegate.h>


static NSString* DequeueReusableCell = @"DequeueReusableCell";

NSString *const kCommentsIcon = @"icon_comments.png";
NSString *const kCubeIcon = @"icon_cube.png";
NSString *const kBombIcon = @"icon_bomb.png";
NSString *const kBugIcon = @"icon_bug.png";
NSString *const kBellIcon = @"icon_bell.png";
NSString *const kPlusTextFieldIcon = @"icon_plus_text_field.png";
NSString *const kPlusTextAreaIcon = @"icon_plus_text_area.png";
NSString *const kPlusButtonIcon = @"icon_plus_button.png";
NSString *const kPlusSwitchIcon = @"icon_plus_switch.png";


@interface FluidUIViewController ()

@property (nonatomic, strong) NSMutableArray *tlToolbarItems;

@property (nonatomic, strong) NSMutableArray *bToolbarItems;

@property (nonatomic, strong) NSMutableArray *formItems;

@property (nonatomic, strong) NSArray *arbitraryIconNames;

@property (nonatomic, strong) I3GestureCoordinator *dragCoordinator;

@property (nonatomic, strong) UILongPressGestureRecognizer *recognizer;

@end


@implementation FluidUIViewController

-(void) viewDidLoad{

    [super viewDidLoad];

    
    /// Setup the data arrays
    
    self.tlToolbarItems = [NSMutableArray arrayWithArray:@[kCommentsIcon, kCubeIcon, kBombIcon, kBugIcon, kBellIcon]];
    self.bToolbarItems = [NSMutableArray arrayWithArray:@[kPlusTextFieldIcon, kPlusTextAreaIcon, kPlusButtonIcon, kPlusSwitchIcon]];
    self.formItems = [[NSMutableArray alloc] init];
    self.arbitraryIconNames = @[kCommentsIcon, kCubeIcon, kBombIcon, kBugIcon, kBellIcon];
    
    
    /// Setup the collection views and table view
    
    self.tlToolbarCollection.delegate = self;
    self.tlToolbarCollection.dataSource = self;
    
    self.bToolbarCollection.delegate = self;
    self.bToolbarCollection.dataSource = self;
    
    self.formTable.delegate = self;
    self.formTable.dataSource = self;
    
    [self.tlToolbarCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:DequeueReusableCell];
    [self.bToolbarCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:DequeueReusableCell];
    
    [self.formTable registerNib:[UINib nibWithNibName:FormButtonCellIdentifier bundle:nil] forCellReuseIdentifier:FormButtonCellIdentifier];
    [self.formTable registerNib:[UINib nibWithNibName:FormTextAreaCellIdentifier bundle:nil] forCellReuseIdentifier:FormTextAreaCellIdentifier];
    [self.formTable registerNib:[UINib nibWithNibName:FormTextFieldCellIdentifier bundle:nil] forCellReuseIdentifier:FormTextFieldCellIdentifier];
    [self.formTable registerNib:[UINib nibWithNibName:FormSwitchCellIdentifier bundle:nil] forCellReuseIdentifier:FormSwitchCellIdentifier];
    
    self.formTable.contentInset = UIEdgeInsetsMake(0, 0, 75, 0);
    self.formTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    /// Setup the drag coordinator + customize rendering
    
    self.recognizer = [[UILongPressGestureRecognizer alloc] init];

    self.dragCoordinator = [I3GestureCoordinator basicGestureCoordinatorFromViewController:self withCollections:@[self.tlToolbarCollection, self.bToolbarCollection, self.formTable] withRecognizer:self.recognizer];
    
    I3BasicRenderDelegate *renderDelegate = (I3BasicRenderDelegate *)self.dragCoordinator.renderDelegate;
    renderDelegate.draggingItemOpacity = 0.3;
    renderDelegate.rearrangeIsExchange = NO;

    
}

-(void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark - Helpers


-(NSMutableArray *)dataForCollectionView:(UIView *)collection{
    return collection == self.tlToolbarCollection ? self.tlToolbarItems : self.bToolbarItems;
}


-(BOOL) isPointInScrapArea:(CGPoint) at fromView:(UIView *)view{
    
    CGPoint localPoint = [self.scrapArea convertPoint:at fromView:view];
    return [self.scrapArea pointInside:localPoint withEvent:nil];
}


-(BOOL) isCollectionToolbar:(UIView *)collection{
    return collection == self.tlToolbarCollection || collection == self.bToolbarCollection;
}


-(void) showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


-(NSIndexPath *)indexPathForParentAware:(id<ParentCellAware>) awareComponent{
    
    return [self.formTable indexPathForCell:awareComponent.parentCell];
}

-(FormItem *)formItemForParentAware:(id<ParentCellAware>) cellAwareComponent{
    
    NSIndexPath *index = [self indexPathForParentAware:cellAwareComponent];
    return self.formItems[index.row];
}


-(BOOL) isIconWithNameArbitrary:(NSString *)iconName{
    
    return [self.arbitraryIconNames containsObject:iconName];
}


-(void) handleSelectArbitraryIconWithName:(NSString *)iconName{

    if([iconName isEqualToString:kBellIcon]){
        [self showAlertWithTitle:@"Bell" andMessage:@"Ding ding!"];
    }
    else if([iconName isEqualToString:kBombIcon]){
        [self showAlertWithTitle:@"Bomb" andMessage:@"Boooooom."];
    }
    else if([iconName isEqualToString:kBugIcon]){
        [self showAlertWithTitle:@"Bug" andMessage:@"See JIRA"];
    }
    else if([iconName isEqualToString:kCubeIcon]){
        [self showAlertWithTitle:@"Cube" andMessage:@"IceCube Software"];
    }
    else if([iconName isEqualToString:kCommentsIcon]){
        [self showAlertWithTitle:@"Comments" andMessage:@"Hey... hows you?"];
    }

}


-(void) handleSelectAddIconWithName:(NSString *)iconName{

    FormItem *item = [[FormItem alloc] init];

    if([iconName isEqualToString:kPlusTextFieldIcon]){
        
        item.type = FormItemTypeTextField;
    }
    else if([iconName isEqualToString:kPlusTextAreaIcon]){
        
        item.type = FormItemTypeTextArea;
    }
    else if([iconName isEqualToString:kPlusButtonIcon]){
        
        item.type = FormItemTypeButton;
    }
    else if([iconName isEqualToString:kPlusSwitchIcon]){

        item.type = FormItemTypeSwitch;
        item.value = @NO;
    }

    NSIndexPath *insertionIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.formItems insertObject:item atIndex:insertionIndex.row];
    [self.formTable insertRowsAtIndexPaths:@[insertionIndex] withRowAnimation:UITableViewRowAnimationLeft];

}


#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate


-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self dataForCollectionView:collectionView].count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *data = [self dataForCollectionView:collectionView];
    NSString *iconName = data[indexPath.item];

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DequeueReusableCell forIndexPath:indexPath];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    
    return cell;
}


-(BOOL) collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *data = [self dataForCollectionView:collectionView];
    NSString *iconName = data[indexPath.item];
    
    if([self isIconWithNameArbitrary:iconName]){
        [self handleSelectArbitraryIconWithName:iconName];
    }
    else{
        [self handleSelectAddIconWithName:iconName];
    }

    /// Cell selection animation
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundView.alpha = 0.4;
    
    [UIView animateWithDuration:0.5 animations:^{
        cell.backgroundView.alpha = 1;
    }];

}


#pragma mark - UITableViewDataSource, UITableViewDelegate


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height;
    
    if(((FormItem *)self.formItems[indexPath.row]).type == FormItemTypeTextArea){
        height = 100;
    }
    else{
        height = 65;
    }
    
    return height;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.formItems.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FormItem *item = self.formItems[indexPath.row];
    UITableViewCell *cell;

    /// Dequeue and configure the cell from the form item based on its type
    
    if(item.type == FormItemTypeButton){
    
        FormButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:FormButtonCellIdentifier forIndexPath:indexPath];
        
        [buttonCell.component addTarget:self action:@selector(handleCellButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        
        cell = buttonCell;
        
    }
    else if(item.type == FormItemTypeSwitch){

        FormSwitchCell *switchCell = [tableView dequeueReusableCellWithIdentifier:FormSwitchCellIdentifier forIndexPath:indexPath];
                
        switchCell.component.on = [(NSNumber *)item.value boolValue];
        [switchCell.component addTarget:self action:@selector(handleCellSwitchChange:) forControlEvents:UIControlEventValueChanged];
        
        cell = switchCell;

    }
    else if(item.type == FormItemTypeTextArea){
    
        FormTextAreaCell *textAreaCell = [tableView dequeueReusableCellWithIdentifier:FormTextAreaCellIdentifier forIndexPath:indexPath];
        
        textAreaCell.component.text = item.value;
        textAreaCell.component.delegate = self;
        
        cell = textAreaCell;

    }
    else if(item.type == FormItemTypeTextField){
        
        FormTextFieldCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:FormTextFieldCellIdentifier forIndexPath:indexPath];
        
        textFieldCell.component.text = item.value;
        [textFieldCell.component addTarget:self action:@selector(handleCellTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        
        cell = textFieldCell;

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - I3DragDataSource


-(BOOL) canItemBeDraggedAt:(NSIndexPath *)at inCollection:(UIView<I3Collection> *)collection{
    
    BOOL canDrop;
    
    if(collection == self.formTable){

        AbstractFormCell *cell = (AbstractFormCell *)[self.formTable cellForRowAtIndexPath:at];
        canDrop = [cell.moveAccessory pointInside:[self.dragCoordinator.gestureRecognizer locationInView:cell.moveAccessory] withEvent:nil];
    }
    else{
        canDrop = YES;
    }
    
    return canDrop;
}


-(BOOL) canItemFrom:(NSIndexPath *)from beRearrangedWithItemAt:(NSIndexPath *)to inCollection:(UIView<I3Collection> *)collection{
    return YES;
}


-(BOOL) canItemAt:(NSIndexPath *)from beDeletedFromCollection:(UIView<I3Collection> *)collection atPoint:(CGPoint)to{
    return collection == self.formTable  && [self isPointInScrapArea:to fromView:self.view];
}


-(BOOL) canItemAt:(NSIndexPath *)from fromCollection:(UIView<I3Collection> *)fromCollection beDroppedAtPoint:(CGPoint)at onCollection:(UIView<I3Collection> *)toCollection{
    return [self isCollectionToolbar:fromCollection] && [self isCollectionToolbar:toCollection];
}


-(BOOL) canItemAt:(NSIndexPath *)from fromCollection:(UIView<I3Collection> *)fromCollection beDroppedTo:(NSIndexPath *)to onCollection:(UIView<I3Collection> *)toCollection{
    return [self isCollectionToolbar:fromCollection] && [self isCollectionToolbar:toCollection];
}


-(void) deleteItemAt:(NSIndexPath *)at inCollection:(UIView<I3Collection> *)collection{
    
    [self.formItems removeObjectAtIndex:at.row];
    [self.formTable deleteItemsAtIndexPaths:@[at]];
}


-(void) rearrangeItemAt:(NSIndexPath *)from withItemAt:(NSIndexPath *)to inCollection:(UIView<I3Collection> *)collection{
    
    if([collection isKindOfClass:[UICollectionView class]]){
        
        NSMutableArray *data = [self dataForCollectionView:collection];
        NSString *iconName = data[from.row];
        
        [data removeObject:iconName];
        [data insertObject:iconName atIndex:to.row];
        
        [(UICollectionView *)collection performBatchUpdates:^{
            
            [collection deleteItemsAtIndexPaths:@[from]];
            [collection insertItemsAtIndexPaths:@[to]];
            
        } completion:nil];
        
    }
    else{

        FormItem *item = self.formItems[from.row];
        [self.formItems removeObject:item];
        [self.formItems insertObject:item atIndex:to.row];
        
        [self.formTable beginUpdates];
        [self.formTable deleteItemsAtIndexPaths:@[from]];
        [self.formTable insertRowsAtIndexPaths:@[to] withRowAnimation:UITableViewRowAnimationNone];
        [self.formTable endUpdates];

    }
}


-(void) dropItemAt:(NSIndexPath *)from fromCollection:(UIView<I3Collection> *)fromCollection toItemAt:(NSIndexPath *)to onCollection:(UIView<I3Collection> *)toCollection{
    
    NSMutableArray *fromDataset = [self dataForCollectionView:fromCollection];
    NSMutableArray *toDataset = [self dataForCollectionView:toCollection];
    NSString *exchangingData = fromDataset[from.row];
    
    [fromDataset removeObjectAtIndex:from.row];
    [toDataset insertObject:exchangingData atIndex:to.row];
    
    [fromCollection deleteItemsAtIndexPaths:@[from]];
    [toCollection insertItemsAtIndexPaths:@[to]];
    
}


-(void) dropItemAt:(NSIndexPath *)from fromCollection:(UIView<I3Collection> *)fromCollection toPoint:(CGPoint)to onCollection:(UIView<I3Collection> *)toCollection{
    
    NSIndexPath *toIndex = [NSIndexPath indexPathForItem:[self dataForCollectionView:toCollection].count inSection:0];
    
    [self dropItemAt:from fromCollection:fromCollection toItemAt:toIndex onCollection:toCollection];
}


#pragma mark - UITextViewDelegate


-(void) textViewDidChange:(UITextView *)textView{

    FormItem *item = [self formItemForParentAware:(ParentAwareTextView *)textView];
    item.value = textView.text;
}


#pragma mark - Target / action methods


-(void) handleCellTextFieldChanged:(ParentAwareTextField *)textField{

    FormItem *item = [self formItemForParentAware:textField];
    item.value = textField.text;
}


-(void) handleCellButtonPress:(ParentAwareButton *)button{

    NSIndexPath *index = [self indexPathForParentAware:button];
    NSString *message = [NSString stringWithFormat:@"You have tapped the button in form item number %d", index.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tap!" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


-(void) handleCellSwitchChange:(ParentAwareSwitch *)switchControl{

    FormItem *item = [self formItemForParentAware:switchControl];
    item.value = @(switchControl.isOn);
}


@end
