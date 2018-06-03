//
//  BinPhotoViewController.m
//  UI
//
//  Created by hha6027875 on 30/3/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import "BinPhotoViewController.h"
#import "ImageAdjust.h"
#import "dogmodel.h"
#import "BinGroup.h"
#import "BinDog.h"
#import "BinShowViewController.h"
#import "GCDAsyncSocket.h"

@interface BinPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (nonatomic, strong) NSMutableArray* groups;
@property (nonatomic, copy) NSString * clickDog;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@end

@implementation BinPhotoViewController
-(NSArray *)groups
{
    if(_groups == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"dogs1.plist" ofType:nil];
        NSArray * arrayDict = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayModels = [NSMutableArray array];
        for(NSDictionary *dict in arrayDict)
        {
            BinGroup * model = [BinGroup groupWithDict:dict];
            [arrayModels addObject:model];
        }
        _groups = arrayModels;
    }
    return _groups;
}
- (IBAction)btnClick1:(UIButton *)sender {
    self.clickDog = [NSString stringWithString: sender.currentTitle];
    [self performSegueWithIdentifier:@"toShow" sender:nil];
}

- (IBAction)btnClick2:(UIButton *)sender {
    self.clickDog = [NSString stringWithString: sender.currentTitle];
    [self performSegueWithIdentifier:@"toShow" sender:nil];
    NSLog(@"E2");
}

- (IBAction)btnClick3:(UIButton *)sender {
    self.clickDog = [NSString stringWithString: sender.currentTitle];
   [self performSegueWithIdentifier:@"toShow" sender:nil];
}
- (IBAction)btnClick4:(UIButton *)sender {
    self.clickDog = [NSString stringWithString: sender.currentTitle];
   [self performSegueWithIdentifier:@"toShow" sender:nil];
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

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (IBAction)selectPhoto:(id)sender {
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
    
    if(self.transferImg != nil)
    {
        self.imgView.image = self.transferImg;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imgView.image = chosenImage;
    self.transferImg = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)predict:(id)sender {
    dogmodelOutput *result = [self predictImageScene:self.transferImg];
    NSMutableArray *keysArray = [[result.prob allKeys] mutableCopy];
    [self bubblesort:keysArray :result];
    NSLog(@"daozhelema");
    NSString *prolist = @"";
    self.label1.text = [prolist stringByAppendingFormat:@"%f%%", [result.prob[keysArray[0]] doubleValue]* 100];
    prolist = @"";
    self.label2.text = [prolist stringByAppendingFormat:@"%f%%", [result.prob[keysArray[1]] doubleValue]* 100 ];
    prolist = @"";
    self.label3.text = [prolist stringByAppendingFormat:@"%f%%", [result.prob[keysArray[2]] doubleValue] * 100];
    prolist = @"";
    self.label4.text = [prolist stringByAppendingFormat:@"%f%%", [result.prob[keysArray[3]] doubleValue] * 100];
    [self.button1 setTitle:keysArray[0] forState:UIControlStateNormal];
    [self.button2 setTitle:keysArray[1] forState:UIControlStateNormal];
    [self.button3 setTitle:keysArray[2] forState:UIControlStateNormal];
    [self.button4 setTitle:keysArray[3] forState:UIControlStateNormal];
    [self.button1 setTintColor:[UIColor blueColor]];
    [self.button2 setTintColor:[UIColor blueColor]];
    [self.button3 setTintColor:[UIColor blueColor]];
    [self.button4 setTintColor:[UIColor blueColor]];
    
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


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   NSString *path = [[NSBundle mainBundle] pathForResource:@"dogs1.plist" ofType:nil];
   NSArray * arrayDict = [NSArray arrayWithContentsOfFile:path];
   NSMutableArray *arrayModels = [NSMutableArray array];
   for(NSDictionary *dict in arrayDict)
   {
        BinGroup * model = [BinGroup groupWithDict:dict];
        [arrayModels addObject:model];
   }
   BinShowViewController * target = segue.destinationViewController;
   for(BinGroup * group in arrayModels)
    {
        for(BinDog * dog in group.dogs)
        {
            NSString * label = [NSString stringWithString:dog.name];
            if([label isEqualToString:[self.clickDog substringToIndex:self.clickDog.length - 1]])
            {
                target.dogs = dog;
            }
        }
    }
   
}





@end
