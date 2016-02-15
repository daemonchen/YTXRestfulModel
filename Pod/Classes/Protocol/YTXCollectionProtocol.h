//
//  YTXCollectionProtocol.h
//  YTXRestfulModel
//
//  Created by CaoJun on 16/1/25.
//  Copyright © 2016年 Elephants Financial Service. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YTXCollectionProtocol <NSObject>

@required

+ (nonnull instancetype) shared;

@property (nonnull, nonatomic, assign) Class modelClass;
@property (nonnull, nonatomic, strong) NSMutableArray * models;

/** 设置网络请求的地址 */
- (void)setRemoteSyncUrl:(nonnull NSURL *)url;
/** 设置网络请求的地址，通过Block形式，每次访问都会重新执行，以处理shared中URL会变的情况。同时使用URL和URLBlock会优先使用Block */
- (void)setRemoteSyncUrlHookBlock:(nullable NSURL * _Nonnull (^)(void))urlHookBlock;

@end
