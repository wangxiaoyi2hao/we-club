//
//  ProgressIndicator.m
//  Test
//
//  Created by xqj on 13-6-9.
//  Copyright (c) 2013年 syezon. All rights reserved.
//

#import "ProgressIndicator.h"

@implementation ProgressIndicator
{
    UIProgressView *_progressView;
    UILabel *_label;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        [self initView];
        
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [self initView];
    }
    return self;
}

-(void)initView
{
    [self initProgressView];
    [self initLabel];
}

-(void)initProgressView
{
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.frame = CGRectMake(0, 0, self.frame.size.width, 8.0);
    [self addSubview:_progressView];
    [_progressView setHidden:YES];
}

-(void)initLabel
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, _progressView.frame.size.height+5.0, self.frame.size.width, 20.0)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:13.0];
    _label.backgroundColor = [UIColor clearColor];
    [self addSubview:_label];
}

-(void)setProgress:(float)progress
{
    
    [_progressView setProgress:progress];
    if (progress != 1.0 && _totalSize!=-1.0)
    {
        NSLog(@"-------%f",_totalSize);
        [_progressView setHidden:NO];
        [_label setHidden:NO];
        if (_totalSize>1000*1024) {
            _label.text=[NSString stringWithFormat:@"%.2f/%.2f MB",_totalSize*progress/1024,_totalSize/1024];
        }else
        {
            _label.text=[NSString stringWithFormat:@"%.0f/%.0f KB",_totalSize*progress/1024,_totalSize/1024];
        }
//        _label.text = [NSString stringWithFormat:@"%.2f M / %.2f M", _totalSize*progress, _totalSize];
    }
    else
    {
        [_label setHidden:YES];
        //        _label.text = @"download complete";
    }
}

-(void)setProgress:(float)progress animated:(BOOL)animated
{

    [_progressView setProgress:progress animated:animated];
    
    if (progress != 1.0 && _totalSize!=-1.0)
    {
        [_progressView setHidden:NO];
        [_label setHidden:NO];
        if (_totalSize>1000*1024) {
            _label.text=[NSString stringWithFormat:@"%.2f/%.2f MB",_totalSize*progress/1024,_totalSize/1024];
        }else
        {
            _label.text=[NSString stringWithFormat:@"%.0f/%.0f KB",_totalSize*progress/1024,_totalSize/1024];
        }
            
        
//        _label.text = [NSString stringWithFormat:@"%.2f M / %.2f M", _totalSize*progress, _totalSize];
    }
    else
    {
        [_label setHidden:YES];
//        _label.text = @"download complete";
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
