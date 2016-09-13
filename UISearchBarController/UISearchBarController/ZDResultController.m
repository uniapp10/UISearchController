//
//  ZDResultController.m
//  UISearchBarController
//
//  Created by zhudong on 16/9/13.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "ZDResultController.h"
#import "ZDHeaderView.h"


@interface ZDResultController ()
@property (nonatomic,strong) NSArray *hotWords;
@end

@implementation ZDResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark - DataSourceDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ZDHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!headerView) {
        headerView = [[ZDHeaderView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
    }
    if (section == 0) {
        headerView.nameLabel.text = @"热门搜索";
    }else{
        headerView.nameLabel.text = @"搜索结果";
    }
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return self.results.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *headerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
        __block CGFloat leftMargin = Margin;
        __block CGFloat topMargin = Margin;
        [self.hotWords enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = [[UILabel alloc] init];
            label.text = obj;
            [label sizeToFit];
            CGRect bound = label.bounds;
//            ZDLog(@"%@",NSStringFromCGRect(bound));
            bound.size.width += 10;
            label.bounds = bound;
//            ZDLog(@"%@",NSStringFromCGRect(bound));
            label.layer.cornerRadius = MIN(label.bounds.size.width, label.bounds.size.height) * 0.5;
            label.layer.borderWidth = 1;
            label.layer.borderColor = [UIColor grayColor].CGColor;
            label.layer.masksToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [headerCell.contentView addSubview:label];
            
            if (leftMargin < (ScreenSize.width - label.bounds.size.width - Margin)) {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(headerCell.contentView).offset(leftMargin);
                    make.top.equalTo(headerCell.contentView).offset(topMargin);
                    make.width.equalTo(@(label.bounds.size.width));
                }];
                leftMargin += (label.bounds.size.width + Margin);
            }else{
                leftMargin = Margin;
                topMargin += (30 + Margin);
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(headerCell.contentView).offset(leftMargin);
                    make.top.equalTo(headerCell.contentView).offset(topMargin);
                    make.width.equalTo(@(label.bounds.size.width));
                }];
            }

        }];
        UILabel *lastLabel = [headerCell.contentView.subviews lastObject];
        [headerCell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(headerCell);
            make.bottom.equalTo(lastLabel.mas_bottom).offset(Margin);
        }];
        return headerCell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        cell.textLabel.text = self.results[indexPath.row];
        return cell;
    }
}
- (NSArray *)hotWords{
    if (_hotWords == nil) {
        _hotWords = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HotWords.plist" ofType:nil]];
    }
    return _hotWords;
}
@end
