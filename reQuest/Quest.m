//
//  Quest.m
//  reQuest
//
//  Created by Vinu Ilangovan on 11/22/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import "Quest.h"

@implementation Quest

-(id) initWithData:(NSString*)title description:(NSString*)description cost:(float)cost dist:(NSInteger)dist user:(NSString*)name address1:(NSString*)address1 address2:(NSString*)address2 city:(NSString*)city state:(NSString*)state zipcode:(NSInteger)zipcode lat:(float)lat longt:(float)longitude dict:(NSDictionary *)myDict {
    
    self = [super init];
    if(self) {
        _qtitle = title;
        _qdescription = description;
        _qcost = cost;
        _qdistance = dist;
        _qname = name;
        _qaddress1 = address1;
        _qaddress2 = address2;
        _qcity = city;
        _qstate = state;
        _qzipcode = zipcode;
        
        _qlatitude = lat;
        _qlongitude = longitude;
        
        _myDict = myDict;
    }
    
    return self;
}

@end
