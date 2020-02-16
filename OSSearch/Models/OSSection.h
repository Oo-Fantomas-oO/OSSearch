//
//  OSSection.h
//  OSSearch
//
//  Created by Sergii Onopriienko on 16.02.2020.
//  Copyright © 2020 Onopriienko Sergii. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSSection : NSObject

@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSMutableArray *rowsArray;

@end

NS_ASSUME_NONNULL_END
