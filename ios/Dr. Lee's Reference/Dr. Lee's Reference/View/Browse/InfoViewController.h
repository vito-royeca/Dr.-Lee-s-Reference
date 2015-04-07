//
//  InfoViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/8/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController<UIWebViewDelegate>

@property(strong,nonatomic) UIWebView *webView;
@property(strong,nonatomic) NSString *htmlPath;

@end
