//
//  ViewController.m
//  RC Van
//
//  Created by Cristiano Tenuta on 2/17/17.
//  Copyright © 2017 Cristiano Tenuta. All rights reserved.
//

#import "ViewController.h"
#import "JoyStickViewController.h"

@interface ViewController ()



@property (strong, nonatomic) NSTimer *updateTimer;

@end

@implementation ViewController

BOOL isConnected;
BOOL isScanning;

int lastSteering;
int lastGas;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.beanManager = [[PTDBeanManager alloc] initWithDelegate:self];

    lastSteering = 0;
    lastGas = 0;
    isConnected = NO;
}


-(void)update {
    
    if (self.rcVan == nil || !isConnected)
        return;
    
    //deadzone
    int steering = 130;
    int gas = 130;

    if ([JoyStickViewController isJoystickToggle]) {
        steering = (([JoyStickViewController getX] * 255) / 300);
        gas = (((300 - [JoyStickViewController getY]) * 255) / 300);
    }
    
    if ((lastSteering == steering) && (lastGas == gas))
        return;
    
    const unsigned char bytes[] = {8,steering,9,gas};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self.rcVan sendSerialData:data];
    
    lastSteering = steering;
    lastGas = gas;

    
}
- (void)startScanning {
    
    NSError *error;
    
    isScanning = YES;
    [self.state setText:@"Scanning..."];
    
    [self.beanManager startScanningForBeans_error:&error];
    
    if ( error != nil ) {
        NSLog(@"Error scanning for beans: %@", error );
    }
    
}

-(void) stopScanning {
    
    NSError *error;
    
    isScanning = NO;
    
    [self.state setText:@"Disconnected"];
    [self.beanManager stopScanningForBeans_error:&error];
    
    if ( error != nil ) {
        NSLog(@"Error scanning for beans: %@", error );
    }
}

-(void)beanManager:(PTDBeanManager *)beanManager didDiscoverBean:(PTDBean *)bean error:(NSError *)error {
    
    if ([bean.name isEqualToString:@"Bean"]) {
        self.rcVan = bean;
        [self connect:self.rcVan];
    }
}

-(void)beanManager:(PTDBeanManager *)beanManager didConnectBean:(PTDBean *)bean error:(NSError *)error {
    [self stopScanning];
    [self.rcVan setDelegate:self];
    [self.state setText:@"Connected"];
    isConnected = YES;
    [self.connection setEnabled:YES];
    [self.connection setTitle:@"Disconnect" forState:UIControlStateNormal];
    [self startUpdate];

}

-(void)beanManager:(PTDBeanManager *)beanManager didDisconnectBean:(PTDBean *)bean error:(NSError *)error {
    [self.state setText:@"Disconnected"];
    isConnected = NO;
    [self.connection setEnabled:YES];
    [self.connection setTitle:@"Connect" forState:UIControlStateNormal];
    [self stopUpdate];
}

-(void)beanManagerDidUpdateState:(PTDBeanManager *)beanManager {
    
    
    if (self.beanManager.state == BeanManagerState_PoweredOff) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Bluetooth Off"
                                     message:@"Turn on your bluetooth"
                                     preferredStyle:UIAlertControllerStyleAlert];

        
        
        UIAlertAction* okButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
  
        [alert addAction:okButton];
    
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (void)connect:(PTDBean *)bean {
    
    NSError *error;
    
    [self.beanManager connectToBean:bean error:&error];
    
    if ( error != nil ) {
        NSLog(@"Error connecting to bean: %@", error );
    }
}

- (void)disconnect {
    
    NSError *error;
    
    [self.beanManager disconnectBean:self.rcVan error:&error];
    
    if ( error != nil ) {
        NSLog(@"Error disconnecting from bean: %@", error );
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)connectionClick:(id)sender {
   
    if (isConnected) {
        [self disconnect];
    } else {
        if (isScanning) {
            [self stopScanning];
            [self.connection setTitle:@"Connect" forState:UIControlStateNormal];
        } else {
            [self startScanning];
            [self.connection setTitle:@"Cancel" forState:UIControlStateNormal];
        }
    }
}

- (void)startUpdate {
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)stopUpdate {
    
    if (self.updateTimer != nil) {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
}



-(void)finish {
    
    [self stopUpdate];
    
    isConnected = NO;
    isScanning = NO;
    
    [self stopScanning];
    [self disconnect];
    
    self.rcVan = nil;
}



@end
