//
//  MKAlbumListView.m
//  Fanmugua
//
//  Created by xiaomk on 2020/9/14.
//  Copyright © 2020 taolang. All rights reserved.
//

#import "MKAlbumListView.h"
#import "MKAlbumListCell.h"
#import "MKPhotoModels.h"
#import "MKPhotoUtils.h"
#import "UITableViewCell+MKAdd.h"

@interface MKAlbumListView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *datasArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isShow;
@end

@implementation MKAlbumListView

- (id)initWithY:(CGFloat)y{
    if (self = [super initWithFrame:CGRectMake(0, y, MK_SCREEN_WIDTH, MK_SCREEN_HEIGHT-y)]){
        self.backgroundColor = MK_COLOR_RGBA(0, 0, 0, 0.3);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        self.boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MK_SCREEN_WIDTH, 0)];
        self.boxView.backgroundColor = UIColor.clearColor;
        self.boxView.clipsToBounds = YES;
        [self addSubview:self.boxView];
    }
    return self;
}

- (void)setupUIWith:(NSArray *)datas{
    self.datasArray = datas;
    CGFloat height = 0;
    if (self.datasArray.count > 10) {
        height = [MKAlbumListCell cellHeight] * 10 + 12;
    }else{
        height = [MKAlbumListCell cellHeight] * self.datasArray.count;
    }
    self.tableView.frame = CGRectMake(0, 0, MK_SCREEN_WIDTH, height);
    [self.tableView reloadData];
}

- (void)showWithSelected:(NSInteger)index{
    if (self.isShow) {
        [self remove];
        return;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    self.alpha = 0;
    self.selectedIndex = index;
    [self.tableView reloadData];
    CGRect frame = CGRectMake(0, 0, MK_SCREEN_WIDTH, self.tableView.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.boxView.frame = frame;
//        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.isShow = YES;
    }];
}

- (void)remove{
    if (!self.isShow) {
        return;
    }
    self.isShow = NO;
    CGRect frame = CGRectMake(0, 0, MK_SCREEN_WIDTH, 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.boxView.frame = frame;
//        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - ***** UITableView ******
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKAlbumListCell *cell = [MKAlbumListCell mk_cellByNibWith:tableView];
    if (self.datasArray.count > indexPath.row) {
        MKAlbumModel *model = self.datasArray[indexPath.row];
        cell.labTitle.text = model.title;
        cell.labCount.text = [NSString stringWithFormat:@"(%@)",@(model.count)];
        [[MKPhotoUtils sharedInstance] requestThumbnailWithAsset:model.coverAsset
                                                      targetSize:CGSizeMake([MKAlbumListCell cellHeight], [MKAlbumListCell cellHeight])
                                                      completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info, BOOL isDegraded) {
            cell.imgCover.image = image;
        }];
    }
    cell.isSelected = self.selectedIndex == indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *tIndexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:indexPath.section];
    self.selectedIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:@[tIndexPath, indexPath] withRowAnimation:UITableViewRowAnimationFade];
    MK_BLOCK_EXEC(self.selectedBlock, indexPath.row);
    [self remove];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MKAlbumListCell cellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasArray.count;
}

- (NSArray *)datasArray{
    if (!_datasArray) {
        _datasArray = @[];
    }
    return _datasArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.boxView addSubview:_tableView];
    }
    return _tableView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

MK_ADJUST_TABLEVIEW_SEPARATOR
@end
