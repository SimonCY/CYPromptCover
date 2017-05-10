# CYPromptCoverTest

蒙版模式的新手引导提示，可单独使用，也可以创建蒙版队列，连环使用。
------------------------------------------------------
##使用

可以设置蒙版类型为半透明或者模糊，露出区域可以设置为圆角矩形或者椭圆。

![这里写图片描述](https://github.com/SimonCY/CYPromptCoverTest/raw/master/ScreenImg/IMG_5209.PNG) ![这里写图片描述](https://github.com/SimonCY/CYPromptCoverTest/raw/master/ScreenImg/IMG_5207.PNG) ![这里写图片描述](https://github.com/SimonCY/CYPromptCoverTest/raw/master/ScreenImg/IMG_5208.PNG)

1.单个使用

```objc
CYPromptCoverView *cover0 = [[CYPromptCoverView alloc] initWithBgColor:[UIColor colorWithWhite:0 alpha:0.5] revealView:self.aBtn revealType:CYPromptCoverViewRevealTypeOval];
cover0.des = @"000000000000";
cover0.detailDes = @"3s 4s 5s";
[Cover showInView:self.view];
```
    
2.多个提示连环使用
  
```objc
//连环使用时，加到queue中的cover的dismissBtnTitle会被自动设置为“下一步”，最后一个cover的dismissBtnTitle设置为“完成”。
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
```
    
3.相关回调
CYPrompCoverView和CYPrompCoverViewQueue都提供了事件回调，设置代理即可使用。
    
```objc
#pragma mark - coverDelegate
- (void)CYPromptCoverViewDidClickedDismissBtn:(CYPromptCoverView *)coverView {
}

- (void)CYPromptCoverViewDidClickedNeverBtn:(CYPromptCoverView *)coverView {
}
    
#pragma mark - queueDelegate
- (void)CYPromptCoverViewQueue:(CYPromptCoverViewQueue *)queue didDismissCoverAtIndex:(NSUInteger)index {
    NSLog(@"index is %ld",index);
}
  
- (void)CYPromptCoverViewQueueDidDismissAllCovers:(CYPromptCoverViewQueue *)queue {
}

- (void)CYPromptCoverViewQueue:(CYPromptCoverViewQueue *)queue didClickedNeverBtnInCoverView:(CYPromptCoverView *)coverView {
}
```

## License

The MIT License (MIT)

Copyright (c) 2013 Nils Mattisson, Martin Hartl

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
