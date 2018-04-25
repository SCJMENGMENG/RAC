//
//  ModelViewController.h
//  RACTest
//
//  Created by chengjie on 2018/4/12.
//  Copyright © 2018年 chengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC.h>

@interface ModelViewController : UIViewController
@property (nonatomic,strong) RACSignal *signal;

@end
