//
//  ZHCMessagesEditTableView.m
//  ZHChat
//
//  Created by Marwan Ayman on 12/18/17.
//  Copyright © 2017 zhuo. All rights reserved.
//

#import "ZHCMessagesEditTableView.h"
#import "ZHCMessagesTableViewCellEditOutcoming.h"
#import "ZHCMessagesTableViewCellIncoming.h"

@implementation ZHCMessagesEditTableView


- (void)zhc_configureTableView
{
    //self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.alwaysBounceVertical = YES;
    self.bounces = YES;
    self.tableHeaderView = [UIView new];
    
    [self registerNib:[ZHCMessagesTableViewCellIncoming nib] forCellReuseIdentifier:[ZHCMessagesTableViewCellIncoming cellReuseIdentifier]];
    [self registerNib:[ZHCMessagesTableViewCellEditOutcoming nib] forCellReuseIdentifier:[ZHCMessagesTableViewCellEditOutcoming cellReuseIdentifier]];
    
    [self registerNib:[ZHCMessagesTableViewCellIncoming nib] forCellReuseIdentifier:[ZHCMessagesTableViewCellIncoming mediaCellReuseIdentifier]];
    [self registerNib:[ZHCMessagesTableViewCellEditOutcoming nib] forCellReuseIdentifier:[ZHCMessagesTableViewCellEditOutcoming mediaCellReuseIdentifier]];
    [ZHCMessagesTableviewLayoutAttributes setEditEnabled:YES];
    self.tableViewLayout = [[ZHCMessagesTableviewLayoutAttributes alloc]init];
}

@end
