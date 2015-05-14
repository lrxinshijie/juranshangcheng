//
//  ProductFilterData.m
//  JuranClient
//
//  Created by 彭川 on 15/5/6.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductFilterData.h"

@implementation ProductAttribute
- (id)copyWithZone:(NSZone *)zone {
    ProductAttribute *theCopy = [[[self class] allocWithZone:zone]init];
    theCopy.attName = self.attName.copy;
    theCopy.attId = self.attId.copy;
    theCopy.attValues = self.attValues.mutableCopy;
    return theCopy;
}

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.attName = [dict getStringValueForKey:@"attName" defaultValue:@""];
        self.attId = [dict getStringValueForKey:@"attId" defaultValue:@""];
        self.attValues = [dict getArrayValueForKey:@"attValue" defaultValue:@[]];
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            ProductAttribute *s = [[ProductAttribute alloc] initWithDictionary:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}
@end
//------------------------------------------------------------------
@implementation ProductCategory
- (id)copyWithZone:(NSZone *)zone {
    ProductCategory *theCopy = [[[self class] allocWithZone:zone]init];
    theCopy.Id = self.Id;
    theCopy.shopId = self.shopId;
    theCopy.name = self.name.copy;
    theCopy.depth = self.depth;
    theCopy.parentId = self.parentId;
    theCopy.catCode = self.catCode.copy;
    theCopy.catName = self.catName.copy;
    theCopy.parentCode = self.parentCode.copy;
    theCopy.urlContent = self.urlContent.copy;
    theCopy.childList = self.childList.mutableCopy;
    return theCopy;
}

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.Id = [dict getLongValueForKey:@"id" defaultValue:0];
        self.shopId = [dict getLongValueForKey:@"shopId" defaultValue:0];
        self.name = [dict getStringValueForKey:@"name" defaultValue:@""];
        self.depth = [dict getIntValueForKey:@"depth" defaultValue:0];
        self.parentId = [dict getLongValueForKey:@"parentId" defaultValue:-1];
        self.catCode = [dict getStringValueForKey:@"catCode" defaultValue:@""];
        self.catName = [dict getStringValueForKey:@"catName" defaultValue:@""];
        self.parentCode = [dict getStringValueForKey:@"parentCode" defaultValue:@""];
        self.urlContent = [dict getStringValueForKey:@"urlContent" defaultValue:@""];
        self.childList = [[NSMutableArray alloc]init];
        self.isOpen = NO;
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            ProductCategory *s = [[ProductCategory alloc] initWithDictionary:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}
@end
//------------------------------------------------------------------
@implementation ProductBrand
- (id)copyWithZone:(NSZone *)zone {
    ProductBrand *theCopy = [[[self class] allocWithZone:zone]init];
    theCopy.catCode = self.catCode.copy;
    theCopy.brandId = self.brandId;
    theCopy.brandName = self.brandName.copy;
    return theCopy;
}

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.catCode = [dict getStringValueForKey:@"operatingCatCode" defaultValue:@""];
        self.brandId = [dict getLongValueForKey:@"brandId" defaultValue:0];
        self.brandName = [dict getStringValueForKey:@"brandName" defaultValue:@""];
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            ProductBrand *s = [[ProductBrand alloc] initWithDictionary:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}
@end
//------------------------------------------------------------------
@implementation ProductStore
- (id)copyWithZone:(NSZone *)zone {
    ProductStore *theCopy = [[[self class] allocWithZone:zone]init];
    theCopy.storeCode = self.storeCode.copy;
    theCopy.storeName = self.storeName.copy;
    return theCopy;
}

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.storeCode = [dict getStringValueForKey:@"storeCode" defaultValue:@""];
        self.storeName = [dict getStringValueForKey:@"storeName" defaultValue:@""];
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            ProductStore *s = [[ProductStore alloc] initWithDictionary:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}
@end
//------------------------------------------------------------------
@implementation ProductClass
- (id)copyWithZone:(NSZone *)zone {
    ProductClass *theCopy = [[[self class] allocWithZone:zone]init];
    theCopy.classCode = self.classCode.copy;
    theCopy.className = self.className.copy;
    return theCopy;
}

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self=[self init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.classCode = [dict getStringValueForKey:@"catCode" defaultValue:@""];
        self.className = [dict getStringValueForKey:@"catName" defaultValue:@""];
    }
    return self;
}

+ (NSMutableArray*)buildUpWithValueForList:(id)value {
    NSMutableArray *retVal = [NSMutableArray array];
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (id obj in value) {
            ProductClass *s = [[ProductClass alloc] initWithDictionary:obj];
            [retVal addObject:s];
        }
    }
    return retVal;
}
@end
//------------------------------------------------------------------
@implementation ProductSort
- (id)copyWithZone:(NSZone *)zone {
    ProductSort *theCopy = [[[self class] allocWithZone:zone]init];
    theCopy.sort = self.sort;
    theCopy.name = self.name.copy;
    return theCopy;
}
@end
//------------------------------------------------------------------

