//
//  HSUStatusDataSource.m
//  Tweet4China
//
//  Created by Jason Hsu on 4/18/13.
//  Copyright (c) 2013 Jason Hsu <support@tuoxie.me>. All rights reserved.
//

#import "HSUStatusDataSource.h"

@implementation HSUStatusDataSource

- (id)initWithDelegate:(id<HSUBaseDataSourceDelegate>)delegate status:(NSDictionary *)status
{
    self = [super init];
    if (self) {
        HSUTableCellData *mainCellData = [[HSUTableCellData alloc] initWithRawData:status dataType:kDataType_MainStatus];
        [self.data addObject:mainCellData];
        
        self.delegate = delegate;
        [self.delegate preprocessDataSourceForRender:self];
    }
    return self;
}

- (void)refresh
{
    // load context data, then call finish on delegate
    NSDictionary *status = [self.data[0] rawData];
    if ([status[@"in_reply_to_status_id_str"] length]) {
        __weak typeof(self)weakSelf = self;
        [TWENGINE getDetailsForStatus:status[@"in_reply_to_status_id_str"] success:^(id responseObj) {
            HSUTableCellData *chatCellData = [[HSUTableCellData alloc] initWithRawData:responseObj dataType:kDataType_ChatStatus];
            [weakSelf.data insertObject:chatCellData atIndex:0];
            [weakSelf.delegate dataSource:weakSelf didFinishRefreshWithError:nil];
            [weakSelf performSelector:@selector(refresh)];
        } failure:^(NSError *error) {
            [weakSelf.delegate dataSource:weakSelf didFinishRefreshWithError:error];
        }];
    }
}

//- (void)loadMore
//{
//    NSDictionary *status = self.mainStatus[@"retweeted_status"] ?: self.mainStatus;
//    NSInteger retweetCount = [status[@"retweet_count"] integerValue] - self.loadedRetweetCount;
//    if (retweetCount) {
//        if (retweetCount > self.requestCount) {
//            retweetCount = self.requestCount;
//        }
//        __weak typeof(self)weakSelf = self;
//        [TWENGINE getRetweetsForStatus:status[@"id_str"] count:retweetCount success:^(id responseObj) {
//            if ([responseObj isKindOfClass:[NSArray class]]) {
//                NSArray *retweets = (NSArray *)responseObj;
//                weakSelf.loadedRetweetCount += retweets.count;
//                for (NSDictionary *retweet in retweets) {
//                    HSUTableCellData *cellData = [[HSUTableCellData alloc] initWithRawData:retweet dataType:kDataType_ChatStatus];
//                    [weakSelf.data addObject:cellData];
//                }
//                
//                HSUTableCellData *lastCellData = weakSelf.data.lastObject;
//                if (![lastCellData.dataType isEqualToString:kDataType_LoadMore]) {
//                    HSUTableCellData *loadMoreCellData = [[HSUTableCellData alloc] init];
//                    loadMoreCellData.rawData = @{@"status": @(kLoadMoreCellStatus_Done)};
//                    loadMoreCellData.dataType = kDataType_LoadMore;
//                    [weakSelf.data addObject:loadMoreCellData];
//                }
//                
//                [weakSelf.delegate dataSource:weakSelf didFinishRefreshWithError:nil];
//            }
//        } failure:^(NSError *error) {
//            [weakSelf.delegate dataSource:weakSelf didFinishRefreshWithError:error];
//        }];
//    }
//}

@end
