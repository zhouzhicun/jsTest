//
//  ViewController.m
//  TestJSApp
//
//  Created by fdd_zzc on 15/10/27.
//  Copyright © 2015年 fdd. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface ViewController ()<UIWebViewDelegate>

@property(nonatomic, strong)JSContext *jsContext;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.myWebView.delegate = self;
    NSString *myBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *htmlPath = [NSString stringWithFormat:@"%@/test.html", myBundlePath];
    NSURL *baseUrl = [NSURL fileURLWithPath:myBundlePath isDirectory:YES];  //必须调用该语句
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.myWebView loadHTMLString:html baseURL:baseUrl];
    

}



#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
   
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
    
    self.jsContext[@"callTestMethod"] = ^() {
        
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
        NSLog(@"-------End Log-------");
        
    };
    
    
    self.jsContext[@"callTestMethodWithParams"] = ^(NSString *name, NSInteger age) {
        
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
        NSLog(@"-------End Log-------");
        
    };
    
    
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var num = 5 + 5"];
    [context evaluateScript:@"var names = ['Grace', 'Ada', 'Margaret']"];
    [context evaluateScript:@"var triple = function(value) { return value * 3 }"];
    JSValue *tripleNum = [context evaluateScript:@"triple(num)"];
    
    NSLog(@"num = %ld", [[tripleNum toNumber] integerValue]);
  
    //修改名字
    //NSString *js_result = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('aaa')[0].onclick=window.location.href='ios://abc/123'"];
    //NSString *js_result = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('aaa')[0].onclick='callTestMethod();'"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   
    
    NSLog(@"url = %@", [request.URL description]);
    
    // 说明协议头是ios
    if ([@"ios" isEqualToString:request.URL.scheme]) {
        NSString *url = request.URL.absoluteString;
        NSRange range = [url rangeOfString:@":"];
        NSString *method = [request.URL.absoluteString substringFromIndex:range.location + 1];
        
        SEL selector = NSSelectorFromString(method);
        
//        if ([self respondsToSelector:selector]) {
//            [self performSelector:selector];
//        }

        return NO;
    }
    
    return YES;
}





@end
