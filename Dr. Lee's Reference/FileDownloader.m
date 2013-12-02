//
//  FileDownloader.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/29/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "FileDownloader.h"

@implementation FileDownloader
{
    double totalFileSize;
}

@synthesize request;
@synthesize downloadedData;
@synthesize fileUrl;
@synthesize destFolder;
@synthesize destFile;
@synthesize delegate;

- (void)downloadFromURL:(NSString *)urlString
             destFolder:(NSString*)folder
               destFile:(NSString*)file
{
    fileUrl = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    request = [NSMutableURLRequest requestWithURL:fileUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    destFolder = folder;
    destFile = file;
    
    NSURLConnection *cn = [[NSURLConnection alloc ] initWithRequest:request delegate:self];
    [cn start];
}


#pragma mark - NSURLConnection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if([delegate respondsToSelector:@selector(downloadingStarted)])
    {
        [delegate performSelector:@selector(downloadingStarted)];
    }
    
    totalFileSize = [response expectedContentLength];
    downloadedData = [NSMutableData dataWithCapacity:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [downloadedData appendData:data];
    
    if([delegate respondsToSelector:@selector(downloadProgres:forObject:)])
    {
        [delegate performSelector:@selector(downloadProgres:forObject:)
                       withObject:[NSNumber numberWithFloat:([downloadedData length]/totalFileSize)]
                       withObject:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([delegate respondsToSelector:@selector(downloadingFailed:)])
    {
        [delegate performSelector:@selector(downloadingFailed:)
                       withObject:self.fileUrl];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([delegate respondsToSelector:@selector(downloadingFinishedFor:andData:destFolder:destFile:)])
    {
        [delegate downloadingFinishedFor:fileUrl
                                 andData:downloadedData
                              destFolder:destFolder
                                destFile:destFile];
    }
}

@end
