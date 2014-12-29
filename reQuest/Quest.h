//
//  Quest.h
//  reQuest
//
//  Created by Vinu Ilangovan on 11/22/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quest : NSObject

-(id) initWithData:(NSString*)title description:(NSString*)description cost:(float)cost dist:(NSInteger)dist user:(NSString*)name address1:(NSString*)address1 address2:(NSString*)address2 city:(NSString*)city state:(NSString*)state zipcode:(NSInteger)zipcode lat:(float)lat longt:(float)longitude dict:(NSDictionary*)myDict;

@property (copy, nonatomic, readonly) NSString *qtitle;
@property (copy, nonatomic, readonly) NSString *qdescription;
@property (nonatomic, readonly) float qcost;
@property (nonatomic, readonly) NSInteger qdistance;
@property (copy, nonatomic, readonly) NSString *qname;
@property (copy, nonatomic, readonly) NSString *qaddress1;
@property (copy, nonatomic, readonly) NSString *qaddress2;
@property (copy, nonatomic, readonly) NSString *qcity;
@property (copy, nonatomic, readonly) NSString *qstate;
@property (nonatomic, readonly) NSInteger qzipcode;

@property (nonatomic, readonly) float qlatitude;
@property (nonatomic, readonly) float qlongitude;

@property (nonatomic, readonly) NSDictionary *myDict;


@end
