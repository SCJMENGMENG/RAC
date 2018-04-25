//
//  ModelViewController.m
//  RACTest
//
//  Created by chengjie on 2018/4/12.
//  Copyright © 2018年 chengjie. All rights reserved.
//

#import "ModelViewController.h"

@interface ModelViewController ()

@end

//汇编一直显示设置 Debug -> Debug WorkFlow -> Always Show ..

@implementation ModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self;调用者
//    _cmd;方法编号
    
    //避免循环引用导致内存泄漏 ->打断引用链条
    @weakify(self);//不写导致dealloc不走 循环引用 内存泄漏
    RACSignal *singnal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        @strongify(self);//防止控制器释放后 block才回掉时找不到self
        NSLog(@"%@",self);
        return nil;
    }];
    
    _signal = singnal;
}
- (IBAction)dismissBtnCliack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}



@end
