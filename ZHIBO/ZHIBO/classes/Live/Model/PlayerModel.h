//
//  PlayerModel.h
//  ZHIBO
//
//  Created by qianfeng on 16/9/8.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerModel : NSObject

@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *portrait;
@property (nonatomic,assign)int online_users;
@property (nonatomic,strong)NSString *url;
- (id)initWithDictionary:(NSDictionary *)dic;

@end
