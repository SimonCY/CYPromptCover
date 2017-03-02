//
//  ViewController.m
//  CYPromptCoverTest
//
//  Created by RRTY on 17/2/28.
//  Copyright © 2017年 deepAI. All rights reserved.
//

#import "ViewController.h"
#import "CYPromptCover.h"


@interface ViewController ()<CYPromptCoverViewQueueDelegate>

@property (weak, nonatomic) IBOutlet UIButton *aBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *aSegement;
@property (weak, nonatomic) IBOutlet UISwitch *aSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    CYPromptCoverViewQueue *queue = [[CYPromptCoverViewQueue alloc] init];
    queue.delegate = self;
    
    CYPromptCoverView *cover0 = [[CYPromptCoverView alloc] initWithBgColor:[UIColor colorWithWhite:0 alpha:0.5] revealView:self.aBtn revealType:CYPromptCoverViewRevealTypeOval];
    cover0.des = @"000000000000";
    cover0.detailDes = @"3s 4s 5s";
    
    CYPromptCoverView *cover1  =[[CYPromptCoverView alloc] initWithBlurRadius:0.5 revealView:self.aSegement revealType:CYPromptCoverViewRevealTypeRect];
    cover1.des = @"111111111";
    cover1.detailDes = @"3s 4s 5s";

    CYPromptCoverView *cover2 = [[CYPromptCoverView alloc] initWithRevalView:self.aSwitch];
    cover2.des = @"22222222222";
    cover2.detailDes = @"3s 4s 5s";
    
    [queue addPromptCoverView:cover0];
    [queue addPromptCoverView:cover1];
    [queue addPromptCoverView:cover2];
    
    [queue showCoversInView:self.view];
}

#pragma mark - queuedelegate
- (void)CYPromptCoverViewQueue:(CYPromptCoverViewQueue *)queue didDismissCoverAtIndex:(NSUInteger)index {
    NSLog(@"index is %ld",index);
}
- (void)CYPromptCoverViewQueueDidDismissAllCovers:(CYPromptCoverViewQueue *)queue {

}

- (void)CYPromptCoverViewQueue:(CYPromptCoverViewQueue *)queue didClickedNeverBtnInCoverView:(CYPromptCoverView *)coverView {
    
}

@end
