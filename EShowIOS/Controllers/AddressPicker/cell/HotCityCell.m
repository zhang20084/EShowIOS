//
//  BHotCityCell.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "HotCityCell.h"
#import "AddressHeader.h"


@implementation HotCityCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)cities{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BG_CELL;
        [self initButtons:cities];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Event Response
- (void)buttonClick:(UIButton*)button{
    self.buttonClickBlock(button);
}

- (void)buttonWhenClick:(void (^)(UIButton *))block{
    self.buttonClickBlock = block;
}

#pragma mark - init
- (void)initButtons:(NSArray*)cities{
    for (int i = 0; i < [cities count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(15 + (i % 3) * (BUTTON_WIDTH + 15), 15 + (i / 3) * (15 + BUTTON_HEIGHT), BUTTON_WIDTH, BUTTON_HEIGHT);
        [button setTitle:cities[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        button.tintColor = [UIColor blackColor];
        button.backgroundColor = [UIColor whiteColor];
        button.alpha = 0.8;
        button.layer.borderColor = [UIColorFromRGBA(237, 237, 237, 1.0) CGColor];
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 3;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
}



@end