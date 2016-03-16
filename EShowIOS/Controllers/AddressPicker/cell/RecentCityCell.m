//
//  BRecentCityCell.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "RecentCityCell.h"
#import "AddressHeader.h"

@interface RecentCityCell ()

@property (nonatomic, strong) NSMutableArray *currentArray;

@end

@implementation RecentCityCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BG_CELL;
        [self.contentView addSubview:self.firstButton];
        [self.contentView addSubview:self.secondButton];
        if ([self.currentArray count] > 1) {
            [self.firstButton setTitle:self.currentArray[0] forState:UIControlStateNormal];
            [self.secondButton setTitle:self.currentArray[1] forState:UIControlStateNormal];
        }else if ([self.currentArray count] > 0){
            [self.firstButton setTitle:self.currentArray[0] forState:UIControlStateNormal];
            [self.secondButton setHidden:YES];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Event Response
- (void)buttonWhenClick:(void (^)(UIButton *))block{
    self.buttonClickBlock = block;
}

- (void)buttonClick:(UIButton*)button{
    self.buttonClickBlock(button);
}

#pragma mark - Getter and Setter
- (UIButton*)firstButton{
    if (_firstButton == nil) {
        _firstButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _firstButton.frame = CGRectMake(15, 15, BUTTON_WIDTH, BUTTON_HEIGHT);
        [_firstButton setTitle:@"" forState:UIControlStateNormal];
        _firstButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _firstButton.tintColor = [UIColor blackColor];
        _firstButton.backgroundColor = [UIColor whiteColor];
        _firstButton.layer.borderColor = [UIColorFromRGBA(237, 237, 237, 1.0) CGColor];
        _firstButton.layer.borderWidth = 1;
        _firstButton.layer.cornerRadius = 3;
        [_firstButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstButton;
}

- (UIButton*)secondButton{
    if (_secondButton == nil) {
        _secondButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _secondButton.frame = CGRectMake(self.firstButton.frame.size.width + 30, 15, BUTTON_WIDTH, BUTTON_HEIGHT);
        [_secondButton setTitle:@"" forState:UIControlStateNormal];
        _secondButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _secondButton.tintColor = [UIColor blackColor];
        _secondButton.backgroundColor = [UIColor whiteColor];
        _secondButton.alpha = 0.8;
        _secondButton.layer.borderColor = [UIColorFromRGBA(237, 237, 237, 1.0) CGColor];
        _secondButton.layer.borderWidth = 1;
        _secondButton.layer.cornerRadius = 3;
        [_secondButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondButton;
}

- (NSMutableArray*)currentArray{
    if (_currentArray == nil) {
        _currentArray = [[NSUserDefaults standardUserDefaults] objectForKey:currentCity];
    }
    return _currentArray;
}

@end