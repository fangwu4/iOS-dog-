//
//  BinPhotoViewController.h
//  UI
//
//  Created by hha6027875 on 30/3/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dogmodel.h"
@interface BinPhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) UIImage * transferImg;
@end
