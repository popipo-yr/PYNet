
---
#PYNetKit
-------------

> PYNetKit是一个网络层的封装(我不生产水,我只是大自然的搬运工),便于项目切换其他网络库,提供插件机制快速处理新任务等.其他目录中提供了AFNetWorking的实现,和一部分自用插件(一部分其他原因进行了屏蔽)



###特性
- 方便切换网络层,只需要特供一个根据网络库实现***PYNetClientImpPro***协议的类进行替换就行
- 提供插件模式方便处理输入输出,方便添加功能测试

###目录说明
> ***PYNetKit***　 　基础目录,使用其他库和自定义插件用它就够了  
> ***PYNetImp*** 　 目录中文件是AFNetWorking库的实现提供给PYNet使用          
> ***PYNetPlugin*** 一部分自用功能插件

###使用方法

```
 //使用AF库
 PYNetClientImp_AF *af = [[PYNetClientImp_AF alloc] initWithBaseURL:...];
 //创建client       
 PYNetClient *client = [[PYNetClient alloc] initWithRealImp:af];

 //添加输入处理和输出处理
 [client addInOpr:...];
 [client addOutOpr:...];

 //服务器数据读取和写入本地文件
 [client addOutOpr:[PYNetCacheDataPlugin new]];
 [client addInOpr:[PYNetReadCacheDataPlugin new]];

 //传输数据
 [client postTo:... parameters:... successBlock:... failureBlock:... netFailBlock:...];
 ```


###注意
插件使用的数据是经过前一个处理后的结果,所以加入的顺序很重要.