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

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *positionBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *aSegement;
@property (weak, nonatomic) IBOutlet UIStepper *aStepper;


@property (weak, nonatomic) IBOutlet UISwitch *down;
@property (weak, nonatomic) IBOutlet UISwitch *right_down;
@property (weak, nonatomic) IBOutlet UISwitch *right;
@property (weak, nonatomic) IBOutlet UISwitch *right_up;
@property (weak, nonatomic) IBOutlet UISwitch *up;
@property (weak, nonatomic) IBOutlet UISwitch *left_up;
@property (weak, nonatomic) IBOutlet UISwitch *left;
@property (weak, nonatomic) IBOutlet UISwitch *left_down;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self.typeBtn addTarget:self action:@selector(typeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.positionBtn addTarget:self action:@selector(positionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)typeBtnClicked {
    CYPromptCoverViewQueue *queue = [[CYPromptCoverViewQueue alloc] init];
    queue.delegate = self;
    
    CYPromptCoverView *cover0 = [[CYPromptCoverView alloc] initWithBgColor:[UIColor colorWithWhite:0 alpha:0.5] revealView:self.typeBtn revealType:CYPromptCoverViewRevealTypeOval layoutType:CYPromptCoverViewLayoutTypeRightDown];
    cover0.des = @"000000000000";
    cover0.detailDes = @"3s 4s 5s";
    
    CYPromptCoverView *cover1  =[[CYPromptCoverView alloc] initWithBlurRadius:0.5 revealView:self.aSegement revealType:CYPromptCoverViewRevealTypeRect layoutType:CYPromptCoverViewLayoutTypeRightDown];
    cover1.des = @"111111111";
    cover1.detailDes = @"3s 4s 5s";

    CYPromptCoverView *cover2 = [[CYPromptCoverView alloc] initWithRevalView:self.aStepper layoutType:CYPromptCoverViewLayoutTypeRightDown];
    cover2.des = @"22222222222";
    cover2.detailDes = @"3s 4s 5s";
    
    [queue addPromptCoverView:cover0];
    [queue addPromptCoverView:cover1];
    [queue addPromptCoverView:cover2];
    
    [queue showCoversInView:self.view];
}

- (void)positionBtnClicked {

    CYPromptCoverViewQueue *queue = [[CYPromptCoverViewQueue alloc] init];
    queue.delegate = self;
    
    CYPromptCoverView *cover0 = [[CYPromptCoverView alloc] initWithRevalView:self.down  layoutType:CYPromptCoverViewLayoutTypeDown];
    cover0.des = @"000000000000";
    cover0.detailDes = @"3s 4s 5s";
    
    CYPromptCoverView *cover1  =[[CYPromptCoverView alloc] initWithRevalView:self.right_down  layoutType:CYPromptCoverViewLayoutTypeRightDown];
    cover1.des = @"111111111";
    cover1.detailDes = @"3s 4s 5s";
    
    CYPromptCoverView *cover2 = [[CYPromptCoverView alloc] initWithRevalView:self.right layoutType:CYPromptCoverViewLayoutTypeRight];
    cover2.des = @"22222222222";
    cover2.detailDes = @"3s 4s 5s";
    
    CYPromptCoverView *cover3 = [[CYPromptCoverView alloc] initWithRevalView:self.right_up layoutType:CYPromptCoverViewLayoutTypeRightUP];
    cover3.des = @"33333333";
    cover3.detailDes = @"3s 4s 5s";
    
    CYPromptCoverView *cover4 = [[CYPromptCoverView alloc] initWithRevalView:self.up layoutType:CYPromptCoverViewLayoutTypeUP];
    cover4.des = @"4444444";
    cover4.detailDes = @"3s 4s 5s";
    cover4.neverBtnCenter = CGPointMake(self.view.center.x,40);
    
    CYPromptCoverView *cover5 = [[CYPromptCoverView alloc] initWithRevalView:self.left_up   layoutType:CYPromptCoverViewLayoutTypeLeftUP];
    cover5.des = @"5555555555555";
    cover5.detailDes = @"3s 4s 5s";
    
    CYPromptCoverView *cover6 = [[CYPromptCoverView alloc] initWithRevalView:self.left layoutType:CYPromptCoverViewLayoutTypeLeft];
    cover6.des = @"66666666666";
    cover6.detailDes = @"3s 4s 5s";
    
    CYPromptCoverView *cover7 = [[CYPromptCoverView alloc] initWithRevalView:self.left_down layoutType:CYPromptCoverViewLayoutTypeLeftDown];
    cover7.des = @"77777777777777";
    cover7.detailDes = @"3s 4s 5s";
    
    [queue addPromptCoverView:cover0];
    [queue addPromptCoverView:cover1];
    [queue addPromptCoverView:cover2];
    [queue addPromptCoverView:cover3];
    [queue addPromptCoverView:cover4];
    [queue addPromptCoverView:cover5];
    [queue addPromptCoverView:cover6];
    [queue addPromptCoverView:cover7];
    
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
