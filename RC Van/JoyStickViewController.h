//
//  JoyStickViewController.h
//  RC Van
//
//  Created by Cristiano Tenuta on 2/17/17.
//  Copyright © 2017 Cristiano Tenuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoyStickViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *toggle;

+(BOOL)isJoystickToggle;
+(double)getX;
+(double)getY;
+(double)findDistanceX;
+(double)findDistanceY;

@end
