//
//  CYPromptCoverView.h
//  CYPromptCoverTest
//
//  Created by RRTY on 17/2/28.
//  Copyright © 2017年 deepAI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYPromptCoverView;


typedef NS_ENUM(NSUInteger, CYPromptCoverViewRevealType) {
    CYPromptCoverViewRevealTypeRect = 0,    //矩形  default
    CYPromptCoverViewRevealTypeOval         //椭圆
};

typedef NS_ENUM(NSUInteger, CYPromptCoverViewCoverType) {
    CYPromptCoverViewCoverTypeColored,      //颜色      default
    CYPromptCoverViewCoverTypeBlurred       //模糊
};


typedef NS_ENUM(NSUInteger, CYPromptCoverViewLayoutType) {
    CYPromptCoverViewLayoutTypeUP,          //描述label所处的位置
    CYPromptCoverViewLayoutTypeLeftUP,
    CYPromptCoverViewLayoutTypeLeft,
    CYPromptCoverViewLayoutTypeLeftDown,
    CYPromptCoverViewLayoutTypeDown,
    CYPromptCoverViewLayoutTypeRightDown,
    CYPromptCoverViewLayoutTypeRight,
    CYPromptCoverViewLayoutTypeRightUP,
    
};



@protocol CYPromptCoverViewDelegate <NSObject>

@optional
- (void)CYPromptCoverViewDidClickedDismissBtn:(CYPromptCoverView *)coverView;
- (void)CYPromptCoverViewDidClickedNeverBtn:(CYPromptCoverView *)coverView;
@end


@interface CYPromptCoverView : UIView

@property (nonatomic,weak) id<CYPromptCoverViewDelegate> delegate;


@property (nonatomic,assign) CYPromptCoverViewCoverType coverType;
@property (nonatomic,assign) CYPromptCoverViewRevealType revealType;

@property (nonatomic,assign,getter=isDesHidden) BOOL desHidden;


//is essential to bluredCoverType  0 — 1  default is 0.5
@property(nonatomic,assign) CGFloat blurRadius;
//is essential to coloredCoverType  default is 0 0 0 0.8
@property (nonatomic,strong) UIColor *coverColor;
//white
@property (nonatomic,strong,readonly) UIColor* tintColor;

//default is 0.2
@property (nonatomic,assign) CGFloat showDuration;
//default is 0.2
@property (nonatomic,assign) CGFloat dismissDuration;

//x轴外扩的值   default is -5
@property(nonatomic,assign) CGFloat insetX;
//Y轴外扩的值   default is -5
@property(nonatomic,assign) CGFloat insetY;


@property (nonatomic,assign,readonly) CGRect revealFrame;

@property (nonatomic,assign) CYPromptCoverViewLayoutType layoutType;
@property (nonatomic,assign) CGPoint neverBtnCenter;

//default is 确定
@property (nonatomic,copy) NSString* dismissBtnTitle;
@property (nonatomic,copy) NSString* des;
@property (nonatomic,copy) NSString* detailDes;



- (instancetype)initWithRevalView:(UIView *)revalView layoutType:(CYPromptCoverViewLayoutType)layoutType;
// color背景色,aView漏出来的view,aType露出的类型,
- (instancetype)initWithBgColor:(UIColor *)bgColor revealView:(UIView *)revealView revealType:(CYPromptCoverViewRevealType)type layoutType:(CYPromptCoverViewLayoutType)layoutType;
// 带模糊背景的初始化
- (instancetype)initWithBlurRadius:(CGFloat)blurRadius revealView:(UIView *)revealView revealType:(CYPromptCoverViewRevealType)type layoutType:(CYPromptCoverViewLayoutType)layoutType;


- (void)showInView:(UIView *)view;
- (void)dismiss;
@end
