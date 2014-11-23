//
//  ASGeometry.m
//  Library
//
//  Created by Kowloon on 12-12-7.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "ASGeometry.h"

NSString *NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coordinate)
{
    return [NSString stringWithFormat:@"latitude:%lf\tlongitude:%lf",coordinate.latitude,coordinate.longitude];
}

NSString *NSStringFromCGSize(CGSize size)
{
    return [NSString stringWithFormat:@"width:%lf\theight:%lf",size.width,size.height];
}