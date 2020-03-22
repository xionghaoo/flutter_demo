//
//  RouteCommon.h
//  MAMapKit_3D_Demo
//
//  Created by shaobin on 16/8/12.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#ifndef RouteCommon_h
#define RouteCommon_h

typedef NS_ENUM(NSInteger, AMapRoutePlanningType)
{
    AMapRoutePlanningTypeDrive = 0,
    AMapRoutePlanningTypeWalk,
    AMapRoutePlanningTypeBus,
    AMapRoutePlanningTypeBusCrossCity,
    AMapRoutePlanningTypeRiding,
    AMapRoutePlanningTypeTruck
};

typedef NS_ENUM(NSInteger, CommutingCardType)
{
    CommutingCardTypeDrive = 0,
    CommutingCardTypeBus = 1,
};

#endif /* RouteCommon_h */
