//
//  NSString+Networking.h
//  IBGPosts
//
//  Created by Fady on 6/16/18.
//  Copyright © 2018 Instabug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Networking)

- (NSURL *)urlForObjectsWithPage:(NSUInteger)page
                           limit:(NSUInteger)limit;

@end

NS_ASSUME_NONNULL_END
