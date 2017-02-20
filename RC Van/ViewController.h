//
//  ViewController.h
//  RC Van
//
//  Created by Cristiano Tenuta on 2/17/17.
//  Copyright © 2017 Cristiano Tenuta. All rights reserved.
//

#import <UIKit/UIKit.h>


@import Bean_iOS_OSX_SDK;

@interface ViewController : UIViewController<PTDBeanManagerDelegate, PTDBeanDelegate>

@property (strong, nonatomic) PTDBeanManager *beanManager;
@property (strong, nonatomic) PTDBean *rcVan;
@property (retain, nonatomic) IBOutlet UIButton  *connection;
@property (retain, nonatomic) IBOutlet UILabel  *state;
@property (strong, nonatomic) IBOutlet UIView *joyStickView;

-(void)finish;

@end

