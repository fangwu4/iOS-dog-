//
//  BinShowViewController.m
//  UI
//
//  Created by hha6027875 on 30/3/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import "BinShowViewController.h"
#import "BinDog.h"
@interface BinShowViewController ()
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation BinShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Name.text = self.dogs.name;
    self.imgView1.image = [UIImage imageNamed:self.dogs.bimgf];
    self.imgView2.image = [UIImage imageNamed:self.dogs.bimgs];
    self.imgView3.image = [UIImage imageNamed:self.dogs.bimgt];
    self.imgView4.image = [UIImage imageNamed:self.dogs.bimgfo];
    self.textView.text = self.dogs.intro;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
