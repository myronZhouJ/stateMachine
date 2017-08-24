//
//  ViewController.m
//  StateMachine
//
//  Created by Myron on 8/24/17.
//  Copyright © 2017 Pikicast. All rights reserved.
//

#import "ViewController.h"
#import "TransitionKit.h"

#define WeakObject(o) autoreleasepool{} __weak typeof(o) o##Weak = o; __weak typeof(o) weak##o = o;
#define WeakSelf autoreleasepool{} __weak typeof(self) selfWeak = self; __weak typeof(self) weakSelf = self;

@interface ViewController ()
@property (nonatomic, strong) TKStateMachine *stateMachine;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.stateMachine = [TKStateMachine new];
    TKState *state1 = [TKState stateWithName:@"state1"];

    @WeakObject(state1);
    @WeakSelf;
    
    [state1 setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        NSLog(@"Enter-state1");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.stateMachine fireEvent:@"state1_state2" userInfo:nil error:nil];
        });
    }];
    
    [state1 setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        NSLog(@"Exit-state1");
    }];
    
    TKState *state2 = [TKState stateWithName:@"state2"];
    [state2 setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        NSLog(@"Enter-state2");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.stateMachine fireEvent:@"state2_state3" userInfo:nil error:nil];
        });
    }];
    
    [state2 setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        NSLog(@"Exit-state2");
    }];
    
    TKState *state3 = [TKState stateWithName:@"state3"];
    [state3 setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        NSLog(@"Enter-state3");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.stateMachine fireEvent:@"state3_state1" userInfo:nil error:nil];
        });
    }];
    
    [state3 setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        NSLog(@"Exit-state3");
    }];
    
    [self.stateMachine addStates:@[state1, state2, state3]];
    
    TKEvent *state1_state2 = [TKEvent eventWithName:@"state1_state2" transitioningFromStates:@[state1] toState:state2];
    TKEvent *state2_state3 = [TKEvent eventWithName:@"state2_state3" transitioningFromStates:@[state2] toState:state3];
    TKEvent *state3_state1 = [TKEvent eventWithName:@"state3_state1" transitioningFromStates:@[state3] toState:state1];
    
    [self.stateMachine addEvents:@[state1_state2,state2_state3,state3_state1]];
    
    self.stateMachine.initialState = state1;
    [self.stateMachine activate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
