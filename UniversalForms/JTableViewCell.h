//
//  JTableViewCell.h
//  iPadPopovers
//
//  Created by Kostia Kolesnyk on 11/24/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTableViewCell : UITableViewCell

@property (nonatomic) IBInspectable NSInteger maxCellWidth;
@property (nonatomic, strong) IBInspectable UIColor * selectionColor;

- (void)prepareForDisplayInTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
