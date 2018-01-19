//
//  ZHCMessagesInputToolbar.m
//  ZHChat
//
//  Created by aimoke on 16/8/19.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCMessagesInputToolbar.h"
#import "ZHCMessagesComposerTextView.h"
#import "ZHCMessagesToolbarButtonFactory.h"
#import "UIColor+ZHCMessages.h"
#import "UIImage+ZHCMessages.h"
#import "UIView+ZHCMessages.h"
#import "NSBundle+ZHCMessages.h"



static void * kZHCMessagesInputToolbarKeyValueObservingContext = &kZHCMessagesInputToolbarKeyValueObservingContext;


@interface ZHCMessagesInputToolbar ()
@property (assign, nonatomic) BOOL zhc_isObserving;
@property (strong, nonatomic) ZHCMessagesVoiceRecorder *recorder;
@property (strong, nonatomic) UIImageView *progressBarImageView;
@property (strong, nonatomic) NSTimer *timer;
@end

CGFloat duration;
@implementation ZHCMessagesInputToolbar
@dynamic delegate;

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.zhc_isObserving = NO;
    self.sendButtonOnRight = YES;
    self.preferredDefaultHeight = 44.0f;
    self.maximumHeight = NSNotFound;
    
    self.recorder = [[ZHCMessagesVoiceRecorder alloc]init];
    self.recorder.delegate = self;
    
    ZHCMessagesToolbarContentView *toolbarContentView = [self loadToolbarContentView];
    toolbarContentView.frame = self.frame;
    [self addSubview:toolbarContentView];
    
    [self zhc_pinAllEdgesOfSubview:toolbarContentView];
    [self setNeedsUpdateConstraints];
    _contentView = toolbarContentView;
    self.contentView.progressView.hidden = YES;
    self.contentView.swipeToCancelLabel.hidden = YES;
    self.contentView.textView.hidden = NO;
    duration = 0.00;
    [self zhc_addObservers];
    
    ZHCMessagesToolbarButtonFactory *toolbarButtonFactory = [[ZHCMessagesToolbarButtonFactory alloc] initWithFont:[UIFont boldSystemFontOfSize:17.0]];
    self.contentView.leftBarButtonItem = [toolbarButtonFactory defaultInputViewBarLeftButtonItem];
    self.contentView.rightBarButtonItem = [toolbarButtonFactory defaultInputViewBarRightButtonItem];
 //   self.contentView.middleBarButtonItem = [toolbarButtonFactory defaultInputViewBarMiddelButtonItem];
    self.contentView.middleLeftBarButtonItem = [toolbarButtonFactory defaultInputViewBarMiddleLeftButtonItem];//  defaultInputViewVoiceLongPressButtonItem
//    self.contentView.longPressButton = [toolbarButtonFactory defaultInputViewVoiceLongPressButtonItem];
    self.contentView.longPressButton.hidden = YES;

    [self.contentView.middleLeftBarButtonItem addTarget:self action:@selector(zhc_startRecordVoice:) forControlEvents:UIControlEventTouchDown];

     [self.contentView.middleLeftBarButtonItem addTarget:self action:@selector(zhc_cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.middleLeftBarButtonItem addTarget:self action:@selector(zhc_confirmRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.middleLeftBarButtonItem addTarget:self action:@selector(zhc_updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
    [self.contentView.middleLeftBarButtonItem addTarget:self action:@selector(zhc_updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
    
    [self toggleSendButtonEnabled];
   

}

- (ZHCMessagesToolbarContentView *)loadToolbarContentView
{
    NSArray *nibViews = [[NSBundle bundleForClass:[ZHCMessagesInputToolbar class]] loadNibNamed:NSStringFromClass([ZHCMessagesToolbarContentView class])
                                                                                          owner:nil
                                                                                        options:nil];
    return nibViews.firstObject;
}


-(UIImageView *)progressBarImageView{
    
    return [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, self.contentView.progressView.frame.size.height)];
    
}
- (void)dealloc
{
    [self zhc_removeObservers];
    self.recorder.delegate = nil;
}

- (NSTimer *)timer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(timerAction)
                                            userInfo:nil
                                             repeats:YES];
    return _timer;
}

-(void)timerAction {
    duration += 0.01;
    _contentView.recordingTimeLabel.text = [NSString stringWithFormat:@"%0.2f",duration];
    if (duration == 0.10) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Setters

- (void)setPreferredDefaultHeight:(CGFloat)preferredDefaultHeight
{
    NSParameterAssert(preferredDefaultHeight > 0.0f);
    _preferredDefaultHeight = preferredDefaultHeight;
}



#pragma mark - Actions

/**
 * Start Record Voice.
 */
-(void)zhc_startRecordVoice:(UIButton *)sender
{
    // First request for audio permission
    __weak typeof(self)weakSelf = self;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        
        if(!granted) {
            [weakSelf.delegate messagesInputToolbar:self status:[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]];
        }else {
            [weakSelf startRecording:sender];
        }
        
    }];
}

-(void)startRecording:(UIButton *)sender {
    
    sender.highlighted = YES;
    //  [ZHCMessagesAudioProgressHUD zhc_show];
    duration = 0;
    [_recorder zhc_startRecording];
    
    [[NSRunLoop mainRunLoop] addTimer:[self timer] forMode:NSRunLoopCommonModes];
    
    self.contentView.progressView.hidden = NO;
    self.contentView.swipeToCancelLabel.hidden = NO;
    self.contentView.textView.hidden = YES;
    self.contentView.recordingTimeLabel.text = [NSString stringWithFormat:@"%0.2f",duration];
    _progressBarImageView = [self progressBarImageView];
    [_progressBarImageView setBackgroundColor:[UIColor colorWithRed:(103.0/255.0) green:(197.0/255.0) blue:(95.0/255.0) alpha:1.0]];
    [_progressBarImageView setClipsToBounds:YES];
    [self.contentView.progressView addSubview:_progressBarImageView];
    [self.contentView.progressView bringSubviewToFront:self.contentView.swipeToCancelLabel];
    [self.contentView.progressView bringSubviewToFront:self.contentView.recordingTimeLabel];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:10.0 animations:^{
        [_progressBarImageView setFrame:weakSelf.contentView.progressView.bounds];
    } completion:^(BOOL finished) {
        [UIView transitionWithView:weakSelf.contentView.progressView
                          duration:0.25f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                        } completion:^(BOOL finished) {
                            [_progressBarImageView removeFromSuperview];
                            weakSelf.contentView.progressView.hidden = YES;
                            weakSelf.contentView.textView.hidden = NO;
                        }];
    }];
}

/**
 * Cancel Record Voice.
 */
-(void)zhc_cancelRecordVoice:(UIButton *)sender
{
    sender.highlighted = NO;
  //  [ZHCMessagesAudioProgressHUD zhc_dismissWithMessage:[NSBundle zhc_localizedStringForKey:@"Cancel_Recording"]];
    [_progressBarImageView removeFromSuperview];
    self.contentView.progressView.hidden = YES;
    self.contentView.textView.hidden = NO;
    [_recorder zhc_cancelRecord];
}

/**
 * Finish Record Voice.
 */
-(void)zhc_confirmRecordVoice:(UIButton *)sender
{
     sender.highlighted = NO;
    [_recorder zhc_stopRecording];
    [_progressBarImageView removeFromSuperview];
    self.contentView.progressView.hidden = YES;
    self.contentView.textView.hidden = NO;
}

/**
 * Update Voice HUD Status.
 */
-(void)zhc_updateCancelRecordVoice
{
    [ZHCMessagesAudioProgressHUD zhc_changeSubTitle:[NSBundle zhc_localizedStringForKey:@"Release_Cancel_Recording"]];
    [_progressBarImageView removeFromSuperview];
    self.contentView.progressView.hidden = YES;
    self.contentView.textView.hidden = NO;
}

/**
 * Update Voice HUD Status.
 */
-(void)zhc_updateContinueRecordVoice
{
    [ZHCMessagesAudioProgressHUD zhc_changeSubTitle:[NSBundle zhc_localizedStringForKey:@"Slipe_Up_CancelRecording"]];
}

- (void)zhc_leftBarButtonPressed:(UIButton *)sender
{
    
    self.contentView.rightBarButtonItem.selected = NO;
    self.contentView.middleBarButtonItem.selected = NO;
    sender.selected = !sender.selected;
    [self.delegate messagesInputToolbar:self didPressLeftBarButton:sender];
    if (sender.selected) {
        [self.contentView.textView resignFirstResponder];
        
    }else{
        [self.contentView.textView becomeFirstResponder];
    }

}

- (void)zhc_rightBarButtonPressed:(UIButton *)sender
{
    self.contentView.leftBarButtonItem.selected = NO;
    self.contentView.middleBarButtonItem.selected = NO;
    self.contentView.longPressButton.hidden = YES;
    self.contentView.textView.hidden = NO;
    sender.selected = !sender.selected;
    [self.delegate messagesInputToolbar:self didPressRightBarButton:sender];
    if (sender.selected) {
        [self.contentView.textView resignFirstResponder];
    }else{
        [self.contentView.textView becomeFirstResponder];
    }
    
}

-(void)zhc_middelBarButtonPressed:(UIButton *)sender
{
    self.contentView.leftBarButtonItem.selected = NO;
    self.contentView.rightBarButtonItem.selected = NO;
    self.contentView.longPressButton.hidden = YES;
    self.contentView.textView.hidden = NO;
    sender.selected = !sender.selected;
    [self.delegate messagesInputToolbar:self didPressMiddelBarButton:sender];
    if (sender.selected) {
        [self.contentView.textView resignFirstResponder];
    }else{
        [self.contentView.textView becomeFirstResponder];
    }
    
}

-(void)zhc_middleLeftBarButtonPressed:(UIButton *)sender
{
    self.contentView.leftBarButtonItem.selected = NO;
    self.contentView.rightBarButtonItem.selected = NO;
    self.contentView.longPressButton.hidden = YES;
    self.contentView.textView.hidden = NO;
    sender.selected = !sender.selected;
    [self.delegate messagesInputToolbar:self didPressMiddleLeftBarButton:sender];
    if (sender.selected) {
        [self.contentView.textView resignFirstResponder];
    }else{
        [self.contentView.textView becomeFirstResponder];
    }
    
}

#pragma mark - ZHCMessagesVoiceDelegate
- (void)zhc_voiceRecorded:(NSString *)recordPath length:(float)recordLength
{
    if (recordPath) {
        [ZHCMessagesAudioProgressHUD zhc_dismissWithProgressState:ZHCAudioProgressSuccess];
        [self sendVoiceMessage:recordPath seconds:recordLength];
    }else{
        [ZHCMessagesAudioProgressHUD zhc_dismissWithProgressState:ZHCAudioProgressError];
    }
}

- (void)zhc_failRecord
{
    [ZHCMessagesAudioProgressHUD zhc_dismissWithProgressState:ZHCAudioProgressError];
}

#pragma mark - Private Methods
-(void)sendVoiceMessage:(NSString *)voiceFileName seconds:(NSTimeInterval)seconds
{
    if ((seconds > 0) && self.delegate && [self.delegate respondsToSelector:@selector(messagesInputToolbar:sendVoice:seconds:)]) {
        [self.delegate messagesInputToolbar:self sendVoice:voiceFileName seconds:seconds];
    }

}


#pragma mark - Input toolbar

- (void)toggleSendButtonEnabled
{
    BOOL hasText = [self.contentView.textView hasText];
    if (hasText) {
        self.contentView.textView.enablesReturnKeyAutomatically = NO;
    }else{
        self.contentView.textView.enablesReturnKeyAutomatically = YES;
    }
    
}


#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kZHCMessagesInputToolbarKeyValueObservingContext) {
        if (object == self.contentView) {
            
            if ([keyPath isEqualToString:NSStringFromSelector(@selector(leftBarButtonItem))]) {
                
                [self.contentView.leftBarButtonItem removeTarget:self
                                                          action:NULL
                                                forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView.leftBarButtonItem addTarget:self
                                                       action:@selector(zhc_leftBarButtonPressed:)
                                             forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([keyPath isEqualToString:NSStringFromSelector(@selector(rightBarButtonItem))]) {
                
                [self.contentView.rightBarButtonItem removeTarget:self
                                                           action:NULL
                                                 forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView.rightBarButtonItem addTarget:self
                                                        action:@selector(zhc_rightBarButtonPressed:)
                                              forControlEvents:UIControlEventTouchUpInside];
            }else if ([keyPath isEqualToString:NSStringFromSelector(@selector(middleBarButtonItem))]){
                [self.contentView.middleBarButtonItem removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                [self.contentView.middleBarButtonItem addTarget:self action:@selector(zhc_middelBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([keyPath isEqualToString:NSStringFromSelector(@selector(middleLeftBarButtonItem))]){
                [self.contentView.middleLeftBarButtonItem removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                [self.contentView.middleLeftBarButtonItem addTarget:self action:@selector(zhc_middleLeftBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            }

            
            [self toggleSendButtonEnabled];
        }
    }
}

- (void)zhc_addObservers
{
    if (self.zhc_isObserving) {
        return;
    }
    
    [self.contentView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))
                          options:0
                          context:kZHCMessagesInputToolbarKeyValueObservingContext];
    
    [self.contentView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem))
                          options:0
                          context:kZHCMessagesInputToolbarKeyValueObservingContext];
    
    [self.contentView addObserver:self forKeyPath:NSStringFromSelector(@selector(middleBarButtonItem)) options:0 context:kZHCMessagesInputToolbarKeyValueObservingContext];
    
    [self.contentView addObserver:self forKeyPath:NSStringFromSelector(@selector(middleLeftBarButtonItem)) options:0 context:kZHCMessagesInputToolbarKeyValueObservingContext];

    self.zhc_isObserving = YES;
}


- (void)zhc_removeObservers
{
    if (!_zhc_isObserving) {
        return;
    }
    
    @try {
        [_contentView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))
                             context:kZHCMessagesInputToolbarKeyValueObservingContext];
        
        [_contentView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem))
                             context:kZHCMessagesInputToolbarKeyValueObservingContext];
        
        [_contentView removeObserver:self forKeyPath:NSStringFromSelector(@selector(middleBarButtonItem)) context:kZHCMessagesInputToolbarKeyValueObservingContext];
        
        [_contentView removeObserver:self forKeyPath:NSStringFromSelector(@selector(middleLeftBarButtonItem)) context:kZHCMessagesInputToolbarKeyValueObservingContext];

    }
    @catch (NSException *__unused exception) { }
    
    _zhc_isObserving = NO;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
