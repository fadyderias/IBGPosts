//
//  NSString+Networking.m
//  IBGPosts
//
//  Created by Fady on 6/16/18.
//  Copyright © 2018 Instabug. All rights reserved.
//

#import "NSString+Networking.h"

@implementation NSString (Networking)

- (NSURL *)urlForObjectsWithPage:(NSUInteger)page
                           limit:(NSUInteger)limit {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@?_page=%tu&_limit=%tu", self, page, limit];
    return [NSURL URLWithString:urlString];
}

@end
