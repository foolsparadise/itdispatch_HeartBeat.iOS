//
//  dispatch_HeartBeat.h
//  NULL
//
//  Created by nil on 23/6/2017.
//  Copyright © 2017 github.com/foolsparadise All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 
 hello -> (OK,next) -> login -> (OK,next) -> heartbeat per 10 seconds
 __HeartBeatSecond : 10 seconds
 
 useage:
 
 [[dispatch_HeartBeat shareInstance] openHeartBeat];
 or
 [[dispatch_HeartBeat shareInstance] closeHeartBeat];
 
 */

@interface dispatch_HeartBeat : NSObject

@property (nonatomic, strong) dispatch_source_t heartbeatTimer;
@property(nonatomic)dispatch_queue_t timerQueue;

+ (instancetype)shareInstance;

- (void)openHeartBeat;
- (void)closeHeartBeat;

@end
