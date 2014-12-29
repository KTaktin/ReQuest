//
//  QuestViewController.m
//  reQuest
//
//  Created by Vinu Ilangovan on 11/22/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import "QuestViewController.h"
#import <Firebase/Firebase.h>

@interface QuestViewController ()

@end

@implementation QuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.qpic.layer.cornerRadius = 5;
    self.qpic.clipsToBounds = YES;
    self.qtitle.layer.cornerRadius = 5;
    self.qtitle.clipsToBounds = YES;
    self.qacceptOffer.layer.cornerRadius = 5;
    self.qacceptOffer.clipsToBounds = YES;
    
    [self.qacceptOffer addTarget:self action:@selector(acceptOffer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadQuestInfo];
}

-(void)loadQuestInfo {
    self.qtitle.text = [NSString stringWithFormat:@" %@", self.currentQuest.qtitle];
    self.qname.text = [NSString stringWithFormat:@"%@ reQuested", self.currentQuest.qname];
    self.qcost.text = [NSString stringWithFormat:@"$%.02f", self.currentQuest.qcost];
    self.qdistance.text = [NSString stringWithFormat:@"Distance: %ld miles", (long)self.currentQuest.qdistance];
    self.qdescription.text = self.currentQuest.qdescription;
    
    UIImage *image;
    if (![self.currentQuest.qname isEqualToString:@"alex"] && ![self.currentQuest.qname isEqualToString:@"andrew"] && ![self.currentQuest.qname isEqualToString:@"mike"] && ![self.currentQuest.qname isEqualToString:@"vinu"]) {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"cage.jpg"]];
    }
    else {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", self.currentQuest.qname]];
    }
    
    [self.qpic setImage:image];
    
    if (self.currentQuest.qaddress2 != NULL) {
        self.qaddressLine1.text = [NSString stringWithFormat:@"%@ %@", self.currentQuest.qaddress1, self.currentQuest.qaddress2];
    }
    else {
        self.qaddressLine1.text = [NSString stringWithFormat:@"%@", self.currentQuest.qaddress1];
    }
    self.qaddressLine2.text = [NSString stringWithFormat:@"%@, %@ %ld", self.currentQuest.qcity, self.currentQuest.qstate, (long)self.currentQuest.qzipcode];
    
    /*CLLocationCoordinate2D addressCoordinate = {2, 2};
    MKPointAnnotation *addressPoint = [[MKPointAnnotation alloc] init];
    addressPoint.coordinate = addressCoordinate;
    [self.qaddress addAnnotation:addressPoint];*/
    
    NSString *addrString = [NSString stringWithFormat:@"%@, %@, %@ %ld", self.currentQuest.qaddress1, self.currentQuest.qcity, self.currentQuest.qstate, (long)self.currentQuest.qzipcode];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addrString completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            float spanX = 0.00725;
            float spanY = 0.00725;
            MKCoordinateRegion region;
            region.center.latitude = placemark.location.coordinate.latitude;
            region.center.longitude = placemark.location.coordinate.longitude;
            region.span = MKCoordinateSpanMake(spanX, spanY);
            [self.qaddress setRegion:region animated:YES];
            CLLocationCoordinate2D addressCoordinate = {region.center.latitude, region.center.longitude};
            MKPointAnnotation *addressPoint = [[MKPointAnnotation alloc] init];
            addressPoint.coordinate = addressCoordinate;
            [self.qaddress addAnnotation:addressPoint];
        }
    }];
}

-(void)acceptOffer:(id)sender {
    //BOOL accept = [[NSUserDefaults standardUserDefaults] boolForKey:@"isQuest"];
    //if (!accept) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isQuest"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        Firebase *ref = [[Firebase alloc] initWithUrl:@"https://flickering-torch-6571.firebaseio.com/"];
        
        NSMutableArray *questArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [self.questCollection count]; i++) {
            Quest *currQuest = [self.questCollection objectAtIndex:i];
            
            NSString *title = self.currentQuest.qtitle;
            if ([currQuest.qtitle isEqualToString:title]) {
                NSDictionary *addr = @{
                                       @"address1" : currQuest.qaddress1,
                                       @"address2" : currQuest.qaddress2,
                                       @"city" : currQuest.qcity,
                                       @"state" : currQuest.qstate,
                                       @"zip" : [NSNumber numberWithInteger:currQuest.qzipcode],
                                       @"latude" : [NSNumber numberWithFloat:currQuest.qlatitude],
                                       @"lotude" : [NSNumber numberWithFloat: currQuest.qlongitude]
                                       };
                
                NSDictionary *newQuest = @{
                                           @"title" : currQuest.qtitle,
                                           @"user" : currQuest.qname,
                                           @"state" : @1,
                                           @"description" : currQuest.qdescription,
                                           @"cost" : [NSNumber numberWithFloat:currQuest.qcost],
                                           @"address" : addr
                                           };
                [questArray addObject:newQuest];
                self.acceptedTitle = currQuest.qtitle;
            }
            else {
                [questArray addObject:currQuest.myDict];
            }
            
        }
        
        Firebase *usersRef = [ref childByAppendingPath: @"quests"];
        [usersRef setValue: questArray];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offer Accepted"
                                                    message:@"You have accepted this offer"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    self.navigationItem.hidesBackButton = YES;
    [NSTimer scheduledTimerWithTimeInterval:7.5 target:self selector:@selector(checkIfPaid:) userInfo:nil repeats:YES];
    //}
}

-(void)checkIfPaid:(id)sender {
    
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://flickering-torch-6571.firebaseio.com/quests/"];
    __block NSInteger count = 0;
    __block BOOL enableBack = true;
    
    // Retrieve new posts as they are added to Firebase
    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        count++;
        
        NSString * title1 = snapshot.value[@"title"];

        if ([title1 isEqualToString:self.acceptedTitle]) {
            enableBack = false;
        }
        
    }];
    
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (enableBack) {
            self.navigationItem.hidesBackButton = NO;
        };
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
