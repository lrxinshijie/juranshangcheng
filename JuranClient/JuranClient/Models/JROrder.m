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
        self.measurePayAmount = [dict getStringValueForKey:@"measurePayAmount" defaultValue:@""];
        self.amount = [dict getStringValueForKey:@"amount" defaultValue:@""];
        self.payAmount = [dict getStringValueForKey:@"payAmount" defaultValue:@""];
        self.waitPayAmount = [dict getStringValueForKey:@"waitPayAmount" defaultValue:@""];
        self.type = [dict getIntValueForKey:@"type" defaultValue:0];
        self.decoratorId = [dict getIntValueForKey:@"decoratorId" defaultValue:0];
        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.decoratorMobile = [dict getStringValueForKey:@"decoratorMobile" defaultValue:@""];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.isAuth = [dict getBoolValueForKey:@"isAuth" defaultValue:NO];
        self.decoratorName = [dict getStringValueForKey:@"decoratorName" defaultValue:@""];
        self.levelCode = [dict getStringValueForKey:@"levelCode" defaultValue:@""];
        self.unPaidAmount = [dict getStringValueForKey:@"unPaidAmount" defaultValue:@""];
        
        self.ifCanCredit = [dict getBoolValueForKey:@"ifCanCredit" defaultValue:NO];
        self.ifCanViewCredit = [dict getBoolValueForKey:@"ifCanViewCredit" defaultValue:NO];
        
        self.measurefileExist = [dict getBoolValueForKey:@"measurefileExist" defaultValue:NO];
        self.fileExist = [dict getBoolValueForKey:@"fileExist" defaultValue:NO];
        
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
//    NSDictionary *statuses = @{@"wait_designer_confirm":@"待设计师确认量房",
//                               @"construction_complete":@"施工完成",
//                               @"convert_to_design":@"量房转设计",
//                               @"cancel":@"交易取消",
//                               @"wait_first_pay":@"待支付首款",
//                               @"wait_confirm_design":@"待确认交付物",
//                               @"wait_last_pay":@"待支付尾款",
//                               @"wait_designer_measure":@"待设计师量房",
//                               @"wait_consumer_pay":@"待支付",
//                               @"complete":@"设计完成",
//                               };
    NSArray *statuses = [[DefaultData sharedData] objectForKey:@"orderStatus"];
    __block NSString *retVal = @"";
    [statuses enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        if ([[dict objectForKey:@"v"] isEqualToString:self.status]) {
            retVal = [dict objectForKey:@"k"];
            *stop = YES;
        }
    }];
    return retVal;
}

- (NSString *)payStatusString{
    NSDictionary *payStatuses = @{@"no_pay": @"未付款",
                                  @"portion": @"部分支付",
                                  @"waite_confirm": @"等待平台确认支付",
                                  @"paid": @"已付款",
                                  @"trade_pay_init" :@"交易付款开始"
                               };
    return [payStatuses getStringValueForKey:self.payStatus defaultValue:@""];
}

- (NSString *)payStatusString{
    NSDictionary *payStatuses = @{@"no_pay": @"未付款",
                                  @"portion": @"部分支付",
                                  @"waite_confirm": @"等待平台确认支付",
                                  @"paid": @"已付款",
                                  @"trade_pay_init" :@"交易付款开始"
                               };
    return [payStatuses getStringValueForKey:self.payStatus defaultValue:@""];
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
    self.measurePayAmount = [dict getStringValueForKey:@"measurePayAmount" defaultValue:@""];
    self.firstPayAmount = [dict getStringValueForKey:@"firstPayAmount" defaultValue:@""];
    self.finalPayAmount = [dict getStringValueForKey:@"finalPayAmount" defaultValue:@""];
    self.amount = [dict getStringValueForKey:@"amount" defaultValue:@""];
    self.payAmount = [dict getStringValueForKey:@"payAmount" defaultValue:@""];
    self.waitPayAmount = [dict getStringValueForKey:@"waitPayAmount" defaultValue:@""];
    self.unPaidAmount = [dict getStringValueForKey:@"unPaidAmount" defaultValue:@""];
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

- (NSString *)orderSpec{
    NSArray *array = @[@{@"partner": @""},
                       @{@"seller_id": @""},
                       @{@"out_trade_no": @""},
                       @{@"subject": @""},
                       @{@"body": @""},
                       @{@"total_fee": @""},
                       @{@"notify_url": @""},
                       @{@"service": @""},
                       @{@"payment_type": @""},
                       @{@"_input_charset": @""},
                       @{@"it_b_pay": @""},
                       @{@"show_url": @""},
                       @{@"sign_date": @""},
                       @{@"app_id": @""},];
    return [array componentsJoinedByString:@"&"];
}

@end
