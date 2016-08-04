//
//  Config.h
//  DemoOfALAssetsLibrary
//
//  Created by 吴 吴 on 16/8/1.
//  Copyright © 2016年 JW. All rights reserved.
//

#ifndef Config_h
#define Config_h

#import "UIViewExt.h"
#import "UIView+Layout.h"

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

#define AppHeight                      [UIScreen mainScreen].bounds.size.height
#define AppWidth                       [UIScreen mainScreen].bounds.size.width
#define AppFrame(x,y,width,height)     CGRectMake((x),(y),(width),(height))

#define UIColorFromRGB(rgbValue)	    UIColorFromRGBA(rgbValue,1.0)

#define UIColorFromRGBA(rgbValue,a)	    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#endif /* Config_h */
