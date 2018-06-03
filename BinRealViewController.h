//
//  BinRealViewController.h
//  UI
//
//  Created by hha6027875 on 15/5/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "dogmodel.h"
#import "ImageAdjust.h"

@interface BinRealViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>
{
}

@property (nonatomic, retain) AVCaptureSession *session;

@property (retain, nonatomic) IBOutlet UIImageView *imageView;

@property (retain, nonatomic) IBOutlet UILabel *stateLabel;

@property (retain, nonatomic) IBOutlet UILabel *probLabel;
- (IBAction)startButton:(id)sender;
-(void)startVideoCapture;
@end
