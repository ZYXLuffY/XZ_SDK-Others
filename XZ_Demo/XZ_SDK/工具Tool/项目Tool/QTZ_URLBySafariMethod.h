//
//  QTZ_URLBySafariMethod.h
//  com.tmbj.qtzUser_JE
//
//  Created by iOS_XZ on 16/6/28.
//  Copyright © 2016年 JE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTZ_URLBySafariMethod : NSObject

+ (instancetype)shareManager;

- (NSString*)receiveUrlBySafari:(NSString *)url;

- (void)receiveUrlByJava:(NSString *)url;



@end
