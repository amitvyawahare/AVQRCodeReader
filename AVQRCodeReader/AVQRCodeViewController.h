//
//  ViewController.h
//  AVQRCodeReader
//
//  Created by Gauri Komawar on 1/2/16.
//  Copyright © 2016 Amit Vyawahare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVQRCodeViewController : UIViewController

- (id)initWithDismissBlock:(void(^)(AVQRCodeViewController *, NSString *))dismissBlock;

@end

