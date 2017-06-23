//
//  dispatch_HeartBeat.m
//  NULL
//
//  Created by nil on 23/6/2017.
//  Copyright © 2017 github.com/foolsparadise All rights reserved.
//

#import "dispatch_HeartBeat.h"

#ifndef __OPTIMIZE__
#define NSLog(FORMAT,...)   NSLog(@"%@:%d:%@",[[[NSString stringWithFormat:@"%s",__FILE__] componentsSeparatedByString:@"/"] lastObject], __LINE__,[NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#else
#define NSLog(...) {}
#endif

//hello -> (OK,next) -> login -> (OK,next) -> heartbeat per 10 seconds
//__HeartBeatSecond : 10 seconds
#define  __HeartBeatSecond  10.0 //__HeartBeatSecond 为10秒心跳一次

@implementation dispatch_HeartBeat

static dispatch_HeartBeat *_instance = nil;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance;
}

- (void)openHeartBeat
{
    NSLog(@"openHeartBeat");
    
    // hello
    dispatch_semaphore_t semaphore_0_hello = dispatch_semaphore_create(0);
    dispatch_queue_t queue_0_hello  = dispatch_queue_create("semaphore_0_hello", NULL);
    dispatch_async(queue_0_hello , ^(void) {
        
        NSString *str = [NSString stringWithFormat:@"https://example.com/tips_heartbeat?cmd=hello"];
        NSURL *url = [NSURL URLWithString:str];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        [[session dataTaskWithURL:url
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
          {
              if (error) {
                  NSLog(@"0 (%@)", error.description); return ;
              }
              else { // do something like check
                  NSLog(@"0 (%@)", [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
              }
              dispatch_semaphore_signal(semaphore_0_hello);
              
          }] resume];
        
        
    });
    dispatch_semaphore_wait(semaphore_0_hello,DISPATCH_TIME_FOREVER);
    
    // login
    dispatch_semaphore_t semaphore_1_login = dispatch_semaphore_create(0);
    dispatch_queue_t queue_1_login  = dispatch_queue_create("semaphore_1_login", NULL);
    dispatch_async(queue_1_login , ^(void) {
        
        NSString *str = [NSString stringWithFormat:@"https://example.com/tips_heartbeat?cmd=login"];
        NSURL *url = [NSURL URLWithString:str];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        [[session dataTaskWithURL:url
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
          {
              if (error) {
                  NSLog(@"1 (%@)", error.description); return ;
              }
              else { // do something like check
                  NSLog(@"1 (%@)", [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
              }
              dispatch_semaphore_signal(semaphore_1_login);
              
          }] resume];

        
    });
    dispatch_semaphore_wait(semaphore_1_login,DISPATCH_TIME_FOREVER);
    
    // heartbeat
    __weak typeof(self)weakSelf = self;
    self.heartbeatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _timerQueue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(__HeartBeatSecond * NSEC_PER_SEC); // __HeartBeatSecond 为10秒心跳一次
    dispatch_source_set_timer(self.heartbeatTimer, start, interval, 0);
    // 设置回调
    dispatch_source_set_event_handler(self.heartbeatTimer, ^{
        [weakSelf sendHeartBeat];
    });
    // 启动定时器
    dispatch_resume(self.heartbeatTimer);

    return;
}

-(void)sendHeartBeat
{
    // __HeartBeatSecond 为10秒心跳一次
    dispatch_semaphore_t semaphore_2_heartbeat = dispatch_semaphore_create(0);
    dispatch_queue_t queue_2_heartbeat  = dispatch_queue_create("semaphore_2_heartbeat", NULL);
    dispatch_async(queue_2_heartbeat , ^(void) {
        
        NSString *str = [NSString stringWithFormat:@"https://example.com/tips_heartbeat?cmd=heartbeat"];
        NSURL *url = [NSURL URLWithString:str];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        [[session dataTaskWithURL:url
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
          {
              if (error) {
                  NSLog(@"2 (%@)", error.description); return ;
              }
              else { // do something like check
                  NSLog(@"2 (%@)", [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
              }
              dispatch_semaphore_signal(semaphore_2_heartbeat);
              
          }] resume];
        
    });
    dispatch_semaphore_wait(semaphore_2_heartbeat,DISPATCH_TIME_FOREVER);
}

- (void)closeHeartBeat
{
    NSLog(@"closeHeartBeat");
    dispatch_source_cancel(self.heartbeatTimer);
    self.heartbeatTimer = nil;
    return;
}


@end
