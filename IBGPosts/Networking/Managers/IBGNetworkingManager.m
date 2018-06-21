//
//  IBGNetworkingManager.m
//  IBGPosts
//
//  Created by Fady on 6/16/18.
//  Copyright © 2018 Instabug. All rights reserved.
//

#import "IBGNetworkingManager.h"
#import "NSString+Networking.h"
#import "Post.h"

@implementation IBGNetworkingManager

+ (instancetype)sharedInstance {
    static IBGNetworkingManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[IBGNetworkingManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)getPostsForPage:(NSUInteger)page WithSuccess:(void (^)(NSArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSString *urlString = @"http://jsonplaceholder.typicode.com/posts";
    NSURL *url = [urlString urlForObjectsWithPage:page limit:10];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession *ibgSession = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionTask *task = [ibgSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            failure(error);
        } else {
            NSError *parseError = nil;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&parseError];
            NSMutableArray *postsArray = [[NSMutableArray alloc] init];
            
            [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
                Post *post = [[Post alloc] init];
                post.title = [obj objectForKey:@"title"];
                post.body = [obj objectForKey:@"body"];
                [postsArray addObject:post];
            }];
            
            NSArray *successPostsArray = [[NSArray alloc] initWithArray:postsArray];
            success(successPostsArray);
        }
    }];
    
    [task resume];
}

@end
