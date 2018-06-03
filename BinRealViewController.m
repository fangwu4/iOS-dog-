//
//  BinRealViewController.m
//  UI
//
//  Created by hha6027875 on 15/5/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import "BinRealViewController.h"

@interface BinRealViewController ()

@end

@implementation BinRealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startVideoCapture{
    // 创建会话
    self.session = [[AVCaptureSession alloc] init];
    
    // 获取摄像头的权限信息，判断是否有开启权限
    AVAuthorizationStatus status    = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status != AVAuthorizationStatusAuthorized)
    {
        [self.stateLabel setText:(@"cannot get video")];
        return;
    }
    
    //    self.backgroundRecordingID = UIBackgroundTaskInvalid;
    NSError *error = nil;
    
    // 创建输入设备
    
    AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    
    // beginConfiguration这个很重要，在addInput或者addOutput的时候一定要调用这个，add之后再调用commitConfiguration
    [self.session beginConfiguration];
    if ([self.session canAddInput:videoDeviceInput])
    {
        [self.session addInput:videoDeviceInput];
        //        self.videoDeviceInput = videoDeviceInput;
    }
    
    // 为会话加入output设备
    dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    videoDataOutput.videoSettings =[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]forKey:               (id)kCVPixelBufferPixelFormatTypeKey];
    
    // 设置self的AVCaptureVideoDataOutputSampleBufferDelegate
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    if ([self.session canAddOutput:videoDataOutput])
    {
        [self.session addOutput:videoDataOutput];
    }
    
    [self.session commitConfiguration];
    [self.session startRunning];
}

- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position{
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    return captureDevice;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"didOutputSampleBuffer");
    UIImage *image  = [self getImageBySampleBufferref:sampleBuffer];
    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    dogmodelOutput *result = [self predictImageScene:image];
    NSMutableArray *keysArray = [[result.prob allKeys] mutableCopy];
    [self bubblesort:keysArray :result];
    NSString *prolist = @"";
    NSString *prob = [prolist stringByAppendingFormat:@"%f%%", [result.prob[keysArray[0]] doubleValue]* 100];
    [self.stateLabel performSelectorOnMainThread:@selector(setText:) withObject:keysArray[0] waitUntilDone:YES];
    [self.probLabel performSelectorOnMainThread:@selector(setText:) withObject:prob waitUntilDone:YES];
    //  [self.stateLabel setText:[prolist stringByAppendingFormat:@"%f%%", [result.prob[keysArray[0]] doubleValue]* 100]];
}

- (UIImage *)getImageBySampleBufferref:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    /*Get information about the image*/
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    /*We unlock the  image buffer*/
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    /*Create a CGImageRef from the CVImageBufferRef*/
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    /*We release some components*/
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image= [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
    NSLog(@"%@", image);
    
    /*We relase the CGImageRef*/
    CGImageRelease(newImage);
    
    return image;
    
}

- (dogmodelOutput *)predictImageScene:(UIImage *)image {
    
    
    UIImage *scaledImage = [image scaleToSize:CGSizeMake(227, 227)];
    UIImage *cropImage = [scaledImage cropToSize:CGSizeMake(227, 227)] ;
    CVPixelBufferRef imageRef = [image pixelBufferFromCGImage:cropImage ];
    
    dogmodel *Model = [[dogmodel alloc] init];
    NSError *error = nil;
    NSTimeInterval startime = [[NSDate date] timeIntervalSince1970];
    dogmodelOutput *output = [Model predictionFromData:imageRef
                                                 error:&error];
    NSTimeInterval endtime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"elapsed time %f", (endtime-startime)*1000);
    if (error != nil) {
        
        NSLog(@"Error is %@", error.localizedDescription);
    }
    return output;
}

-(void) bubblesort:(NSMutableArray *) arrays: (dogmodelOutput *) result
{
    if(arrays == nil||arrays.count == 0)
    {
        return;
    }
    for(int i = 1; i < arrays.count; i++)
    {
        for(int j = 0; j < arrays.count -1; j++)
        {
            
            if([result.prob[arrays[j]] doubleValue] <= [result.prob[arrays[j + 1]] doubleValue])
            {
                [arrays exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_imageView release];
    [_stateLabel release];
    [_probLabel release];
    [super dealloc];
}
- (IBAction)startButton:(id)sender {
    NSLog(@"hello");
    [self startVideoCapture];
}
@end
