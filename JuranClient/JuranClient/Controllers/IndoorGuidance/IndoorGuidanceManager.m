//
//  IndoorGuidanceManager.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/5/27.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "IndoorGuidanceManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "JRStore.h"
#import "GuidanceShopItem.h"

typedef void (^CheckOutBluetoothBlock)(BOOL isUsable);

@interface IndoorGuidanceManager ()<CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager * cbManager;
@property (nonatomic, readwrite, copy) CheckOutBluetoothBlock checkOutBluetoothBlock;
@property (strong, nonatomic) NSMutableArray * shopListArray;

@end

@implementation IndoorGuidanceManager

static IndoorGuidanceManager * sharedManager = nil;

+ (IndoorGuidanceManager *)sharedMagager
{
    @synchronized(self)
    {
        if (sharedManager == nil)
        {
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_shopListArray) {
            _shopListArray = [NSMutableArray arrayWithCapacity:0];
        }
    }
    return self;
}

- (void)dealloc
{
    self.cbManager = nil;
}

- (void)checkOutBluetooth:(void(^)(BOOL isUsable))block
{
    self.checkOutBluetoothBlock = block;
    self.cbManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state) {
            
        case CBPeripheralManagerStatePoweredOn:
            //状态开启
            if (self.checkOutBluetoothBlock) {
                self.checkOutBluetoothBlock(YES);
            }
            break;
            
        default:
            if (self.checkOutBluetoothBlock) {
                self.checkOutBluetoothBlock(NO);
            }
            break;
    }
}

- (void)saveGuidanceShop:(NSArray *)shopList
{
    [self.shopListArray addObjectsFromArray:shopList];
}

- (NSArray *)getGuidanceShop
{
    if (self.shopListArray.count<=0) {
        
        NSArray * arr = [[self dictionaryWithJsonString:[self getCache]] objectForKey:@"buildings"];
        NSMutableArray * temp = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<arr.count; i++) {
            GuidanceShopItem * gItem = [GuidanceShopItem createGuidanceShopItemWithDictionary:[arr objectAtIndex:i]];
            [temp addObject:gItem];
        }
        
        [self.shopListArray addObjectsFromArray:temp];
    }
    return self.shopListArray;
}

- (NSArray *)filterGuidingShopfrom:(NSArray *)all
{
    NSMutableArray * tempArr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i=0; i<all.count; i++) {
        JRStore * store = [all objectAtIndex:i];
        for (int j = 0; j<[self getGuidanceShop].count; j++) {
            GuidanceShopItem * item = [[self getGuidanceShop] objectAtIndex:j];
            if ([store.storeCode isEqualToString:item.mid]) {
                store.couldGuidance = YES;
                break;
            }
//            //测试数据
//            if (i==0 || i==2) {
//                store.couldGuidance = YES;
//                break;
//            }
        }
        [tempArr addObject:store];
    }
    
    return tempArr;
}

- (void)cacheGuidanceList:(NSString *)str
{
    //存储
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:GUIDANCE_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getCache
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:GUIDANCE_LIST];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString*) getDeviceType
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return nil;
}

- (NSString *)getResolutionRatio
{
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    return [NSString stringWithFormat:@"%.2fX%.2f",size_screen.width*scale_screen,size_screen.height*scale_screen];
}

@end
