//
//  ViewController.m
//  AVQRCodeReader
//
//  Created by Gauri Komawar on 1/2/16.
//  Copyright © 2016 Amit Vyawahare. All rights reserved.
//

#import "AVQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AVQRCodeViewController ()  <AVCaptureMetadataOutputObjectsDelegate> {
    
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
    
    void(^_dismissBlock)(AVQRCodeViewController *, NSString *);
}

@end

@implementation AVQRCodeViewController

- (id)initWithDismissBlock:(void(^)(AVQRCodeViewController *, NSString *))dismissBlock {
    self = [super init];
    
    if (self) {
        _dismissBlock = dismissBlock;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScannerAndSession];
    [self setupCancelButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Sessions should run only when the view controller is on screen.
    [_session startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    // Sessions should run only when the view controller is on screen.
    [_session stopRunning];
    
    [super viewDidDisappear:animated];
}

- (void)setupScannerAndSession
{
    // You use an AVCaptureSession object to coordinate the
    // flow of data from AV input devices to outputs.
    _session = [[AVCaptureSession alloc] init];
    
    // An AVCaptureDevice object represents a physical capture
    // device and the properties associated with that device.
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // You use an AVCaptureDeviceInput to capture data from an
    // AVCaptureDevice object.
    NSError *error = nil;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device
                                                   error:&error];
    if (error == nil) {
        
        // Add AVMediaTypeVideo input to current session
        [_session addInput:_input];
        
        // An AVCaptureMetadataOutput object intercepts metadata objects emitted by
        // its associated capture connection and forwards them to a delegate object for processing.
        // You can use instances of this class to process specific types of metadata included with the input data.
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_session addOutput:_output];
        [_output setMetadataObjectTypes:[_output availableMetadataObjectTypes]];
        
        
        // AVCaptureVideoPreviewLayer is a subclass of CALayer that you use to display video
        // as it is being captured by an input device.
        _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        [_videoPreviewLayer setFrame:[[self view] bounds]];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [[_videoPreviewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
        
        [[[self view] layer] addSublayer:_videoPreviewLayer];
    } else {
        [self showAlertForCameraError:error];
    }
}

- (void)setupCancelButton
{
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 75, 45)];
    [cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [cancelButton addTarget:self
                     action:@selector(dismissQRCodeViewController:)
           forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:cancelButton];
}

- (void)dismissQRCodeViewController:(id)sender {
    _dismissBlock(self, nil);
}

- (void)showAlertForCameraError:(NSError *)error {
    
    NSString *buttonTitle = NSLocalizedString(@"Settings", @"QRCodeScanner: The title on a button that takes the user to iOS' settings app for ICEmobile");
    NSString *message = error.localizedFailureReason;
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Camera Error"
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:buttonTitle
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                             [[UIApplication sharedApplication] openURL:url];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 _dismissBlock(self, nil);
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-    (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
          fromConnection:(AVCaptureConnection *)connection {
    
    for(AVMetadataObject *current in metadataObjects) {
        if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
            _dismissBlock(self, scannedValue);
            break;
        }
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
