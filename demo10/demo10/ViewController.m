//
//  ViewController.m
//  demo10
//
//  Created by 孙强 on 2017/7/20.
//  Copyright © 2017年 孙强. All rights reserved.
//

#import "ViewController.h"
#import "NetWorkManager.h"
#import <CommonCrypto/CommonHMAC.h>

#define APPID  20170206000038634

#define APPKEY  @"YoTQUHaDIIsyqNmtbPEj"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fromString;



@property (weak, nonatomic) IBOutlet UILabel *resultString;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}
- (IBAction)trnslateButtonClick:(id)sender {
    
    NSString *fromString = self.fromString.text;
    
    [self TransStr:fromString ToLanguage:@"zh"];
    
}

//百度翻译
-(void)TransStr:(NSString *)str ToLanguage:(NSString *)language
{
    NSString *q = str;//要翻译的内容
    NSString *from = @"auto";//自动检测需要翻译的语言是哪国语言
    NSString *to = language;//要翻译成哪国语言
    int salt = 1435660288;//随便写
    
    NSString *sign = [NSString stringWithFormat:@"%ld%@%d%@",APPID,q,salt,APPKEY];
    
    NSString *md5Sign = [self md5:sign];//MD5加密
    
    NSString *URLQ = [q stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//转化一下
    NSString *url = [NSString stringWithFormat:@"http://api.fanyi.baidu.com/api/trans/vip/translate?q=%@&from=%@&to=%@&appid=20170206000038634&salt=1435660288&sign=%@",URLQ,from,to,md5Sign];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];//AFN网络请求
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSArray *result = dict[@"trans_result"];
        NSDictionary *dd = [result firstObject];
        NSString *str = dd[@"dst"];//翻译结果
        
        NSLog(@"%@",str);
        
        self.resultString.text = str;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//md5 加密
- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
