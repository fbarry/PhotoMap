//
//  FullImageViewController.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Copyright © 2018 Codepath. All rights reserved.
//

#import "FullImageViewController.h"

@interface FullImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FullImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageView setImage:self.image];
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
