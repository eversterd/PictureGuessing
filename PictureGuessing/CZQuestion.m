//
//  CZQuestion.m
//  PictureGuessing
//
//  Created by shiyc on 15/12/22.
//  Copyright © 2015年 shiyc. All rights reserved.
//

#import "CZQuestion.h"

@implementation CZQuestion :NSObject
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if(self=[self init])
    {
        [self setValuesForKeysWithDictionary:dic];
           }
    return self;
}
+(instancetype)questionWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
+(NSArray *)questionList
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
    NSArray *dicArray=[NSArray arrayWithContentsOfFile:path];
    NSMutableArray *tmpArray=[NSMutableArray array];
    for (NSDictionary *dic in dicArray )
    {
        CZQuestion *question=[CZQuestion questionWithDic:dic];
      
        [tmpArray addObject:question];
        
    }
    return tmpArray;

}
@end
