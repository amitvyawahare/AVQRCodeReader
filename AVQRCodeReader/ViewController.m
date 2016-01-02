//
//  ViewController.m
//  AVQRCodeReader
//
//  Created by Gauri Komawar on 1/2/16.
//  Copyright © 2016 Amit Vyawahare. All rights reserved.
//

#import "ViewController.h"
#import "AVQRCodeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AVQRCodeViewController *qrVC = [[AVQRCodeViewController alloc] initWithDismissBlock:^(AVQRCodeViewController *qrViewController, NSString *scannedValue) {
        NSLog(@"Value : %@", scannedValue);
        //[qrViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:qrVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
