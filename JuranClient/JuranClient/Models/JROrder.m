//
//  JROrder.m
//  JuranClient
//
//  Created by Kowloon on 15/2/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "JROrder.h"

@implementation JROrder


- (id)init{
    self = [super init];
    if (self) {
        self.measureTid = @"";
        self.designTid = @"";
        self.status = @"";
        self.headUrl = @"";
        self.decoratorMobile = @"";
        self.account = @"";
        self.decoratorName = @"";
        self.levelCode = @"";
        self.gmtCreate = @"";
        self.customerName = @"";
        self.customerMobile = @"";
        self.houseArea = @"";
        self.addressInfo = @"";
        self.payStatus = @"";
        self.measurefileSrc = @[];
        self.fileSrc = @[];
        self.decoratorRealName = @"";
        self.decoratorEmail = @"";
        self.decoratorWechat = @"";
        self.customerRealName = @"";
        self.customerEmail = @"";
        self.customerCardNo = @"";
        self.customerWechat = @"";
        self.houseType = @"";
        self.serviceDate = @"";
        self.customerHeadUrl = @"";
    }
    return self;
}

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
        
        self.customerHeadUrl = [dict getStringValueForKey:@"customerHeadUrl" defaultValue:@""];
        self.serviceDate = [dict getStringValueForKey:@"serviceDate" defaultValue:@""];
        
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

- (NSString *)houseAreaString{
    if (self.houseArea.length != 0) {
        return [NSString stringWithFormat:@"%@㎡", self.houseArea];
    }
    return @"";
}

- (void)onNext{
    
}

- (void)buildUpWithValueForDetail:(id)dict{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    self.status = [dict getStringValueForKey:@"status" defaultValue:@""];
    self.payStatus = [dict getStringValueForKey:@"payStatus" defaultValue:@""];
    self.measurePayAmount = [dict getIntValueForKey:@"measurePayAmount" defaultValue:0];
    self.firstPayAmount = [dict getIntValueForKey:@"firstPayAmount" defaultValue:0];
    self.finalPayAmount = [dict getIntValueForKey:@"finalPayAmount" defaultValue:0];
    self.amount = [dict getIntValueForKey:@"amount" defaultValue:0];
    self.payAmount = [dict getIntValueForKey:@"payAmount" defaultValue:0];
    self.waitPayAmount = [dict getIntValueForKey:@"waitPayAmount" defaultValue:0];
    self.unPaidAmount = [dict getIntValueForKey:@"unPaidAmount" defaultValue:0];
    self.measurefileSrc = dict[@"measurefileSrc"];
    if(![self.measurefileSrc isKindOfClass:[NSArray class]]){
        self.measurefileSrc = @[];
    }
    self.fileSrc = dict[@"fileSrc"];
    if (![self.fileSrc isKindOfClass:[NSArray class]]) {
        self.fileSrc = @[];
    }
    self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
    self.decoratorRealName = [dict getStringValueForKey:@"decoratorRealName" defaultValue:@""];
    self.decoratorName = [dict getStringValueForKey:@"decoratorName" defaultValue:@""];
    self.decoratorMobile = [dict getStringValueForKey:@"decoratorMobile" defaultValue:@""];
    self.decoratorEmail = [dict getStringValueForKey:@"decoratorEmail" defaultValue:@""];
    self.decoratorWechat = [dict getStringValueForKey:@"decoratorWechat" defaultValue:@""];
    self.customerRealName = [dict getStringValueForKey:@"customerRealName" defaultValue:@""];
    self.customerName = [dict getStringValueForKey:@"customerName" defaultValue:@""];
    self.customerMobile = [dict getStringValueForKey:@"customerMobile" defaultValue:@""];
    self.customerEmail = [dict getStringValueForKey:@"customerEmail" defaultValue:@""];
    self.customerCardNo = [dict getStringValueForKey:@"customerCardNo" defaultValue:@""];
    self.customerWechat = [dict getStringValueForKey:@"customerWechat" defaultValue:@""];
    self.houseType = [dict getStringValueForKey:@"houseType" defaultValue:@""];
    self.houseArea = [dict getStringValueForKey:@"houseArea" defaultValue:@""];
    self.addressInfo = [dict getStringValueForKey:@"addressInfo" defaultValue:@""];
    self.serviceDate = [dict getStringValueForKey:@"serviceDate" defaultValue:@""];
    self.decoratorId = [dict getIntValueForKey:@"decoratorId" defaultValue:0];
    self.customerHeadUrl = [dict getStringValueForKey:@"customerHeadUrl" defaultValue:@""];
}

- (void)buildUpWithValueForComment:(id)dict{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    self.content = [dict getStringValueForKey:@"content" defaultValue:@""];
    self.capacityPoint = [dict getIntValueForKey:@"capacityPoint" defaultValue:0];
    self.servicePoint = [dict getIntValueForKey:@"servicePoint" defaultValue:0];
    self.levelCode = [dict getStringValueForKey:@"userLevel" defaultValue:@""];
}

- (NSString *)serviceDateString{
    NSArray *rows = @[@"只工作日",@"工作日、双休日与假日均可",@"只双休日、假日"];
    NSString *retVal = [rows objectAtTheIndex:[_serviceDate integerValue]];
    if (retVal) {
        return retVal;
    }
    
    return @"";
}

@end
