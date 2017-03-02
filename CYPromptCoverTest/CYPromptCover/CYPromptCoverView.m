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
            
        case CYPromptCoverViewCoverTypeblurred:
            self.bgImg = [self.class blurredImageWithImage:[self.class imageFromView:view andOpaque:NO] radius:self.blurRadius iterations:3 tintColor:[UIColor colorWithWhite:0.0f alpha:0.3f]];
            break;
            
        default:
            break;
    }
    

    
    [view addSubview:self];
    [view setNeedsDisplay];
    
    [UIView animateWithDuration:0.1 delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:nil];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - init
- (instancetype)initWithBgColor:(UIColor *)aColor revealView:(UIView *)aView revealType:(CYPromptCoverViewRevealType)aType {
    if (self = [super initWithFrame:[[UIScreen mainScreen]bounds]]) {
        [self commonSetup];
        
        self.coverType = CYPromptCoverViewCoverTypeColored;
        self.revealType = aType;
        self.revealView = aView;
        self.coverColor = aColor;

    }
    return self;
}

- (instancetype)initWithBlurRadius:(CGFloat)aFloat revealView:(UIView *)aView revealType:(CYPromptCoverViewRevealType)aType {
    if (self = [super initWithFrame:[[UIScreen mainScreen]bounds]]) {
        [self commonSetup];
        
        self.coverType = CYPromptCoverViewCoverTypeblurred;
        self.revealType = aType;
        self.revealView = aView;
        self.blurRadius = aFloat;
        
    }
    return self;
}

- (instancetype)initWithRevalView:(UIView *)aView {
    if (self = [super initWithFrame:[[UIScreen mainScreen]bounds]]) {
        [self commonSetup];
        
        self.coverType = CYPromptCoverViewCoverTypeColored;
        self.revealType = CYPromptCoverViewRevealTypeRect;
        self.revealView = aView;
        
    }
    return self;
}

- (void)commonSetup {
    
    self.backgroundColor = [UIColor clearColor];
    _tintColor = [UIColor whiteColor];
    self.coverColor = [UIColor colorWithWhite:0 alpha:0.8];
    self.blurRadius = 0.5;
    self.insetX = -5;
    self.insetY = -5;
    
}

- (void)setupAttachUI {

    if (self.isDesHidden) {
        return;
    }
    
    //arrowImageView
    CGFloat imgViewWH = 30;
    CGFloat imgViewX = self.revealType? CGRectGetMaxX([self ovalRect]):CGRectGetMaxX([self revealRect]) + 10;
    CGFloat imgViewY = self.revealType? CGRectGetMaxX([self ovalRect]):CGRectGetMaxY([self revealRect]) - imgViewWH / 2;
    UIImageView *arrowImgView = [[UIImageView alloc] init];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"CYPromptCover" ofType:@"bundle"];
    NSString *imgPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"arrow.png" ofType:nil];
    arrowImgView.image = [UIImage imageWithContentsOfFile:imgPath];
    arrowImgView.frame = CGRectMake(imgViewX, imgViewY, imgViewWH, imgViewWH);
    arrowImgView.contentMode = UIViewContentModeScaleAspectFit;
    arrowImgView.backgroundColor = [UIColor clearColor];
    [self addSubview:arrowImgView];
    self.arrowImgView = arrowImgView;
    
    //desLabel
    CGFloat desLabelW = 1;
    CGFloat desLabelH = 1;
    CGFloat desLabelX = CGRectGetMaxX(arrowImgView.frame) - imgViewWH / 2;
    CGFloat desLabelY = CGRectGetMaxY(arrowImgView.frame) + 10;
    UILabel *desLabel = [[UILabel alloc]init];
    desLabel.frame = CGRectMake(desLabelX, desLabelY, desLabelW, desLabelH);
    [desLabel setTextColor:_tintColor];
    desLabel.font = [UIFont systemFontOfSize:13];
    desLabel.numberOfLines = 1;
    desLabel.text = self.des;
    [desLabel sizeToFit];
    [self addSubview:desLabel];
    self.desLabel = desLabel;
    
    //subDesLabel
    CGFloat subDesLabelW = 1;
    CGFloat subDesLabelH = 1;
    CGFloat subDesLabelX = CGRectGetMinX(desLabel.frame);
    CGFloat subDesLabelY = CGRectGetMaxY(desLabel.frame) + 10;
    UILabel *subDesLabel = [[UILabel alloc]init];
    subDesLabel.frame = CGRectMake(subDesLabelX, subDesLabelY, subDesLabelW, subDesLabelH);
    [subDesLabel setTextColor:_tintColor];
    subDesLabel.font = [UIFont systemFontOfSize:11];
    subDesLabel.text = self.detailDes;
    subDesLabel.numberOfLines = 1;
    [subDesLabel sizeToFit];
    [self addSubview:subDesLabel];
    self.subDesLabel = subDesLabel;
    
    //dismissBtn
    CGFloat dismissBtnW = 60;
    CGFloat dismissBtnH = 30;
    CGFloat dismissBtnX = CGRectGetMinX(subDesLabel.frame);
    CGFloat dismissBtnY = CGRectGetMaxY(subDesLabel.frame) + 10;
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    dismissBtn.frame = CGRectMake(dismissBtnX, dismissBtnY, dismissBtnW, dismissBtnH);
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
    CGFloat neverBtnW = 60;
    CGFloat neverBtnH = 20;
    CGFloat neverBtnX = (self.bounds.size.width - neverBtnW) / 2;
    CGFloat neverBtnY = self.bounds.size.height - neverBtnH - 44;
    UIButton *neverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    neverBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    neverBtn.frame = CGRectMake(neverBtnX, neverBtnY, neverBtnW, neverBtnH);
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

#pragma mark - set
- (void)setRevealView:(UIView *)revealView {
    _revealView = revealView;
    _revealFrame = [self revealRect];

}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    
    if (!(self.bgImg && self.revealView)) {
        return;
    }
    if (!self.neverBtn) {
        [self setupAttachUI];
    }
    [self.bgImg drawInRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeClear);
    
    UIBezierPath* path = nil;

    switch (self.revealType) {
        case CYPromptCoverViewRevealTypeRect:
            path = [UIBezierPath bezierPathWithRoundedRect:[self revealRect] cornerRadius:4];
            break;
        case CYPromptCoverViewRevealTypeOval:{
            CGRect round = [self ovalRect];
            path = [UIBezierPath bezierPathWithOvalInRect:round];
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
