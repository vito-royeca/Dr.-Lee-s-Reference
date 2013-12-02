//
//  FileDownloader.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/29/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FUNCTION_NAME   NSLog(@"%s",__FUNCTION__)

@protocol FileDownloaderDelegate <NSObject>

@optional
- (void)downloadProgres:(NSNumber*)percent forObject:(id)object;

@required
- (void)downloadingStarted;
- (void)downloadingFinishedFor:(NSURL *)url
                       andData:(NSData *)data
                    destFolder:(NSString*)folder
                      destFile:(NSString*)file;
- (void)downloadingFailed:(NSURL *)url;

@end

@interface FileDownloader : NSObject<NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSMutableData *downloadedData;
@property (nonatomic, strong) NSURL *fileUrl;
@property (nonatomic, strong) NSString *destFolder;
@property (nonatomic, strong) NSString *destFile;

@property (nonatomic, strong) id <FileDownloaderDelegate> delegate;

- (void)downloadFromURL:(NSString *)urlString
             destFolder:(NSString*)folder
               destFile:(NSString*)file;

@end