//
//  HSUListDataSource.h
//  Tweet4China
//
//  Created by Jason Hsu on 2013/12/2.
//  Copyright (c) 2013年 Jason Hsu <support@tuoxie.me>. All rights reserved.
//

#import "HSUBaseDataSource.h"

@interface HSUSubscribedListsDataSource : HSUBaseDataSource

@property (nonatomic, copy) NSString *screenName;

- (id)initWithScreenName:(NSString *)screenName;

@end
