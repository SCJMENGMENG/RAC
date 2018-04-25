//
//  ViewController.m
//  RACTest
//
//  Created by chengjie on 2018/4/11.
//  Copyright © 2018年 chengjie. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import "RacView.h"
#import <NSObject+RACKVOWrapper.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RacView *racView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (assign,nonatomic) int time;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic,strong) RACDisposable * disposable;


@property (weak, nonatomic) IBOutlet UITextField *honhTextField;
@property (weak, nonatomic) IBOutlet UILabel *textFeildLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//RAC宏
-(void)hongRAC{
    
    //    [_honhTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
    //        _textFeildLabel.text = x;
    //    }];
    
    //    RAC(_textFeildLabel,text) = _honhTextField.rac_textSignal;
    
    [RACObserve(self.view, frame) subscribeNext:^(id  _Nullable x) {
        NSLog(@"frame-%@",x);
    }];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.view.frame = CGRectMake(0, 0, 300, 300);
//}

//验证码计时器
- (IBAction)sendBtnClick:(id)sender {
    
    //改变状态
    self.sendBtn.enabled = NO;
    //设置倒计时
    self.time = 10;
    //每一秒钟
    _disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        
        //设置按钮文字
        NSString *btnText = _time > 0?[NSString stringWithFormat:@"%d秒",_time] : @"重新发送";
        [_sendBtn setTitle:btnText forState:(UIControlStateNormal)];
        
        _sendBtn.enabled = _time >0 ? NO : YES;
        
        if (_time >0) {
            _sendBtn.enabled = NO;
        }else{
            _sendBtn.enabled = YES;
            [_disposable dispose];//_time = 0时 终止
        }
        
        //减去时间
        _time --;
    }];
}

-(void)RACTimer{
    //RACTimer
    [[RACSignal interval:1.0 onScheduler: [RACScheduler scheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"%@----%@",[NSThread currentThread],x);
    }];

}

//NSTimer
-(void)threadMethod{
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSTimer * timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeMethod) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        [[NSRunLoop currentRunLoop] run];//死循环
        
        //死循环下面的不走了
        NSLog(@"子线程里");
    }];
    
    [thread start];
}

-(void)timeMethod{
    NSLog(@"timer!!%@",[NSThread currentThread]);
}


// 初识RAC
-(void)kownRAC{
    //创建信号
    RACSubject * subject = [RACSubject subject];
    
    //订阅信号 函数式编程思想
    [subject subscribeNext:^(id  _Nullable x) {
        //回调
        NSLog(@"我收到了:%@",x);
    }];
    //发送信号
    [subject sendNext:@"haha"];
}
//代理
-(void)delegateRAC{
    //1
    [self.racView.btnClckSingle subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到了:%@",x);
    }];
    
    //2 一句话解决
    [[self.racView rac_signalForSelector:@selector(send:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"双击666:%@",x);
        
        RACTupleUnpack(NSString *key,NSString *value) = x;
        //        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:key message:value delegate:self cancelButtonTitle:@"123123" otherButtonTitles:nil, nil];
        //
        //        [aler show];
        
        NSLog(@"key-%@,value-%@",key,value);
    }];
}
//kvo
-(void)kvoRAC{
    [self.racView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
    }];
    [[self.racView rac_valuesForKeyPath:@"frame1" observer:self] subscribeNext:^(id  _Nullable x) {
        
    }];
}
//监听、通知、textfield文本监听
-(void)methodRAC{
    //监听事件
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"btn-%@",x);
    }];
    //    通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"notific-%@",x);
    }];
    
    //    监听文本框输入
    [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"textfiled-%@",x);
    }];

}


@end
