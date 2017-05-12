//
//  CYPromptCOverViewQueue.m
//  CYPromptCoverTest
//
//  Created by RRTY on 17/3/1.
//  Copyright © 2017年 deepAI. All rights reserved.
//

#import "CYPromptCoverViewQueue.h"
#import "CYPromptCoverView.h"

@interface CYPromptCoverViewQueue()<CYPromptCoverViewDelegate>
@property (nonatomic,weak) UIView* foundationView;
@end

//设置这个全局变量是对queue进行引用，防止queue创建后自己销毁
id instance = nil;

@implementation CYPromptCoverViewQueue


#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        instance = self;
    }
    return self;
}

#pragma mark - public
- (void)addPromptCoverView:(CYPromptCoverView *)aCover {
    NSAssert(aCover, @"inset nil object to coverQueue");
    NSAssert([aCover isKindOfClass:[CYPromptCoverView class]], @"inset no-promptCoverView to coverQueue");
    
    if (_covers == nil) {
        _covers = [NSMutableArray array];
    }
    [_covers addObject:aCover];
    aCover.delegate = self;
}

- (void)showCoversInView:(UIView *)aView {
    NSAssert(aView, @"foundationView is nil");
    self.foundationView = aView;
    [self showCoverAtIndex:0];
}


- (void)dismissAllCovers {
    [_covers removeAllObjects];
    if (_showingCover) {
        [_showingCover dismiss];
    }
    instance = nil;
}

#pragma mark - pravite
- (void)showCoverAtIndex:(NSUInteger)index {
    CYPromptCoverView *cover = _covers[index];
    
    if (index == 0) {
        cover.dismissDuration = 0;
        cover.dismissBtnTitle = @"下一步";
    } else if (index == (_covers.count - 1)) {
        cover.showDuration = 0;
        cover.dismissBtnTitle = @"完成";
    } else {
        cover.showDuration = 0;
        cover.dismissDuration = 0;
        cover.dismissBtnTitle = @"下一步";
    }
    [cover showInView:self.foundationView];
    _showingCover = cover;
}

#pragma mark - coverDelegate
- (void)CYPromptCoverViewDidClickedDismissBtn:(CYPromptCoverView *)coverView {
    
    NSUInteger index = [_covers indexOfObject:coverView];
    _showingCover = nil;
    
    if (index == _covers.count - 1) {
        [self dismissAllCovers];
        if (self.delegate && [self.delegate respondsToSelector:@selector(CYPromptCoverViewQueueDidDismissAllCovers:)]) {
            [self.delegate CYPromptCoverViewQueueDidDismissAllCovers:self];
        }
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(CYPromptCoverViewQueue:didDismissCoverAtIndex:)]) {
        [self.delegate CYPromptCoverViewQueue:self didDismissCoverAtIndex:index];
    }
    
    NSUInteger nextIndex = index + 1;
    
    [self showCoverAtIndex:nextIndex];
}

- (void)CYPromptCoverViewDidClickedNeverBtn:(CYPromptCoverView *)coverView {
    
    [self dismissAllCovers];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CYPromptCoverViewQueue:didClickedNeverBtnInCoverView:)]) {
        [self.delegate CYPromptCoverViewQueue:self didClickedNeverBtnInCoverView:coverView];
    }
}
@end
