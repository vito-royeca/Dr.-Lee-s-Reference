//
//  ICD10CMDetailViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/9/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICD10Diagnosis.h"

@interface ICD10CMDetailViewController : UIViewController<UIWebViewDelegate>

@property(strong,nonatomic) ICD10Diagnosis *diagnosis;
@property(strong, nonatomic) UIWebView *webView;

-(id) initWithDiagnosis:(ICD10Diagnosis*) diagnosis;

@end
