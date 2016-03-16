//
//  BAddressHeader.h
//  Bee
//
//  Created by 林洁 on 16/1/13.
//  Copyright © 2016年 Lin. All rights reserved.
//

#ifndef BAddressHeader_h
#define BAddressHeader_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define BUTTON_WIDTH (ScreenWidth - 90) / 3
#define BUTTON_HEIGHT 36

#define UIColorFromRGBA(r, g, b , a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define BG_CELL UIColorFromRGBA(250, 250, 250, 1.0)

#define currentCity (@"currentCity")


#endif /* AddressHeader_h */