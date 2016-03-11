//
//  ViewController.m
//  CameraOverlay
//
//  Created by datxqv on 1/8/16.
//  Copyright © 2016 datxqv. All rights reserved.
//

#import "ViewController.h"
#import "AnnimationController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonChooseImageClicked:(id)sender {
    [self.navigationController pushViewController:[[AnnimationController alloc] init] animated:YES];
}

- (void) processLongPress:(UILongPressGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self.view];
    
    NSLog(@"X : %d   , Y : %d", location.x, location.y);
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        
       
    }
    if (sender.state == UIGestureRecognizerStateBegan)
    {
       
    }
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        
        
    }
}
@end
