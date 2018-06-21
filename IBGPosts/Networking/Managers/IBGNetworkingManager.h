//
//  IBGNetworkingManager.h
//  IBGPosts
//
//  Created by Fady on 6/16/18.
//  Copyright © 2018 Instabug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBGNetworkingManager : NSObject

+ (instancetype)sharedInstance ;

- (void)getPostsForPage:(NSUInteger)page
                WithSuccess:(void (^) (NSArray *postsArray))success
                    failure:(void (^) (NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
