//
//  ViewController.m
//  NSURLSessionDemo
//
//  Created by MengLong Wu on 16/9/8.
//  Copyright © 2016年 MengLong Wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate,NSURLSessionDataDelegate>
{
    NSMutableData       *_data;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSURLSession 网络连接类
//    1.获取session单例对象
//    2.根据session创建NSURLSessionTask类的对象
//    3.开启会话任务(task) [task resume]
    
//    NSURLSessionTask 抽象类 三个子类
//    NSURLSessionDataTask
//    NSURLSessionUploadTask
//    NSURLSessionDownloadTask
    
//    API application programing interface 应用程序接口
    
//    [self getCase];
    
//    [self postCase];
    
    [self case3];
    
}

#pragma mark -简单get请求
- (void)getCase
{
//    1.获取url
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/LoginServer/login?name=zhiyou&psw=123"];
    
//    2.根据单例方法获取NSURLSession的单例对象
    NSURLSession *session = [NSURLSession sharedSession];
    
//    3.根据session对象创建task
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
//    开启会话任务，所有的会话任务都需要开启才会执行
    [task resume];
    
}

#pragma mark -简单post请求
- (void)postCase
{
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/LoginServer/login"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    参数
    NSString *param = @"name=zhiyou&psw=123";
//    设置请求方法
    request.HTTPMethod = @"POST";
//    设置请求体
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
//    获取session单例对象
    NSURLSession *session = [NSURLSession sharedSession];

//    创建task
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
//    开启task
    [task resume];
    
}
#pragma mark -NSURLSession设置代理
- (void)case3
{
//    创建NSURLSessionConfiguration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    通过下面的方法可以设置session的代理
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/LoginServer/login"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *param = @"name=zhiyou&psw=123";
    
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
//    使用协议方法，就没有必要再使用block
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    
    [task resume];
}
#pragma mark -协议方法
//接收到服务器响应时调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    _data = [[NSMutableData alloc]init];
//    需要加上这样一句话，允许响应服务器，才可以执行下面两个协议方法
    completionHandler(NSURLSessionResponseAllow);
}
//接收到服务器返回数据时调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(nonnull NSData *)data
{
    [_data appendData:data];
}
//完成时调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    NSString *str = [[NSString alloc]initWithData:_data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str);
}

@end
