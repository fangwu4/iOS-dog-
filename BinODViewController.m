//
//  BinODViewController.m
//  UI
//
//  Created by hha6027875 on 20/4/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import "BinODViewController.h"
#import "ImageAdjust.h"
#import "BinPhotoViewController.h"
#import "GCDAsyncSocket.h"
#import "BinAttribute.h"

@interface BinODViewController () <GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) UIImage * transferImage;
@property (strong, nonatomic) GCDAsyncSocket * clientSocket;
@property (retain, nonatomic) IBOutlet UIButton *toPhoto;
@property (strong, nonatomic) NSMutableArray * array;
@end

@implementation BinODViewController
- (IBAction)Connect:(id)sender {
    
    if(self.clientSocket)
    {
        [self.clientSocket disconnect];
        self.clientSocket = nil;
    }
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.clientSocket connectToHost:@"10.0.0.25" onPort:11126 error:nil];
    self.img1.hidden = YES;
    self.label1.text = @"";
    self.img2.hidden = YES;
    self.label2.text = @"";
    self.img3.hidden = YES;
    self.label3.text = @"";
    self.img4.hidden = YES;
    self.label4.text = @"";
}

- (IBAction)toPhoto:(id)sender {
    //[self performSegueWithIdentifier:@"toPhoto" sender:nil];
}

- (IBAction)btnClick1:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (IBAction)btnClick2:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *oldImage = info[UIImagePickerControllerEditedImage];
    self.imgView.image = oldImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void) performTransfer
{
    UIImage *oldImage = self.imgView.image;
    if(self.array.count == 0)
    {
        NSLog(@"%@", @"ERROR, ZERO ARRAY");
    }
    else if(self.array.count == 1)
    {
        //[attribute1.imgLeft floatValue] + 0.5*([attribute1.imgRight floatValue] - [attribute1.imgLeft floatValue])
        //[attribute1.imgUp floatValue] + 0.5*([attribute1.imgDown floatValue] - [attribute1.imgUp floatValue])
        BinAttribute * attribute1 = self.array[0];
        CGRect rectMAX1 = CGRectMake([attribute1.imgLeft floatValue], [attribute1.imgUp floatValue], [attribute1.imgRight floatValue], [attribute1.imgDown floatValue]);
        self.img1.hidden = NO;
        self.img1.image = [self transfer:rectMAX1 :oldImage];
        self.label1.text = attribute1.imgClass;
        UIImage * Image1 = [self addText:oldImage :[NSString stringWithFormat:@"%@ %@",attribute1.imgClass,attribute1.imgScore] :[attribute1.imgLeft floatValue] + 0.5*([attribute1.imgRight floatValue] - [attribute1.imgLeft floatValue]) :[attribute1.imgUp floatValue] + 0.5*([attribute1.imgDown floatValue] - [attribute1.imgUp floatValue])];
        self.imgView.image = Image1;
        if([attribute1.imgClass isEqualToString:@"dog"])
        {
            self.transferImage = self.img1.image;
        }
        else
        {
            [self.toPhoto setEnabled: NO];
        }
    }
    else if(self.array.count == 2)
    {
        self.img1.hidden = NO;
        self.img2.hidden = NO;
        BinAttribute * attribute1 = self.array[0];
        CGRect rectMAX1 = CGRectMake([attribute1.imgLeft floatValue], [attribute1.imgUp floatValue], [attribute1.imgRight floatValue], [attribute1.imgDown floatValue]);
        self.img1.image = [self transfer:rectMAX1 :oldImage];
        self.label1.text = attribute1.imgClass;
        UIImage * Image1 = [self addText:oldImage :[NSString stringWithFormat:@"%@ %@",attribute1.imgClass,attribute1.imgScore] :[attribute1.imgLeft floatValue] + 0.5*([attribute1.imgRight floatValue] - [attribute1.imgLeft floatValue]) :[attribute1.imgUp floatValue] + 0.5*([attribute1.imgDown floatValue] - [attribute1.imgUp floatValue])];
        BinAttribute * attribute2 = self.array[1];
        CGRect rectMAX2 = CGRectMake([attribute2.imgLeft floatValue], [attribute2.imgUp floatValue], [attribute2.imgRight floatValue], [attribute2.imgDown floatValue]);
        self.img2.image = [self transfer:rectMAX2 :oldImage];
        self.label2.text = attribute2.imgClass;
        UIImage * Image2 = [self addText:Image1 :[NSString stringWithFormat:@"%@ %@",attribute2.imgClass,attribute2.imgScore] :[attribute2.imgLeft floatValue] + 0.5*([attribute2.imgRight floatValue] - [attribute2.imgLeft floatValue]) :[attribute2.imgUp floatValue] + 0.5*([attribute2.imgDown floatValue] - [attribute2.imgUp floatValue])];
        self.imgView.image = Image2;
        if([attribute1.imgClass isEqualToString:@"dog"])
        {
            self.transferImage = self.img1.image;
        }
        else if([attribute2.imgClass isEqualToString:@"dog"])
        {
            self.transferImage = self.img2.image;
        }
        else
        {
            [self.toPhoto setEnabled: NO];
        }
    }
    else if(self.array.count == 3)
    {
        self.img1.hidden = NO;
        self.img2.hidden = NO;
        self.img3.hidden = NO;
        BinAttribute * attribute1 = self.array[0];
        CGRect rectMAX1 = CGRectMake([attribute1.imgLeft floatValue], [attribute1.imgUp floatValue], [attribute1.imgRight floatValue], [attribute1.imgDown floatValue]);
        self.img1.image = [self transfer:rectMAX1 :oldImage];
        self.label1.text = attribute1.imgClass;
        UIImage * Image1 = [self addText:oldImage :[NSString stringWithFormat:@"%@ %@",attribute1.imgClass,attribute1.imgScore] :[attribute1.imgLeft floatValue] + 0.5*([attribute1.imgRight floatValue] - [attribute1.imgLeft floatValue]) :[attribute1.imgUp floatValue] + 0.5*([attribute1.imgDown floatValue] - [attribute1.imgUp floatValue])];
        BinAttribute * attribute2 = self.array[1];
        CGRect rectMAX2 = CGRectMake([attribute2.imgLeft floatValue], [attribute2.imgUp floatValue], [attribute2.imgRight floatValue], [attribute2.imgDown floatValue]);
        self.img2.image = [self transfer:rectMAX2 :oldImage];
        self.label2.text = attribute2.imgClass;
        UIImage * Image2 = [self addText:Image1 :[NSString stringWithFormat:@"%@ %@",attribute2.imgClass,attribute2.imgScore] :[attribute2.imgLeft floatValue] + 0.5*([attribute2.imgRight floatValue] - [attribute2.imgLeft floatValue]) :[attribute2.imgUp floatValue] + 0.5*([attribute2.imgDown floatValue] - [attribute2.imgUp floatValue])];
        BinAttribute * attribute3 = self.array[2];
        CGRect rectMAX3 = CGRectMake([attribute3.imgLeft floatValue], [attribute3.imgUp floatValue], [attribute3.imgRight floatValue], [attribute3.imgDown floatValue]);
        self.img3.image = [self transfer:rectMAX3 :oldImage];
        self.label3.text = attribute3.imgClass;
        UIImage * Image3 = [self addText:Image2 :[NSString stringWithFormat:@"%@ %@",attribute3.imgClass,attribute3.imgScore] :[attribute3.imgLeft floatValue] + 0.5*([attribute3.imgRight floatValue] - [attribute3.imgLeft floatValue]) :[attribute3.imgUp floatValue] + 0.5*([attribute3.imgDown floatValue] - [attribute3.imgUp floatValue])];
        self.imgView.image = Image3;
        if([attribute1.imgClass isEqualToString:@"dog"])
        {
            self.transferImage = self.img1.image;
        }
        else if([attribute2.imgClass isEqualToString:@"dog"])
        {
            self.transferImage = self.img2.image;
        }
        else if([attribute3.imgClass isEqualToString:@"dog"])
        {
            self.transferImage = self.img3.image;
        }
        else
        {
            [self.toPhoto setEnabled: NO];
        }
    }
    else
    {
        self.img1.hidden = NO;
        self.img2.hidden = NO;
        self.img3.hidden = NO;
        self.img4.hidden = NO;
        BinAttribute * attribute1 = self.array[0];
        CGRect rectMAX1 = CGRectMake([attribute1.imgLeft floatValue], [attribute1.imgUp floatValue], [attribute1.imgRight floatValue], [attribute1.imgDown floatValue]);
        self.img1.image = [self transfer:rectMAX1 :oldImage];
        self.label1.text = attribute1.imgClass;
        UIImage * Image1 = [self addText:oldImage :[NSString stringWithFormat:@"%@ %@",attribute1.imgClass,attribute1.imgScore] :[attribute1.imgLeft floatValue] + 0.5*([attribute1.imgRight floatValue] - [attribute1.imgLeft floatValue]) :[attribute1.imgUp floatValue] + 0.5*([attribute1.imgDown floatValue] - [attribute1.imgUp floatValue])];
        BinAttribute * attribute2 = self.array[1];
        CGRect rectMAX2 = CGRectMake([attribute2.imgLeft floatValue], [attribute2.imgUp floatValue], [attribute2.imgRight floatValue], [attribute2.imgDown floatValue]);
        self.img2.image = [self transfer:rectMAX2 :oldImage];
        self.label2.text = attribute2.imgClass;
        UIImage * Image2 = [self addText:Image1 :[NSString stringWithFormat:@"%@ %@",attribute2.imgClass,attribute2.imgScore] :[attribute2.imgLeft floatValue] + 0.5*([attribute2.imgRight floatValue] - [attribute2.imgLeft floatValue]) :[attribute2.imgUp floatValue] + 0.5*([attribute2.imgDown floatValue] - [attribute2.imgUp floatValue])];
        BinAttribute * attribute3 = self.array[2];
        CGRect rectMAX3 = CGRectMake([attribute3.imgLeft floatValue], [attribute3.imgUp floatValue], [attribute3.imgRight floatValue], [attribute3.imgDown floatValue]);
        self.img3.image = [self transfer:rectMAX3 :oldImage];
        self.label3.text = attribute3.imgClass;
        UIImage * Image3 = [self addText:Image2 :[NSString stringWithFormat:@"%@ %@",attribute3.imgClass,attribute3.imgScore] :[attribute3.imgLeft floatValue] + 0.5*([attribute3.imgRight floatValue] - [attribute3.imgLeft floatValue]) :[attribute3.imgUp floatValue] + 0.5*([attribute3.imgDown floatValue] - [attribute3.imgUp floatValue])];
        BinAttribute * attribute4 = self.array[2];
        CGRect rectMAX4 = CGRectMake([attribute4.imgLeft floatValue], [attribute4.imgUp floatValue], [attribute4.imgRight floatValue], [attribute4.imgDown floatValue]);
        self.img4.image = [self transfer:rectMAX4 :oldImage];
        self.label4.text = attribute4.imgClass;
        UIImage * Image4 = [self addText:Image3 :[NSString stringWithFormat:@"%@ %@",attribute4.imgClass,attribute4.imgScore] :[attribute4.imgLeft floatValue] + 0.5*([attribute4.imgRight floatValue] - [attribute4.imgLeft floatValue]) :[attribute4.imgUp floatValue] + 0.5*([attribute4.imgDown floatValue] - [attribute4.imgUp floatValue])];
        self.imgView.image = Image4;
        if([attribute1.imgClass isEqualToString:@"dog"])
        {
            self.transferImage = self.img1.image;
        }
        else if([attribute2.imgClass isEqualToString:@"dog"])
        {
            self.transferImage = self.img2.image;
        }
        else if([attribute3.imgClass isEqualToString:@"dog"])
        {
            self.transferImage = self.img3.image;
        }
        else if([attribute4.imgClass isEqualToString:@"dog"])
        {
            self.transferImage = self.img4z.image;
        }
        else
        {
            [self.toPhoto setEnabled: NO];
        }
    }
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BinPhotoViewController * target = segue.destinationViewController;
    target.transferImg = self.transferImage;
}



-(UIImage *)transfer: (CGRect)rectMAX:(UIImage*)oldImage
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(oldImage.CGImage, rectMAX);
    UIGraphicsBeginImageContext(rectMAX.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rectMAX, subImageRef);
    UIImage *viewImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return viewImage;
}

-(UIImage *)addText:(UIImage *)img:(NSString *)text1 :(NSInteger)left :(NSInteger)up
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    char* text = (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, "Georgia", 30, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
    //CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
    CGContextShowTextAtPoint(context, left, img.size.height - up, text, strlen(text));
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}


-(void) socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [self showMessageWithStr:@"链接成功"];
    [self showMessageWithStr:[NSString stringWithFormat:@"服务器IP: %@,%i", host,port]];
    //    [self.clientSocket readDataWithTimeout:- 1 tag:0];
    
    //    //发消息
    UIImage * image = self.imgView.image;
    NSData * dataObj = UIImagePNGRepresentation(image);
    
    //NSData *data = [@"test123\n" dataUsingEncoding:NSUTF8StringEncoding];
    
    
    // withTimeout -1 : 无穷大,一直等
    // tag : 消息标记
    [self.clientSocket writeData:dataObj withTimeout:-1 tag:0];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError*)err
{
    NSLog(@"socket连接建立失败:%@",err);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"%ld", data.length);
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *aArray = [text componentsSeparatedByString:@"\n"];
    self.array = nil;
    self.array = [NSMutableArray arrayWithCapacity:10];
    for(int i = 0; i < aArray.count - 2; i++)
    {
        BinAttribute * attribute = [[BinAttribute alloc] initWithString: aArray[i]];
        [self.array addObject: attribute];
    }
    [self showMessageWithStr:text];
    [self.clientSocket readDataWithTimeout:- 1 tag:0];
}



- (void)showMessageWithStr:(NSString *)str {
    NSLog(@"%@",str);
    for(int i = 0; i < self.array.count; i++)
    {
        BinAttribute * attribute = self.array[i];
        NSLog(@"%@",attribute.imgClass);
    }
    if(self.array.count != 0)
    {
        [self performTransfer];
        self.array = nil;
    }
    
}












- (void)dealloc {
    [_toPhoto release];
    [super dealloc];
}
@end
