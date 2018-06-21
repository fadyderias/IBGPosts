//
//  UIAlertController+ErrorAlerts.m
//  IBGPosts
//
//  Created by Fady on 6/16/18.
//  Copyright © 2018 Instabug. All rights reserved.
//

#import "UIAlertController+ErrorAlerts.h"

@implementation UIAlertController (ErrorAlerts)

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message handler:(void (^)(UIAlertAction *action))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:handler];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    return alertController;
}

@end
