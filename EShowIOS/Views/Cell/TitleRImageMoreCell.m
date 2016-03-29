//
//  TitleRImageMoreCell.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/25.
//  Copyright © 2016年 金璟. All rights reserved.
//
#define kTitleRImageMoreCell_HeightIcon 60.0

#import "TitleRImageMoreCell.h"
#import "UIImageView+WebCache.h"

@interface TitleRImageMoreCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *userIconView;
@end
@implementation TitleRImageMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor whiteColor];
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPaddingLeftWidth, ([TitleRImageMoreCell cellHeight] -30)/2, 100, 30)];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.font = [UIFont systemFontOfSize:16];
            _titleLabel.textColor = [UIColor blackColor];
            [self.contentView addSubview:_titleLabel];
        }
        if (!_userIconView) {
            _userIconView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth- kTitleRImageMoreCell_HeightIcon)- kPaddingLeftWidth- 30, ([TitleRImageMoreCell cellHeight] -kTitleRImageMoreCell_HeightIcon)/2, kTitleRImageMoreCell_HeightIcon, kTitleRImageMoreCell_HeightIcon)];
            _userIconView.layer.masksToBounds = YES;
            _userIconView.layer.cornerRadius = 10;
            [self.contentView addSubview:_userIconView];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.titleLabel.text = @"头像";
    [_userIconView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"user.photo"]]placeholderImage:kPlaceholderMonkeyRoundView(_userIconView)];
}

+ (CGFloat)cellHeight
{
    return 70.0;
}

@end
