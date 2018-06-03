//
//  BinScrollViewController.m
//  UI
//
//  Created by hha6027875 on 29/3/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import "BinScrollViewController.h"

@interface BinScrollViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation BinScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat maxH = CGRectGetMaxY(self.imgView.frame);
    self.scrollView.contentSize = CGSizeMake(0, maxH);
    // Do any additional setup after loading the view.
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
