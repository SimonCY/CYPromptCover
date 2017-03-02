//
//  CYPromptCOverViewQueue.h
//  CYPromptCoverTest
//
//  Created by RRTY on 17/3/1.
//  Copyright © 2017年 deepAI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYPromptCoverView;
@class CYPromptCoverViewQueue;

@protocol CYPromptCoverViewQueueDelegate <NSObject>

@optional
- (void)CYPromptCoverViewQueue:(CYPromptCoverViewQueue *)queue didDismissCoverAtIndex:(NSUInteger)index;
- (void)CYPromptCoverViewQueueDidDismissAllCovers:(CYPromptCoverViewQueue *)queue;
- (void)CYPromptCoverViewQueue:(CYPromptCoverViewQueue *)queue didClickedNeverBtnInCoverView:(CYPromptCoverView *)coverView;
@end


@interface CYPromptCoverViewQueue : NSObject

@property (nonatomic,weak) id<CYPromptCoverViewQueueDelegate>delegate;

@property (readonly, strong) NSMutableArray<__kindof CYPromptCoverView *> *covers;

@property (readonly,strong) CYPromptCoverView* showingCover;

- (void)addPromptCoverView:(CYPromptCoverView *)aCover;

- (void)showCoversInView:(UIView *)aView;

- (void)dismissAllCovers;
@end
