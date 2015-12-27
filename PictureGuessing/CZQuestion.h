//
//  CZQuestion.h
//  PictureGuessing
//
//  Created by shiyc on 15/12/22.
//  Copyright © 2015年 shiyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZQuestion : NSObject
@property (nonatomic,copy) NSString *answer;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSArray  *options;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)questionWithDic:(NSDictionary *)dic;
+(NSArray *)questionList;
@end
