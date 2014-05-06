//
//  DictionaryTermViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "Constants.h"
#import "Database.h"
#import "DictionarySynonym.h"
#import "DictionaryTerm.h"
#import "DictionaryXRef.h"

@interface DictionaryDetailViewController : UIViewController<UIWebViewDelegate>

@property(strong, nonatomic) UIWebView *webView;

@property(strong, nonatomic) DictionaryTerm *dictionaryTerm;

@end
