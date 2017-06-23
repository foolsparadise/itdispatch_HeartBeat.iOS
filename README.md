## dispatch_HeartBeat  

HeartBeat or Ping Demo for KeepAlive  
心跳包或Ping的发送,每10秒发1次,流程如下  
hello -> (OK,next) -> login -> (OK,next) -> heartbeat per 10 seconds  
__HeartBeatSecond : 10 seconds  

useage:  
```  
[[dispatch_HeartBeat shareInstance] openHeartBeat];  
```  
or  
```  
[[dispatch_HeartBeat shareInstance] closeHeartBeat];  
```  

when   
```  
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];   
- (void)applicationWillEnterForeground  
{  
  [[dispatch_HeartBeat shareInstance] openHeartBeat];  
}  
```  
and  
```  
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];  
- (void)applicationDidEnterBackground  
{  
  [[dispatch_HeartBeat shareInstance] closeHeartBeat];
}  
```  

## MIT  
