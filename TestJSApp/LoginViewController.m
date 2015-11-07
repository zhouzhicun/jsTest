//
//  LoginViewController.m
//  TestJSApp
//
//  Created by fdd_zzc on 15/10/27.
//  Copyright © 2015年 fdd. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UIWebViewDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.myWebView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.w3school.com.cn/html/index.asp"]];
    [self.myWebView loadRequest:request];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBack:(id)sender
{
    
    if (self.myWebView.canGoBack) {
        
        [self.myWebView goBack];
    } else {
        NSLog(@"can't back");
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"title = %@", title);
}

@end
