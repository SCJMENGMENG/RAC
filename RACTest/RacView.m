//
//  RacView.m
//  RACTest
//
//  Created by chengjie on 2018/4/11.
//  Copyright © 2018年 chengjie. All rights reserved.
//

#import "RacView.h"

@implementation RacView

-(RACSubject *)btnClckSingle
{
    if (!_btnClckSingle) {
        _btnClckSingle = [RACSubject subject];
    }
    return _btnClckSingle;
}

- (IBAction)racBtn:(id)sender {
    
    [self.btnClckSingle sendNext:@"点我了啊"];
    
//    [self send:@{@"name":@"张旭",@"age":@24}];
    [self send:@[@"321",@"123"]];
}

-(void)send:(id)objc{
    
}


@end
