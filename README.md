# AVQRCodeReader

 The AVQRCodeReader is a simple QRCode reader. It is based on the AVFoundation framework from Apple.

#### preview

<img src="https://github.com/amitvyawahare/AVQRCodeReader/blob/master/AVQRCodeReader/Assets.xcassets/demo.imageset/1.png" width=50% height=50%>

## Usage

Download the project and copy the AVQRCodeViewController folder into your project and then simply #import "AVQRCodeViewController.h" in the file(s) you would like to use it in.

#### Initialization

To initialize an instance of `AVQRCodeViewController`:

```
objective-c

AVQRCodeViewController *qrVC = [[AVQRCodeViewController alloc] initWithDismissBlock:^(AVQRCodeViewController *qrViewController, NSString *scannedValue) {
    NSLog(@"Value : %@", scannedValue);
    [qrViewController dismissViewControllerAnimated:YES completion:nil];
}];

[self presentViewController:qrVC animated:YES completion:nil];

```