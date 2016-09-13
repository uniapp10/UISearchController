//
//  ZDHeaderView.m
//  UISearchBarController
//
//  Created by zhudong on 16/9/13.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "ZDHeaderView.h"

@implementation ZDHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(Margin);
            make.top.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}
@end
