//
//  JROrder.m
//  JuranClient
//
//  Created by Kowloon on 15/2/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JROrder.h"

@implementation JROrder

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.key = [dict getIntValueForKey:@"id" defaultValue:0];
        self.measureTid = [dict getStringValueForKey:@"measureTid" defaultValue:@""];
        self.designTid = [dict getStringValueForKey:@"designTid" defaultValue:@""];
        self.status = [dict getStringValueForKey:@"status" defaultValue:@""];
        self.measurePayAmount = [dict getIntValueForKey:@"measurePayAmount" defaultValue:0];
        self.amount = [dict getIntValueForKey:@"amount" defaultValue:0];
        self.payAmount = [dict getIntValueForKey:@"payAmount" defaultValue:0];
        self.waitPayAmount = [dict getIntValueForKey:@"waitPayAmount" defaultValue:0];
        self.type = [dict getIntValueForKey:@"type" defaultValue:0];
        self.decoratorId = [dict getIntValueForKey:@"decoratorId" defaultValue:0];
        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.decoratorMobile = [dict getStringValueForKey:@"decoratorMobile" defaultValue:@""];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.isAuth = [dict getBoolValueForKey:@"isAuth" defaultValue:NO];
        self.decoratorName = [dict getStringValueForKey:@"decoratorName" defaultValue:@""];
        self.levelCode = [dict getStringValueForKey:@"levelCode" defaultValue:@""];
        self.unPaidAmount = [dict getIntValueForKey:@"unPaidAmount" defaultValue:0];
        
        self.ifCanCredit = [dict getBoolValueForKey:@"ifCanCredit" defaultValue:NO];
        self.ifCanViewCredit = [dict getBoolValueForKey:@"ifCanViewCredit" defaultValue:NO];
        
        self.gmtCreate = [dict getStringValueForKey:@"gmtCreate" defaultValue:@""];
        self.customerName = [dict getStringValueForKey:@"customerName" defaultValue:@""];
        self.customerMobile = [dict getStringValueForKey:@"customerMobile" defaultValue:@""];
        self.houseArea = [dict getStringValueForKey:@"houseArea" defaultValue:@""];
        self.addressInfo = [dict getStringValueForKey:@"addressInfo" defaultValue:@""];
        
    }
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JROrder *s = [[JROrder alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}


/*
 待设计师确认量房 ：wait_designer_confirm
 施工完成：construction_complete
 量房转设计：convert_to_design
 交易取消：cancel
 待支付首款：wait_first_pay
 待确认交付物：wait_confirm_design
 待支付尾款：wait_last_pay
 待设计师量房：wait_designer_measure
 待支付：wait_consumer_pay
 设计完成：complete
 */

- (NSString *)statusName{
    NSDictionary *statuses = @{@"wait_designer_confirm":@"待设计师确认",
                               @"construction_complete":@"施工完成",
                               @"convert_to_design":@"量房转设计",
                               @"cancel":@"交易取消",
                               @"wait_first_pay":@"待支付",
                               @"wait_confirm_design":@"待确认交付物",
                               @"wait_last_pay":@"待确认交付物",
                               @"wait_designer_measure":@"待设计师量房",
                               @"wait_consumer_pay":@"待支付",
                               @"complete":@"设计完成",
                               };
    return [statuses getStringValueForKey:self.status defaultValue:@""];
}

- (void)onNext{
    
}

@end
