//
//  test_YTXRestfulModelRemote.m
//  YTXRestfulModelRemote
//
//  Created by Chuan on 1/25/16.
//  Copyright © 2016 caojun. All rights reserved.
//

#import "YTXTestCollection.h"

#import <Kiwi/Kiwi.h>
#import <YTXRequest/YTXRequest.h>

SPEC_BEGIN(YTXRestfulModelRemoteSpec)

describe(@"测试YTXRestfulModel", ^{
    context(@"初始化", ^{
        
        it(@"Model不为空", ^{
            YTXTestModel *testModel = [[YTXTestModel alloc] init];
            [[testModel should] beNonNil];
        });
        
        it(@"Collection不为空", ^{
            YTXTestCollection *testCollection = [[YTXTestCollection alloc] init];
            [[testCollection should] beNonNil];
        });
        
    });
    
    context(@"Collection功能", ^{
        
        [YTXRequestConfig sharedYTXRequestConfig].serviceKey = @"localhost";
        it(@"Models初始化长度为0", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            [[@( collection.models.count ) should] equal:@(0)];
        });
        
        it(@"重置Models", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            [collection resetModels:@[[YTXTestModel new]]];
            [[@( collection.models.count ) should] equal:@(1)];
            [collection resetModels:@[[YTXTestModel new], [YTXTestModel new]]];
            [[@( collection.models.count ) should] equal:@(2)];
        });
        
        it(@"添加Models", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            [collection addModels:@[[YTXTestModel new], [YTXTestModel new]]];
            [[@( collection.models.count ) should] equal:@(2)];
        });
        
        it(@"通过index查Model", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            YTXTestModel * front = [YTXTestModel new];
            YTXTestModel * back = [YTXTestModel new];
            YTXTestModel * middle = [YTXTestModel new];
            [collection resetModels:@[front, [YTXTestModel new], middle, back ]];
            [[[collection modelAtIndex:0] should] equal:front];
            [[[collection modelAtIndex:collection.models.count-1] should] equal:back];
            [[[collection modelAtIndex:2] should] equal:middle];
            [[[collection modelAtIndex:collection.models.count] should] beNil];
            [[[collection modelAtIndex:-1] should] beNil];
        });
        it(@"在index之前插入Model", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            YTXTestModel *model1 = [[YTXTestModel alloc] init];
            YTXTestModel *model2 = [[YTXTestModel alloc] init];
            YTXTestModel *model3 = [[YTXTestModel alloc] init];
            [collection insertModel:model1 beforeIndex:0];
            [[[collection modelAtIndex:0] should] equal:model1];
            
            [[@([collection insertModel:model2 beforeIndex:1]) should] equal:@(NO)];
            [[@( collection.models.count ) should] equal:@(1)];
            [[@([collection insertModel:model2 beforeIndex:-1]) should] equal:@(NO)];
            [[@( collection.models.count ) should] equal:@(1)];
            [[@([collection insertModel:model2 beforeIndex:0]) should] equal:@(YES)];
            [[@( collection.models.count ) should] equal:@(2)];
            [[[collection modelAtIndex:0] should] equal:model2];
            [[@([collection insertModel:model3 beforeIndex:1]) should] equal:@(YES)];
            [[@( collection.models.count ) should] equal:@(3)];
            [[[collection modelAtIndex:1] should] equal:model3];
        });

        it(@"向后插入Model", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            YTXTestModel *model1 = [[YTXTestModel alloc] init];
            YTXTestModel *model2 = [[YTXTestModel alloc] init];
            YTXTestModel *model3 = [[YTXTestModel alloc] init];
            [collection insertModel:model1 afterIndex:0];
            [[[collection modelAtIndex:0] should] equal:model1];
            
            [[@([collection insertModel:model2 afterIndex:1]) should] equal:@(NO)];
            [[@( collection.models.count ) should] equal:@(1)];
            [[@([collection insertModel:model2 afterIndex:-1]) should] equal:@(NO)];
            [[@( collection.models.count ) should] equal:@(1)];
            [[@([collection insertModel:model2 afterIndex:0]) should] equal:@(YES)];
            [[@( collection.models.count ) should] equal:@(2)];
            [[[collection modelAtIndex:1] should] equal:model2];
            [[@([collection insertModel:model3 afterIndex:1]) should] equal:@(YES)];
            [[@( collection.models.count ) should] equal:@(3)];
            [[[collection modelAtIndex:2] should] equal:model3];
        });

        
        it(@"在最前面插入Model", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            YTXTestModel *model1 = [[YTXTestModel alloc] init];
            YTXTestModel *model2 = [[YTXTestModel alloc] init];
            [collection insertFrontModel:model1];
            [[[collection modelAtIndex:0] should] equal:model1];
            [collection insertFrontModel:model2];
            [[[collection modelAtIndex:0] should] equal:model2];
            [[@( collection.models.count ) should] equal:@(2)];
        });

        it(@"在最前面插入Models", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            YTXTestModel *model1 = [[YTXTestModel alloc] init];
            YTXTestModel *model2 = [[YTXTestModel alloc] init];
            [collection insertFrontModels:@[model1]];
            [[[collection modelAtIndex:0] should] equal:model1];
            [collection insertFrontModels:@[model2]];
            [[[collection modelAtIndex:0] should] equal:model2];
            [[@( collection.models.count ) should] equal:@(2)];
        });

        it(@"根据NSRange查找返回NSArray", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            YTXTestModel *model1 = [[YTXTestModel alloc] init];
            YTXTestModel *model2 = [[YTXTestModel alloc] init];
            YTXTestModel *model3 = [[YTXTestModel alloc] init];
            YTXTestModel *model4 = [[YTXTestModel alloc] init];
            [collection addModels:@[model1, model2, model3, model4]];
            // 其余超出范围的Range测试采用系统方法，所以只测一下三种情况
            [[@([collection arrayWithRange:NSMakeRange(1, 2)].count ) should] equal:@2];
            [[[[collection arrayWithRange:NSMakeRange(1, 2)] firstObject] should] equal:model2];
            [[[collection arrayWithRange:NSMakeRange(4, 2)] should] beNil];
        });
        
        it(@"根据NSRange查找返回YTXTestCollection", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            YTXTestModel *model1 = [[YTXTestModel alloc] init];
            YTXTestModel *model2 = [[YTXTestModel alloc] init];
            YTXTestModel *model3 = [[YTXTestModel alloc] init];
            YTXTestModel *model4 = [[YTXTestModel alloc] init];
            [collection addModels:@[model1, model2, model3, model4]];
            [[@([collection collectionWithRange:NSMakeRange(1, 2)].models.count ) should] equal:@2];
            [[[[collection collectionWithRange:NSMakeRange(1, 2)].models firstObject] should] equal:model2];
            [[[collection collectionWithRange:NSMakeRange(4, 2)] should] beNil];
        });

        it(@"根据PrimaryKey查找Model", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            YTXTestModel *model1 = [[YTXTestModel alloc] init];
            model1.keyId = @1;
            YTXTestModel *model2 = [[YTXTestModel alloc] init];
            YTXTestModel *model3 = [[YTXTestModel alloc] init];
            model3.keyId = @3;
            YTXTestModel *model4 = [[YTXTestModel alloc] init];
            [collection addModels:@[model1, model2, model3, model4]];
            [[[collection modelWithPrimaryKey:@"1"] should] equal:model1];
            [[[collection modelWithPrimaryKey:@"3"] should] equal:model3];
            [[[collection modelWithPrimaryKey:@"2"] should] beNil];
        });
        
        it(@"根据索引删除Model", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            YTXTestModel *model1 = [[YTXTestModel alloc] init];
            model1.keyId = @1;
            YTXTestModel *model2 = [[YTXTestModel alloc] init];
            YTXTestModel *model3 = [[YTXTestModel alloc] init];
            model3.keyId = @3;
            YTXTestModel *model4 = [[YTXTestModel alloc] init];
            [collection addModels:@[model1, model2, model3, model4]];
            [[@( [collection removeModelAtIndex:0] ) should] equal:@YES];
            [[[collection modelAtIndex:0] should] equal:model2];
            [[@( [collection removeModelAtIndex:4] ) should] equal:@NO];
            [[@( [collection removeModelAtIndex:2] ) should] equal:@YES];
            [[[collection modelAtIndex:1] should] equal:model3];
        });
        
        it(@"根据PrimaryKey删除Model", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            YTXTestModel *model1 = [[YTXTestModel alloc] init];
            model1.keyId = @1;
            YTXTestModel *model2 = [[YTXTestModel alloc] init];
            YTXTestModel *model3 = [[YTXTestModel alloc] init];
            model3.keyId = @3;
            [collection addModels:@[model1, model2, model3]];
            [[@( [collection removeModelWithPrimaryKey:@"1"] ) should] equal:@YES];
            [[[collection modelWithPrimaryKey:@"1"] should] beNil];
            [[@( [collection removeModelWithPrimaryKey:@"12"]) should] equal:@NO];
        });
        
        it(@"根据Model删除Model", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            YTXTestModel *model1 = [[YTXTestModel alloc] init];
            model1.keyId = @1;
            YTXTestModel *model2 = [[YTXTestModel alloc] init];
            YTXTestModel *model3 = [[YTXTestModel alloc] init];
            [collection addModels:@[model1, model2, model3]];
            [[@( [collection removeModelWithModel:model1] ) should] equal:@YES];
            [[@( [collection removeModelWithModel:model1] ) should] equal:@NO];
            [[[collection modelWithPrimaryKey:@"1"] should] beNil];
        });
        
        it(@"删除所有Models", ^{
            YTXTestCollection * collection = [YTXTestCollection new];
            [collection removeAllModels];
            [[@( collection.models.count ) should] equal:@(0)];
        });
        
        xit(@"获取", ^{
            __block id ret;
            [[[YTXTestCollection shared] fetchRemote:@{ @"_limit": @"1"}] subscribeNext:^(id x) {
                ret = x;
            } error:^(NSError *error) {
//                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(ret) shouldEventually] beNonNil];
        });
        
        xit(@"增加", ^{
            __block YTXTestCollection *ret;
            [[[YTXTestCollection shared] fetchRemoteThenAdd:@{@"_start": @"1", @"_limit": @"1"}] subscribeNext:^(id x) {
                ret = x;
            } error:^(NSError *error) {
//                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(@(ret.models.count)) shouldEventually] equal:@(2)];
            [[expectFutureValue(ret.models.lastObject[@"id"]) shouldEventually] equal:@(2)];
        });
        
//        it(@"增加", ^{
//            __block YTXTestCollection *ret;
//            [[[YTXTestCollection shared] fetchRemoteThenInsertFront:@{@"_start": @"1", @"_limit": @"1"}] subscribeNext:^(id x) {
//                ret = x;
//            } error:^(NSError *error) {
//                //                NSLog(@"<ERROR> %@", error);
//            }];
//            [[expectFutureValue(@(ret.models.count)) shouldEventually] equal:@(2)];
//            [[expectFutureValue(ret.models.lastObject[@"id"]) shouldEventually] equal:@(2)];
//        });
        
    });
    
    context(@"Model功能", ^{
        
        [YTXRequestConfig sharedYTXRequestConfig].serviceKey = @"localhost";
        
        __block YTXTestModel *testModel = [[YTXTestModel alloc] init];
        
        it(@"创建-Create-POST", ^{
            testModel.title = @"ytx test hahahaha";
            testModel.body = @"teststeststesettsetsetttsetttest";
            testModel.userId = @1;
            [[testModel saveRemote:nil] subscribeNext:^(YTXTestModel *responseModel) {
//                NSLog(@"<SUCCESS> %@", responseModel);
            } error:^(NSError *error) {
//                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(testModel.keyId) shouldEventually] beNonNil];
        });
        
        it(@"更新-Save-PUT，使用parameters", ^{
            [[testModel saveRemote:@{ @"title": @"更新了" }] subscribeNext:^(YTXTestModel *responseModel) {
//                NSLog(@"<SUCCESS> %@", responseModel);
            } error:^(NSError *error) {
//                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(testModel.title) shouldEventually] equal:@"更新了"];
        });
        
        it(@"更新-Save-PUT，使用更改model更新", ^{
            testModel.title = @"又一次更新了";
            __block NSNumber * result = nil;
            [[testModel saveRemote:nil] subscribeNext:^(YTXTestModel *responseModel) {
                result = @(1);
//                NSLog(@"<SUCCESS> %@", responseModel);
            } error:^(NSError *error) {
//                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(result) shouldEventually] beNonNil];
            [[expectFutureValue(testModel.title) shouldEventually] equal:@"又一次更新了"];
        });
        
        it(@"更新-Save-PUT，混合使用parameters和更改model更新", ^{
            testModel.title = @"Hello World";
            __block NSNumber * result = nil;
            [[testModel saveRemote:@{@"body": @"I Love You"}] subscribeNext:^(YTXTestModel *responseModel) {
                result = @(1);
//                NSLog(@"<SUCCESS> %@", responseModel);
            } error:^(NSError *error) {
//                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(result) shouldEventually] beNonNil];
            [[expectFutureValue(testModel.title) shouldEventually] equal:@"Hello World"];
            [[expectFutureValue(testModel.body) shouldEventually] equal:@"I Love You"];
        });
        
        it(@"responseModel和testModel是否是同一个指针地址", ^{
            __block YTXTestModel * testResponseModel = nil;
            [[testModel saveRemote:@{ @"title": @"同一个" }] subscribeNext:^(YTXTestModel *responseModel) {
                testResponseModel =  responseModel;
//                NSLog(@"<SUCCESS> %@", responseModel);
            } error:^(NSError *error) {
//                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(testResponseModel) shouldEventually] equal:testModel];
        });
        
        it(@"拉取-Fetch-GET", ^{
            __block YTXTestModel * currentTestModel = [[YTXTestModel alloc] init];
            currentTestModel.keyId = testModel.keyId;
            [[currentTestModel fetchRemote:nil] subscribeNext:^(YTXTestModel *responseModel) {
//                NSLog(@"<SUCCESS> %@", responseModel);
            } error:^(NSError *error) {
//                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(currentTestModel.title) shouldEventually] beNonNil];
        });
        
        
        it(@"使用Model属性获取外联model", ^{
            __block YTXTestModel * currentTestModel = [[YTXTestModel alloc] init];
            __block id ret;
            currentTestModel.keyId = @1;
            [[currentTestModel fetchRemoteForeignWithName:@"comments" modelClass:[YTXTestCommentModel class] param:nil] subscribeNext:^(id x) {
                ret = x;
//                NSLog(@"<SUCCESS> %@", x);
            } error:^(NSError *error) {
//                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(ret) shouldEventually] beNonNil];
        });
        
        it(@"使用parameters 使用mantle map后的属性名keyId获取外联model", ^{
            __block YTXTestModel * currentTestModel = [[YTXTestModel alloc] init];
            __block id ret;
            [[currentTestModel fetchRemoteForeignWithName:@"comments" modelClass:[YTXTestCommentModel class] param:@{@"keyId": @1}] subscribeNext:^(id x) {
                ret = x;
                //                NSLog(@"<SUCCESS> %@", x);
            } error:^(NSError *error) {
                //                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(ret) shouldEventually] beNonNil];
        });
        
        it(@"使用parameters 不使用mantle map后的属性而用服务器属性名id获取外联model", ^{
            __block YTXTestModel * currentTestModel = [[YTXTestModel alloc] init];
            __block id ret;
            [[currentTestModel fetchRemoteForeignWithName:@"comments" modelClass:[YTXTestCommentModel class] param:@{@"id": @1}] subscribeNext:^(id x) {
                ret = x;
                //                NSLog(@"<SUCCESS> %@", x);
            } error:^(NSError *error) {
                //                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(ret) shouldEventually] beNonNil];
        });
        
        it(@"删除-Destroy-Delete，回调成功", ^{
            __block NSNumber * result = nil;
            [[testModel destroyRemote:nil] subscribeNext:^(YTXTestModel *responseModel) {
                result = @(1);
//                NSLog(@"<SUCCESS> %@", responseModel);
            } error:^(NSError *error) {
//                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(result) shouldEventually] beNonNil];
        });
        
        it(@"删除-Destroy-Delete，确实删除成功", ^{
            __block YTXTestModel * currentTestModel = [[YTXTestModel alloc] init];

            [[currentTestModel fetchRemote:@{@"keyId": testModel.keyId}] subscribeNext:^(YTXTestModel *responseModel) {
                //                NSLog(@"<SUCCESS> %@", responseModel);
            } error:^(NSError *error) {
                //                NSLog(@"<ERROR> %@", error);
            }];
            [[expectFutureValue(currentTestModel.keyId) shouldEventually] beNil];
        });
    });
});

SPEC_END
