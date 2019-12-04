//
//  ViewController.m
//  NOVAppReview-OC
//
//  Created by YangYu on 2019/12/4.
//  Copyright © 2019 YangYu. All rights reserved.
//

#import "ViewController.h"
#import <NOVAppReview/NOVAppReview-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)action:(id)sender {
    
    [[NOVAppReview shared] showReview];

}


@end
