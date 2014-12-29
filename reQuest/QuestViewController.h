//
//  QuestViewController.h
//  reQuest
//
//  Created by Vinu Ilangovan on 11/22/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Quest.h"

@interface QuestViewController : UIViewController

@property (strong, nonatomic) Quest * currentQuest;

@property (nonatomic, strong) IBOutlet UILabel *qtitle;
@property (nonatomic, strong) IBOutlet UITextView *qdescription;
@property (nonatomic, strong) IBOutlet UILabel *qcost;
@property (nonatomic, strong) IBOutlet UILabel *qdistance;
@property (nonatomic, strong) IBOutlet UILabel *qname;
@property (nonatomic, strong) IBOutlet MKMapView *qaddress;
@property (nonatomic, strong) IBOutlet UILabel *qaddressLine1;
@property (nonatomic, strong) IBOutlet UILabel *qaddressLine2;
@property (nonatomic, strong) IBOutlet UIImageView *qpic;
@property (nonatomic, strong) IBOutlet UIButton *qacceptOffer;

@property (nonatomic, strong) NSString *acceptedTitle;

@property (strong, nonatomic) NSMutableArray * questCollection;

@end
