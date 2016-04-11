//
//  YTXRestfulModel+RACSupport.m
//  Pods
//
//  Created by Chuan on 4/11/16.
//
//

#import "YTXRestfulModel+RACSupport.h"

@implementation YTXRestfulModel (RACSupport)

# pragma mark - remote

- (nonnull RACSignal *) fetchRemoteForeignWithName:(nonnull NSString *)name modelClass:(nonnull Class)modelClass param:(nullable NSDictionary *)param;
{
    NSAssert([modelClass isSubclassOfClass: [MTLModel class] ], @"希望传入的class是MTLModel的子类，这样才能使用mantle转换");
    RACSubject * subject = [RACSubject subject];
    [self fetchRemoteForeignWithName:name modelClass:modelClass param:param success:^(id  _Nullable response) {
        [subject sendNext:response];
    } failed:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    return subject;
}

- (nonnull RACSignal *) fetchRemote:(nullable NSDictionary *)param
{
    RACSubject * subject = [RACSubject subject];
    [self fetchRemote:param success:^(id  _Nullable response) {
        [subject sendNext:response];
    } failed:^(NSError * _Nullable error) {
        [subject sendError:error];
        
    }];
    return subject;
}

- (nonnull RACSignal *) saveRemote:(nullable NSDictionary *)param
{
    RACSubject * subject = [RACSubject subject];
    [self saveRemote:param success:^(id  _Nullable response) {
        [subject sendNext:response];
    } failed:^(NSError * _Nullable error) {
        [subject sendError:error];
        
    }];
    return subject;
}

- (nonnull RACSignal *) destroyRemote:(nullable NSDictionary *)param
{
    RACSubject * subject = [RACSubject subject];
    [self destroyRemote:param success:^(id  _Nullable response) {
        [subject sendNext:response];
    } failed:^(NSError * _Nullable error) {
        [subject sendError:error];
        
    }];
    return subject;
}

# pragma mark - storage

- (nonnull RACSignal *) fetchStorage:(nullable NSDictionary *)param
{
    return [self fetchStorageWithKey:[self storageKeyWithParam:param] param:param];
}

- (nonnull RACSignal *) saveStorage:(nullable NSDictionary *)param
{
    return [self saveStorageWithKey:[self storageKeyWithParam:param] param:param];
}

/** DELETE */
- (nonnull RACSignal *) destroyStorage:(nullable NSDictionary *)param
{
    return [self destroyStorageWithKey:[self storageKeyWithParam:param] param:param];
}

- (nonnull RACSignal *)fetchStorageWithKey:(NSString *)storage param:(NSDictionary *)param
{
    NSDictionary * dict = [self.storageSync fetchStorageSyncWithKey:storage param:param];
    NSError * error = nil;
    if (dict) {
        [self transformerProxyOfResponse:dict error:&error];
    }
    else {
        error = [NSError errorWithDomain:NSStringFromClass([self class]) code:404 userInfo:nil];
    }
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!error) {
                [subscriber sendNext:self];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:error];
            }
        });
        
        return nil;
    }];
}

- (nonnull RACSignal *)saveStorageWithKey:(nonnull NSString *)storage param:(nullable NSDictionary *)param
{
    id<NSCoding> object = [self mergeSelfAndParameters:param];
    [self.storageSync saveStorageSyncWithKey:storage withObject:object param:param];
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:self];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}

- (nonnull RACSignal *)destroyStorageWithKey:(nonnull NSString *)storage param:(nullable NSDictionary *)param
{
    [self.storageSync destroyStorageSyncWithKey:storage param:param];
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}

#pragma mark - db

/** GET */
- (nonnull RACSignal *) fetchDB:(nullable NSDictionary *)param
{
    NSError * error = nil;
    return [self _createRACSingalWithNext:[self fetchDBSync:param error:&error] error:error];
}

/**
 * POST / PUT
 * 数据库不存在时创建，否则更新
 * 更新必须带主键
 */
- (nonnull RACSignal *) saveDB:(nullable NSDictionary *)param
{
    NSError * error = nil;
    return [self _createRACSingalWithNext:[self saveDBSync:param error:&error] error:error];
}

/** DELETE */
- (nonnull RACSignal *) destroyDB:(nullable NSDictionary *)param
{
    NSError * error = nil;
    return [self _createRACSingalWithNext:@([self destroyDBSync:param error:&error]) error:error];
}

/** GET Foreign Models with primary key */
- (nonnull RACSignal *) fetchDBForeignWithModelClass:(nonnull Class<YTXRestfulModelDBSerializing>)modelClass param:(nullable NSDictionary *)param
{
    NSError * error;
    NSArray<NSDictionary *> * ret = [self fetchDBForeignSyncWithModelClass:modelClass error:&error param:param];
    return [self _createRACSingalWithNext:ret error:error];
}


- (nonnull RACSignal *) _createRACSingalWithNext:(id) ret error:(nullable NSError *) error
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (error) {
                [subscriber sendError:error];
                return;
            }
            [subscriber sendNext:ret];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}

@end