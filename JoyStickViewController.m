//
//  JoyStickViewController.m
//  RC Van
//
//  Created by Cristiano Tenuta on 2/17/17.
//  Copyright © 2017 Cristiano Tenuta. All rights reserved.
//

#import "JoyStickViewController.h"


@interface JoyStickViewController ()

@property (nonatomic) CGPoint currentTouchPosition;
@property (nonatomic) CGPoint joystickCenter;

@end


@implementation JoyStickViewController

BOOL isJoystickToggle;

double x;
double y;
double xDistance;
double yDistance;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.joystickCenter = CGPointMake(150.0,150.0);
    isJoystickToggle = false;
    
    [self drawBackgroundShape];
    
    CAShapeLayer *toggleLayer = [CAShapeLayer layer];
    [toggleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 50, 50)] CGPath]];
    [toggleLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    [toggleLayer setFillColor:[[UIColor colorWithRed:0.84 green:0.90 blue:0.92 alpha:2.0f] CGColor]];
    [[self.toggle layer] addSublayer:toggleLayer];
    [self.toggle setCenter: CGPointMake(150.0,150.0)];

    [self.view bringSubviewToFront:self.toggle];

}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *aTouch = [touches anyObject];
    
    if([aTouch view]== self.toggle)
    {
        self.currentTouchPosition = [aTouch locationInView:self.view];
        xDistance = self.currentTouchPosition.x - self.joystickCenter.x;
        yDistance = self.currentTouchPosition.y - self.joystickCenter.y;
   
        isJoystickToggle = true;
        
        
        CGFloat distance = sqrt(pow(xDistance,2)+pow(yDistance,2));
        
        if (distance < 150) {
            x = self.currentTouchPosition.x;
            y = self.currentTouchPosition.y;
            [self.toggle setCenter:self.currentTouchPosition];
        }
    
    } else {
         isJoystickToggle = false;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    
    if([aTouch view]== self.toggle)
    {
        self.currentTouchPosition = [aTouch locationInView:self.view];
        xDistance = self.currentTouchPosition.x - self.joystickCenter.x;
        yDistance = self.currentTouchPosition.y - self.joystickCenter.y;
        
        isJoystickToggle = true;
        
        
        CGFloat distance = sqrt(pow(xDistance,2)+pow(yDistance,2));
        
        if (distance < 150) {
            x = self.currentTouchPosition.x;
            y = self.currentTouchPosition.y;
            [self.toggle setCenter:self.currentTouchPosition];
        }
        
    } else {
        isJoystickToggle = false;
    }

}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    isJoystickToggle = false;
    [self.toggle setCenter: CGPointMake(150.0,150.0)];

}

+(BOOL)isJoystickToggle {
    return isJoystickToggle;
}

+(double)findDistanceX
{
    return xDistance;
}

+(double)findDistanceY
{
    return yDistance;
}

+(double)getX
{
    return x;
}

+(double)getY
{
    return y;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawBackgroundShape {
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 300, 300)] CGPath]];
    [circleLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    [circleLayer setFillColor:[[UIColor colorWithRed:0.16 green:0.66 blue:0.66 alpha:2.0f] CGColor]];
 
    
    CAShapeLayer *r0 = [CAShapeLayer layer];
    [r0 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(25, 25, 250,250)] CGPath]];
    [r0 setStrokeColor:[[UIColor whiteColor] CGColor]];
    [r0 setFillColor:[[UIColor clearColor] CGColor]];
    
    [circleLayer addSublayer:r0];

    
    CAShapeLayer *r1 = [CAShapeLayer layer];
    [r1 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(50, 50, 200,200)] CGPath]];
    [r1 setStrokeColor:[[UIColor whiteColor] CGColor]];
    [r1 setFillColor:[[UIColor clearColor] CGColor]];
    
    [circleLayer addSublayer:r1];
    
    
    CAShapeLayer *r2 = [CAShapeLayer layer];
    [r2 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(75, 75, 150,150)] CGPath]];
    [r2 setStrokeColor:[[UIColor whiteColor] CGColor]];
    [r2 setFillColor:[[UIColor clearColor] CGColor]];
    
    [circleLayer addSublayer:r2];
    
    CAShapeLayer *r3 = [CAShapeLayer layer];
    [r3 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 100,100)] CGPath]];
    [r3 setStrokeColor:[[UIColor whiteColor] CGColor]];
    [r3 setFillColor:[[UIColor clearColor] CGColor]];
    
    [circleLayer addSublayer:r3];

 
    [[self.view layer] addSublayer:circleLayer];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.view.bounds];
    [shapeLayer setPosition:self.view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //    [shapeLayer setLineDashPattern:
    //    [NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:10],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 150.0, 0.0);
    CGPathAddLineToPoint(path, NULL, 150.0, 300.0);
    CGPathMoveToPoint(path, NULL, 0.0, 150.0);
    CGPathAddLineToPoint(path, NULL, 300.0, 150);
    [shapeLayer setPath:path];
    
    
    CGPathRelease(path);
    
    [[self.view layer] addSublayer:shapeLayer];


  
    
    
}

@end
