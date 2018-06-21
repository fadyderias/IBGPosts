//
//  UIAlertController+ErrorAlerts.h
//  IBGPosts
//
//  Created by Fady on 6/16/18.
//  Copyright © 2018 Instabug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (ErrorAlerts)

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message handler:(void (^)(UIAlertAction *action))handler;

@end

NS_ASSUME_NONNULL_END
