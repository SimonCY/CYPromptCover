![这里写图片描述](https://github.com/SimonCY/CYPromptCoverTest/raw/master/Img/logo.PNG)

蒙版模式的新手引导提示，可单独使用，也可以创建蒙版队列，连环使用。
------------------------------------------------------
## Usage

### 可以设置蒙版类型为半透明或者模糊，露出区域可以设置为圆角矩形或者椭圆。

![这里写图片描述](https://github.com/SimonCY/CYPromptCoverTest/raw/master/Img/IMG_7212.PNG) ![这里写图片描述](https://github.com/SimonCY/CYPromptCoverTest/raw/master/Img/IMG_7213.PNG) ![这里写图片描述](https://github.com/SimonCY/CYPromptCoverTest/raw/master/Img/IMG_7214.PNG)

### 可以设置提示出现在不同的位置。

![这里写图片描述](https://github.com/SimonCY/CYPromptCoverTest/raw/master/Img/IMG_7209.PNG) ![这里写图片描述](https://github.com/SimonCY/CYPromptCoverTest/raw/master/Img/IMG_7210.PNG) ![这里写图片描述](https://github.com/SimonCY/CYPromptCoverTest/raw/master/Img/IMG_7211.PNG)

### 1.单个使用

```objc
CYPromptCoverView *cover = [[CYPromptCoverView alloc] initWithBgColor:[UIColor colorWithWhite:0 alpha:0.5] revealView:self.typeBtn revealType:CYPromptCoverViewRevealTypeOval layoutType:CYPromptCoverViewLayoutTypeRightDown];
cover.des = @"000000000000";
cover.detailDes = @"3s 4s 5s";
cover.delegate = self;
[Cover showInView:self.view];
```
    
### 2.多个提示连环使用
  
```objc
//连环使用时，加到queue中的cover的dismissBtnTitle会被自动设置为“下一步”，最后一个cover的dismissBtnTitle设置为“完成”。
CYPromptCoverViewQueue *queue = [[CYPromptCoverViewQueue alloc] init];
queue.delegate = self;
    
CYPromptCoverView *cover0 = [[CYPromptCoverView alloc] initWithBgColor:[UIColor colorWithWhite:0 alpha:0.5] revealView:self.aBtn revealType:CYPromptCoverViewRevealTypeOval layoutType:CYPromptCoverViewLayoutTypeDown];
cover0.des = @"000000000000";
cover0.detailDes = @"3s 4s 5s";
    
CYPromptCoverView *cover1  =[[CYPromptCoverView alloc] initWithBlurRadius:0.5 revealView:self.aSegement revealType:CYPromptCoverViewRevealTypeRect layoutType:CYPromptCoverViewLayoutTypeDown];
cover1.des = @"111111111";
cover1.detailDes = @"3s 4s 5s";

CYPromptCoverView *cover2 = [[CYPromptCoverView alloc] initWithRevalView:self.aSwitch layoutType:CYPromptCoverViewLayoutTypeDown];
cover2.des = @"22222222222";
cover2.detailDes = @"3s 4s 5s";
    
[queue addPromptCoverView:cover0];
[queue addPromptCoverView:cover1];
[queue addPromptCoverView:cover2];
    
[queue showCoversInView:self.view];
```
    
### 3.相关回调
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
## <a id="Hope"></a>Hope
* If you find bug when used，Hope you can Issues me，Thank you or try to download the latest code of this framework to see the BUG has been fixed or not）
* If you find the function is not enough when used，Hope you can Issues me，I very much to add more useful function to this framework ，Thank you !
* 如果使用过程中发现任何问题，欢迎issue我，我会尽快解决。
* 如果在需求上有任何的意见或者建议，也欢迎issue提出，非常感谢！
## Contact to me
* QQ:397604080  
 
## License

The MIT License (MIT) - see [LICENSE](LICENSE) file.
