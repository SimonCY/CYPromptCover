//
//  CYPromptCoverView.m
//  CYPromptCoverTest
//
//  Created by RRTY on 17/2/28.
//  Copyright © 2017年 deepAI. All rights reserved.
//

#import "CYPromptCoverView.h"
#import <Accelerate/Accelerate.h>

@interface CYPromptCoverView ()

@property(nonatomic,weak) UIView *revealView;
@property (nonatomic,strong) UIImage* bgImg;

@property (nonatomic,weak) UIImageView* arrowImgView;

@property (nonatomic,weak) UILabel* desLabel;
@property (nonatomic,weak) UILabel* subDesLabel;
@property (nonatomic,weak) UIButton* dismissBtn;
@property (nonatomic,weak) UIButton* neverBtn;

@end

@implementation CYPromptCoverView

#pragma mark - public
- (void)showInView:(UIView *)view {

    self.alpha = 0.f;
    
    switch (self.coverType) {
            
        case CYPromptCoverViewCoverTypeColored:
            self.bgImg = [self.class imageWithColor:self.coverColor];
            break;
            
        case CYPromptCoverViewCoverTypeBlurred:
            self.bgImg = [self.class blurredImageWithImage:[self.class imageFromView:view andOpaque:NO] radius:self.blurRadius iterations:3 tintColor:[UIColor colorWithWhite:0.0f alpha:0.3f]];
            break;
            
        default:
            break;
    }
    

    
    [view addSubview:self];
    [view setNeedsDisplay];
    
    [UIView animateWithDuration:self.showDuration delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:nil];
}

- (void)dismiss {
    
    [UIView animateWithDuration:self.dismissDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - init
- (instancetype)initWithBgColor:(UIColor *)bgColor revealView:(UIView *)revealView revealType:(CYPromptCoverViewRevealType)revealType layoutType:(CYPromptCoverViewLayoutType)layoutType {
    if (self = [super initWithFrame:[[UIScreen mainScreen]bounds]]) {
        
        [self commonSetupWithCoverType:CYPromptCoverViewCoverTypeColored revealType:revealType revealView:revealView layoutType:layoutType];

        self.coverColor = bgColor;
        
        [self setupAttachUI];
    }
    return self;
}

- (instancetype)initWithBlurRadius:(CGFloat)blurRadius revealView:(UIView *)revealView revealType:(CYPromptCoverViewRevealType)revealType layoutType:(CYPromptCoverViewLayoutType)layoutType {
    if (self = [super initWithFrame:[[UIScreen mainScreen]bounds]]) {
        
        [self commonSetupWithCoverType:CYPromptCoverViewCoverTypeBlurred revealType:revealType revealView:revealView layoutType:layoutType];
 
        self.blurRadius = blurRadius;
        
        [self setupAttachUI];
    }
    return self;
}

- (instancetype)initWithRevalView:(UIView *)revalView layoutType:(CYPromptCoverViewLayoutType)layoutType {
    if (self = [super initWithFrame:[[UIScreen mainScreen]bounds]]) {
        
        [self commonSetupWithCoverType:CYPromptCoverViewCoverTypeColored revealType:CYPromptCoverViewRevealTypeRect revealView:revalView layoutType:layoutType];
 
        [self setupAttachUI];
    }
    return self;
}

- (void)commonSetupWithCoverType:(CYPromptCoverViewCoverType)coverType revealType:(CYPromptCoverViewRevealType)revealType revealView:(UIView *)revealView layoutType:(CYPromptCoverViewLayoutType)layoutType {
    //some default configuration
    self.backgroundColor = [UIColor clearColor];
    _tintColor = [UIColor whiteColor];
    self.coverColor = [UIColor colorWithWhite:0 alpha:0.8];
    self.blurRadius = 0.5;
    self.showDuration = 0.2;
    self.dismissDuration = 0.2;
    self.insetX = -5;
    self.insetY = -5;
    
    self.coverType = coverType;
    self.revealType = revealType;
    self.revealView = revealView;
    self.layoutType = layoutType;
    
    self.neverBtnCenter = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height - 30 - 10);
}

- (void)setupAttachUI {

    if (self.isDesHidden) {
        return;
    }
    
    //arrowImageView
    UIImageView *arrowImgView = [[UIImageView alloc] init];
    arrowImgView.contentMode = UIViewContentModeScaleAspectFit;
    arrowImgView.backgroundColor = [UIColor clearColor];
    [self addSubview:arrowImgView];
    self.arrowImgView = arrowImgView;
    
    //desLabel
    UILabel *desLabel = [[UILabel alloc]init];
    [desLabel setTextColor:_tintColor];
    desLabel.font = [UIFont systemFontOfSize:13];
    desLabel.numberOfLines = 1;
    [self addSubview:desLabel];
    self.desLabel = desLabel;
    
    //subDesLabel
    UILabel *subDesLabel = [[UILabel alloc]init];
    [subDesLabel setTextColor:_tintColor];
    subDesLabel.font = [UIFont systemFontOfSize:11];
    subDesLabel.text = self.detailDes;
    subDesLabel.numberOfLines = 1;
    [subDesLabel sizeToFit];
    [self addSubview:subDesLabel];
    self.subDesLabel = subDesLabel;
    
    //dismissBtn
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [dismissBtn setTitle:self.dismissBtnTitle?self.dismissBtnTitle:@"确定" forState:UIControlStateNormal];
    [dismissBtn setTitleColor:_tintColor forState:UIControlStateNormal];
    [dismissBtn setBackgroundColor:[UIColor clearColor]];
    dismissBtn.layer.cornerRadius = 4;
    dismissBtn.layer.borderColor = _tintColor.CGColor;
    dismissBtn.layer.borderWidth = 1;
    [dismissBtn addTarget:self action:@selector(dismissBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:dismissBtn];
    self.dismissBtn = dismissBtn;
    
    //neverBtn
    UIButton *neverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    neverBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [neverBtn setTitle:@"不再提示" forState:UIControlStateNormal];
    [neverBtn setTitleColor:_tintColor forState:UIControlStateNormal];
    [neverBtn setBackgroundColor:[UIColor clearColor]];
    neverBtn.layer.cornerRadius = 10;
    neverBtn.layer.borderColor = _tintColor.CGColor;
    neverBtn.layer.borderWidth = 0.5;
    [neverBtn addTarget:self action:@selector(neverBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:neverBtn];
    self.neverBtn = neverBtn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //neverBtn
    CGFloat neverBtnW = 60;
    CGFloat neverBtnH = 20;
    CGFloat neverBtnX = (self.bounds.size.width - neverBtnW) / 2;
    CGFloat neverBtnY = self.bounds.size.height - neverBtnH - 30;
    self.neverBtn.frame = CGRectMake(neverBtnX, neverBtnY, neverBtnW, neverBtnH);
    self.neverBtn.center = self.neverBtnCenter;
    
    CGFloat arrowWH , arrowX, arrowY, desW, desH, desX, desY, subDesW, subDesH, subDesX, subDesY, disMissW, dismissH, dismissX, dismissY;
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"CYPromptCover" ofType:@"bundle"];
 
    //others
    switch (self.layoutType) {
        case CYPromptCoverViewLayoutTypeUP: {

            //arrow
            NSString *imgPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"cy_up.png" ofType:nil];
            self.arrowImgView.image = [UIImage imageWithContentsOfFile:imgPath];
            arrowWH = 30;
            arrowX = (self.revealType? [self ovalRect]:[self revealRect]).origin.x + (self.revealType? [self ovalRect]:[self revealRect]).size.width / 2 - arrowWH / 2;
            arrowY = self.revealType? CGRectGetMinX([self ovalRect]):CGRectGetMinY([self revealRect]) - arrowWH - 10;
            self.arrowImgView.frame = CGRectMake(arrowX, arrowY, arrowWH, arrowWH);
            
            //dismissBtn
            disMissW = 60;
            dismissH = 30;
            dismissX = CGRectGetMaxX(self.arrowImgView.frame) - arrowWH / 2 ;
            dismissY = CGRectGetMinY(self.arrowImgView.frame) - dismissH - 10;
            self.dismissBtn.frame = CGRectMake(dismissX, dismissY, disMissW, dismissH);
            self.dismissBtn.center = CGPointMake(self.arrowImgView.center.x, self.dismissBtn.center.y);
            
            //subDes
            self.subDesLabel.text = self.detailDes;
            [self.subDesLabel sizeToFit];
            subDesW = self.subDesLabel.bounds.size.width;
            subDesH = self.subDesLabel.bounds.size.height;
            subDesX = CGRectGetMinX(self.dismissBtn.frame);
            subDesY = CGRectGetMinY(self.dismissBtn.frame) - subDesH - 10;
            self.subDesLabel.frame = CGRectMake(subDesX, subDesY, subDesW, subDesH);
            self.subDesLabel.center = CGPointMake(self.arrowImgView.center.x, self.subDesLabel.center.y);
            
            //des
            self.desLabel.text = self.des;
            [self.desLabel sizeToFit];
            desW = self.desLabel.bounds.size.width;
            desH = self.desLabel.bounds.size.height;
            desX = CGRectGetMinX(self.dismissBtn.frame);
            desY = CGRectGetMinY(self.subDesLabel.frame) - desH - 10;
            self.desLabel.frame = CGRectMake(desX, desY, desW, desH);
            self.desLabel.center = CGPointMake(self.arrowImgView.center.x, self.desLabel.center.y);
            break;
        }
        case CYPromptCoverViewLayoutTypeLeftUP: {
            
            //arrow
            NSString *imgPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"cy_left_up.png" ofType:nil];
            self.arrowImgView.image = [UIImage imageWithContentsOfFile:imgPath];
            arrowWH = 30;
            arrowX = self.revealType? CGRectGetMinX([self ovalRect]):CGRectGetMinX([self revealRect]) -arrowWH - 10;
            arrowY = self.revealType? CGRectGetMinY([self ovalRect]):CGRectGetMinY([self revealRect]) - arrowWH / 2;
            self.arrowImgView.frame = CGRectMake(arrowX, arrowY, arrowWH, arrowWH);
            
            //dismissBtn
            disMissW = 60;
            dismissH = 30;
            dismissX = CGRectGetMinX(self.arrowImgView.frame) + arrowWH / 2 - disMissW;
            dismissY = CGRectGetMinY(self.arrowImgView.frame) - dismissH - 10;
            self.dismissBtn.frame = CGRectMake(dismissX, dismissY, disMissW, dismissH);
            
            //subDes
            self.subDesLabel.text = self.detailDes;
            [self.subDesLabel sizeToFit];
            subDesW = self.subDesLabel.bounds.size.width;
            subDesH = self.subDesLabel.bounds.size.height;
            subDesX = CGRectGetMaxX(self.dismissBtn.frame) - subDesW;
            subDesY = CGRectGetMinY(self.dismissBtn.frame) - subDesH - 10;
            self.subDesLabel.frame = CGRectMake(subDesX, subDesY, subDesW, subDesH);
            
            //des
            self.desLabel.text = self.des;
            [self.desLabel sizeToFit];
            desW = self.desLabel.bounds.size.width;
            desH = self.desLabel.bounds.size.height;
            desX = CGRectGetMaxX(self.dismissBtn.frame) - desW;
            desY = CGRectGetMinY(self.subDesLabel.frame) - desH - 10;
            self.desLabel.frame = CGRectMake(desX, desY, desW, desH);
            
            break;

        }
        case CYPromptCoverViewLayoutTypeLeft: {
            
            //arrow
            NSString *imgPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"cy_left.png" ofType:nil];
            self.arrowImgView.image = [UIImage imageWithContentsOfFile:imgPath];
            arrowWH = 30;
            arrowX = self.revealType? CGRectGetMinX([self ovalRect]):CGRectGetMinX([self revealRect]) - arrowWH - 10;
            arrowY = self.revealType? CGRectGetMaxY([self ovalRect]):CGRectGetMaxY([self revealRect]) - arrowWH;
            self.arrowImgView.frame = CGRectMake(arrowX, arrowY, arrowWH, arrowWH);
            
            //des
            self.desLabel.text = self.des;
            [self.desLabel sizeToFit];
            desW = self.desLabel.bounds.size.width;
            desH = self.desLabel.bounds.size.height;
            desX = CGRectGetMinX(self.arrowImgView.frame) - desW - 10;
            desY = CGRectGetMaxY(self.arrowImgView.frame) + 10;
            self.desLabel.frame = CGRectMake(desX, desY, desW, desH);
            self.desLabel.center = CGPointMake(self.desLabel.center.x, self.arrowImgView.center.y);
            
            //subDes
            self.subDesLabel.text = self.detailDes;
            [self.subDesLabel sizeToFit];
            subDesW = self.subDesLabel.bounds.size.width;
            subDesH = self.subDesLabel.bounds.size.height;
            subDesX = CGRectGetMaxX(self.desLabel.frame) - subDesW;
            subDesY = CGRectGetMaxY(self.desLabel.frame) + 10;
            self.subDesLabel.frame = CGRectMake(subDesX, subDesY, subDesW, subDesH);
            
            //dismissBtn
            disMissW = 60;
            dismissH = 30;
            dismissX = CGRectGetMaxX(self.subDesLabel.frame) - disMissW;
            dismissY = CGRectGetMaxY(self.subDesLabel.frame) + 10;
            self.dismissBtn.frame = CGRectMake(dismissX, dismissY, disMissW, dismissH);
            
            break;
        }
        case CYPromptCoverViewLayoutTypeLeftDown: {
            
            //arrow
            NSString *imgPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"cy_left_down.png" ofType:nil];
            self.arrowImgView.image = [UIImage imageWithContentsOfFile:imgPath];
            arrowWH = 30;
            arrowX = self.revealType? CGRectGetMinX([self ovalRect]):CGRectGetMinX([self revealRect]) - arrowWH - 10;
            arrowY = self.revealType? CGRectGetMaxY([self ovalRect]):CGRectGetMaxY([self revealRect]) - arrowWH / 2;
            self.arrowImgView.frame = CGRectMake(arrowX, arrowY, arrowWH, arrowWH);
            
            //des
            self.desLabel.text = self.des;
            [self.desLabel sizeToFit];
            desW = self.desLabel.bounds.size.width;
            desH = self.desLabel.bounds.size.height;
            desX = CGRectGetMinX(self.arrowImgView.frame) - desW + arrowWH / 2;
            desY = CGRectGetMaxY(self.arrowImgView.frame) + 10;
            self.desLabel.frame = CGRectMake(desX, desY, desW, desH);
            
            //subDes
            self.subDesLabel.text = self.detailDes;
            [self.subDesLabel sizeToFit];
            subDesW = self.subDesLabel.bounds.size.width;
            subDesH = self.subDesLabel.bounds.size.height;
            subDesX = CGRectGetMaxX(self.desLabel.frame) - subDesW;
            subDesY = CGRectGetMaxY(self.desLabel.frame) + 10;
            self.subDesLabel.frame = CGRectMake(subDesX, subDesY, subDesW, subDesH);
            
            //dismissBtn
            disMissW = 60;
            dismissH = 30;
            dismissX = CGRectGetMaxX(self.subDesLabel.frame) - disMissW;
            dismissY = CGRectGetMaxY(self.subDesLabel.frame) + 10;
            self.dismissBtn.frame = CGRectMake(dismissX, dismissY, disMissW, dismissH);

            break;
        }
        case CYPromptCoverViewLayoutTypeDown: {
 
            //arrow
            NSString *imgPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"cy_down.png" ofType:nil];
            self.arrowImgView.image = [UIImage imageWithContentsOfFile:imgPath];
            arrowWH = 30;
            arrowX = (self.revealType? [self ovalRect]:[self revealRect]).origin.x + (self.revealType? [self ovalRect]:[self revealRect]).size.width / 2 - arrowWH / 2;
            arrowY = self.revealType? CGRectGetMaxX([self ovalRect]):CGRectGetMaxY([self revealRect]) + 10;
            self.arrowImgView.frame = CGRectMake(arrowX, arrowY, arrowWH, arrowWH);
            
            //des
            self.desLabel.text = self.des;
            [self.desLabel sizeToFit];
            desW = self.desLabel.bounds.size.width;
            desH = self.desLabel.bounds.size.height;
            desX = arrowX - desW / 2 + arrowWH / 2;
            desY = CGRectGetMaxY(self.arrowImgView.frame) + 10;
            self.desLabel.frame = CGRectMake(desX, desY, desW, desH);
            self.desLabel.center = CGPointMake(self.arrowImgView.center.x, self.desLabel.center.y);
            
            //subDes
            self.subDesLabel.text = self.detailDes;
            [self.subDesLabel sizeToFit];
            subDesW = self.subDesLabel.bounds.size.width;
            subDesH = self.subDesLabel.bounds.size.height;
            subDesX = CGRectGetMinX(self.desLabel.frame);
            subDesY = CGRectGetMaxY(self.desLabel.frame) + 10;
            self.subDesLabel.frame = CGRectMake(subDesX, subDesY, subDesW, subDesH);
            self.subDesLabel.center = CGPointMake(self.arrowImgView.center.x, self.subDesLabel.center.y);
            
            //dismissBtn
            disMissW = 60;
            dismissH = 30;
            dismissX = CGRectGetMinX(self.subDesLabel.frame);
            dismissY = CGRectGetMaxY(self.subDesLabel.frame) + 10;
            self.dismissBtn.frame = CGRectMake(dismissX, dismissY, disMissW, dismissH);
            self.dismissBtn.center = CGPointMake(self.arrowImgView.center.x, self.dismissBtn.center.y);
            
            break;
        }
        case CYPromptCoverViewLayoutTypeRightDown: {
            
            //arrow
            NSString *imgPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"cy_right_down.png" ofType:nil];
            self.arrowImgView.image = [UIImage imageWithContentsOfFile:imgPath];
            arrowWH = 30;
            arrowX = self.revealType? CGRectGetMaxX([self ovalRect]):CGRectGetMaxX([self revealRect]) + 10;
            arrowY = self.revealType? CGRectGetMaxY([self ovalRect]):CGRectGetMaxY([self revealRect]) - arrowWH / 2;
            self.arrowImgView.frame = CGRectMake(arrowX, arrowY, arrowWH, arrowWH);
            
            //des
            self.desLabel.text = self.des;
            [self.desLabel sizeToFit];
            desW = self.desLabel.bounds.size.width;
            desH = self.desLabel.bounds.size.height;
            desX = CGRectGetMaxX(self.arrowImgView.frame) - arrowWH / 2;
            desY = CGRectGetMaxY(self.arrowImgView.frame) + 10;
            self.desLabel.frame = CGRectMake(desX, desY, desW, desH);
            
            //subDes
            self.subDesLabel.text = self.detailDes;
            [self.subDesLabel sizeToFit];
            subDesW = self.subDesLabel.bounds.size.width;
            subDesH = self.subDesLabel.bounds.size.height;
            subDesX = CGRectGetMinX(self.desLabel.frame);
            subDesY = CGRectGetMaxY(self.desLabel.frame) + 10;
            self.subDesLabel.frame = CGRectMake(subDesX, subDesY, subDesW, subDesH);
            
            //dismissBtn
            disMissW = 60;
            dismissH = 30;
            dismissX = CGRectGetMinX(self.subDesLabel.frame);
            dismissY = CGRectGetMaxY(self.subDesLabel.frame) + 10;
            self.dismissBtn.frame = CGRectMake(dismissX, dismissY, disMissW, dismissH);
            
            break;
        }
        case CYPromptCoverViewLayoutTypeRight: {
            
            //arrow
            NSString *imgPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"cy_right.png" ofType:nil];
            self.arrowImgView.image = [UIImage imageWithContentsOfFile:imgPath];
            arrowWH = 30;
            arrowX = self.revealType? CGRectGetMaxX([self ovalRect]):CGRectGetMaxX([self revealRect]) + 10;
            arrowY = self.revealType? CGRectGetMaxY([self ovalRect]):CGRectGetMaxY([self revealRect]) - arrowWH;
            self.arrowImgView.frame = CGRectMake(arrowX, arrowY, arrowWH, arrowWH);
            
            //des
            self.desLabel.text = self.des;
            [self.desLabel sizeToFit];
            desW = self.desLabel.bounds.size.width;
            desH = self.desLabel.bounds.size.height;
            desX = CGRectGetMaxX(self.arrowImgView.frame) + 10;
            desY = CGRectGetMaxY(self.arrowImgView.frame) + 10;
            self.desLabel.frame = CGRectMake(desX, desY, desW, desH);
            self.desLabel.center = CGPointMake(self.desLabel.center.x, self.arrowImgView.center.y);
            
            //sudes
            self.subDesLabel.text = self.detailDes;
            [self.subDesLabel sizeToFit];
            subDesW = self.subDesLabel.bounds.size.width;
            subDesH = self.subDesLabel.bounds.size.height;
            subDesX = CGRectGetMinX(self.desLabel.frame);
            subDesY = CGRectGetMaxY(self.desLabel.frame) + 10;
            self.subDesLabel.frame = CGRectMake(subDesX, subDesY, subDesW, subDesH);
            
            //dismissBtn
            disMissW = 60;
            dismissH = 30;
            dismissX = CGRectGetMinX(self.subDesLabel.frame);
            dismissY = CGRectGetMaxY(self.subDesLabel.frame) + 10;
            self.dismissBtn.frame = CGRectMake(dismissX, dismissY, disMissW, dismissH);
            
            break;
        }
        case CYPromptCoverViewLayoutTypeRightUP: {

            //arrow
            NSString *imgPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"cy_right_up.png" ofType:nil];
            self.arrowImgView.image = [UIImage imageWithContentsOfFile:imgPath];
            arrowWH = 30;
            arrowX = self.revealType? CGRectGetMaxX([self ovalRect]):CGRectGetMaxX([self revealRect]) + 10;
            arrowY = self.revealType? CGRectGetMinY([self ovalRect]):CGRectGetMinY([self revealRect]) - arrowWH / 2;
            self.arrowImgView.frame = CGRectMake(arrowX, arrowY, arrowWH, arrowWH);
            
            //dismissBtn
            disMissW = 60;
            dismissH = 30;
            dismissX = CGRectGetMaxX(self.arrowImgView.frame) - arrowWH / 2 ;
            dismissY = CGRectGetMinY(self.arrowImgView.frame) - dismissH - 10;
            self.dismissBtn.frame = CGRectMake(dismissX, dismissY, disMissW, dismissH);

            //subDes
            self.subDesLabel.text = self.detailDes;
            [self.subDesLabel sizeToFit];
            subDesW = self.subDesLabel.bounds.size.width;
            subDesH = self.subDesLabel.bounds.size.height;
            subDesX = CGRectGetMinX(self.dismissBtn.frame);
            subDesY = CGRectGetMinY(self.dismissBtn.frame) - subDesH - 10;
            self.subDesLabel.frame = CGRectMake(subDesX, subDesY, subDesW, subDesH);

            //des
            self.desLabel.text = self.des;
            [self.desLabel sizeToFit];
            desW = self.desLabel.bounds.size.width;
            desH = self.desLabel.bounds.size.height;
            desX = CGRectGetMinX(self.dismissBtn.frame);
            desY = CGRectGetMinY(self.subDesLabel.frame) - desH - 10;
            self.desLabel.frame = CGRectMake(desX, desY, desW, desH);
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - set
- (void)setRevealView:(UIView *)revealView {
    _revealView = revealView;
    _revealFrame = [self revealRect];
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)setDismissBtnTitle:(NSString *)dismissBtnTitle {
    _dismissBtnTitle = [dismissBtnTitle copy];
    [_dismissBtn setTitle:dismissBtnTitle forState:UIControlStateNormal];
    [self setNeedsDisplay];
}

- (void)setDes:(NSString *)des {
    _des = [des copy];
    [self setNeedsLayout];
}

- (void)setDetailDes:(NSString *)detailDes {
    _detailDes = [detailDes copy];
    [self setNeedsLayout];
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    
    if (!(self.bgImg && self.revealView)) {
        return;
    }
    
//    if (!self.neverBtn) {
//        [self setupAttachUI];
//    }
    
    [self.bgImg drawInRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeClear);
    
    UIBezierPath* path = nil;

    switch (self.revealType) {
        case CYPromptCoverViewRevealTypeRect:
            path = [UIBezierPath bezierPathWithRoundedRect:[self revealRect] cornerRadius:4];
            break;
        case CYPromptCoverViewRevealTypeOval:{
            CGRect rect = [self ovalRect];
            path = [UIBezierPath bezierPathWithOvalInRect:rect];
        }
            break;
        default:
            break;
    }
    [[UIColor clearColor] set];
    [path fill];
    
}

#pragma mark - drawRect pravite
- (CGRect)revealRect {
    
    CGRect realRect = [_revealView.superview convertRect:_revealView.frame toView:self];
    return CGRectInset(realRect, _insetX, _insetY);
}

- (CGRect)ovalRect {
    
    CGRect rect = [self revealRect];
    //圆的直径
    CGFloat diameter = floorf(sqrtf(rect.size.width*rect.size.width + rect.size.height*rect.size.height));
    CGFloat rate = rect.size.width/rect.size.height;
    CGSize newSize;
    if (rate >= 1) {//宽大于长
        newSize = CGSizeMake(diameter, diameter/rate);
    } else {
        newSize = CGSizeMake(diameter/rate,diameter);
    }
    
    return CGRectMake(rect.origin.x - (newSize.width - rect.size.width)/2.0f, rect.origin.y - (newSize.height - rect.size.height)/2.0f, newSize.width, newSize.height);
}

#pragma mark - btnClicked
- (void)neverBtnClicked:(UIButton *)btn {

    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(CYPromptCoverViewDidClickedNeverBtn:)]) {
        [self.delegate CYPromptCoverViewDidClickedNeverBtn:self];
    }
}
- (void)dismissBtnClicked:(UIButton *)btn {
    
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(CYPromptCoverViewDidClickedDismissBtn:)]) {
        [self.delegate CYPromptCoverViewDidClickedDismissBtn:self];
    }
}


#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //过滤掉触摸事件
    if (self.desHidden) {
        [self dismiss];
        if (self.delegate && [self.delegate respondsToSelector:@selector(CYPromptCoverViewDidClickedDismissBtn:)]) {
            [self.delegate CYPromptCoverViewDidClickedDismissBtn:self];
        }
    }
}

#pragma mark - Image Tool

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage *)imageFromView:(UIView *)view andOpaque:(BOOL) opaque
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)blurredImageWithImage:(UIImage *)image radius:(CGFloat)radius iterations:(NSUInteger)iterations  tintColor:(UIColor *)tintColor
{
    //为radius参数设定对外取值范围
    if (radius < 0 || radius > 1) {
        radius = 0.5;
    }
    radius = radius * 20;
    
    
    //image must be nonzero size
    NSAssert(image.size.width > 0 && image.size.height > 0, @"size error");
    
    //boxsize must be an odd integer
    uint32_t boxSize = radius * image.scale;
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = image.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    CFIndex bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc(vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                         NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    free(buffer2.data);
    free(tempBuffer);
    
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, tintColor.CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return newImage;
}

@end
