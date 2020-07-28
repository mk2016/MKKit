//
//  UITableViewCell+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 2017/3/4.
//  Copyright © 2017 mk. All rights reserved.
//

#import "UITableViewCell+MKAdd.h"
#import "MKConst.h"

@implementation UITableViewCell (MKAdd)

+ (instancetype)mk_cellWithDefaultStyleTableView:(UITableView *)tableView{
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    return [self mk_cellWithStyle:UITableViewCellStyleDefault resuseIdentifier:reuseIdentifier tableView:tableView];
}

+ (instancetype)mk_cellWithDefaultStyleAndReuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView{
    return [self mk_cellWithStyle:UITableViewCellStyleDefault resuseIdentifier:reuseIdentifier tableView:tableView];
}

+ (instancetype)mk_cellWithStyle:(UITableViewCellStyle)style tableView:(UITableView *)tableView{
    NSString *identifier = NSStringFromClass([self class]);
    return [self mk_cellWithStyle:style resuseIdentifier:identifier tableView:tableView];
}

+ (instancetype)mk_cellWithStyle:(UITableViewCellStyle)style resuseIdentifier:(NSString *)identifier tableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:identifier];
        cell.selectedBackgroundView.backgroundColor = MK_COLOR_HEX(0xF0EFF0);
        [cell mk_setupUI];
    }
    return cell;
}

+ (instancetype)mk_cellByNibWith:(UITableView *)tableView{
    NSString *className = NSStringFromClass([self class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:className bundle:nil];
        if (nib) {
            cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
    }
    return cell;
}

+ (CGFloat)mk_cellHeight{
    return 44;
}

+ (CGFloat)mk_cellHeightWithModel:(id)model{
    return 44;
}

- (void)mk_setupUI{}

- (void)mk_refreshUIWithModel:(id)model{}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self mk_setupUI];
}

@end
