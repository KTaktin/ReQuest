//
//  ReQuestViewController.m
//  reQuest
//
//  Created by Vinu Ilangovan on 11/22/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Firebase/Firebase.h>
#import "ReQuestViewController.h"
#import "Quest.h"

@interface ReQuestViewController ()

@end

@implementation ReQuestViewController {
    UITapGestureRecognizer *tap;
    bool editable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavBar];
    self.qdescription.delegate = self;
    editable = YES;
    self.view.userInteractionEnabled = YES;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isRequest"]) {
        [self setUpOldReQ];
    }
    else {
        [self setUpNewReQ];
    }
    self.qtitle.delegate = self;
    self.qcost.delegate = self;
    self.qaddr1.delegate = self;
    self.qaddr2.delegate = self;
    self.qcity.delegate = self;
    self.qstate.delegate = self;
    self.qzipcode.delegate = self;
}

-(void)setUpNavBar {
    self.navigationItem.title = @"reQuest";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor whiteColor],NSForegroundColorAttributeName,
                                                                   [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self
                                    action:@selector(closePage:)];
    
    
    
    self.navigationItem.rightBarButtonItem = closeButton;
    
    /*UIBarButtonItem *submitButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self
                                    action:@selector(submitRequest:)];
    
    
    
    self.navigationItem.rightBarButtonItem = submitButton;*/
}

-(void)setUpNewReQ {
    self.qstoredAddr.enabled = YES;
    [self.qstoredAddr setTitle:@"Use Stored Address" forState:UIControlStateNormal];
    [self.qstoredAddr addTarget:self action:@selector(useStoredAddr:) forControlEvents:UIControlEventTouchUpInside];
    [self.qsubmit setTitle:@"reQuest" forState:UIControlStateNormal];
    [self.qsubmit addTarget:self action:@selector(submitReQ:) forControlEvents:UIControlEventTouchUpInside];
    
    editable = YES;
    [self.qdescription setEditable:YES];
}

-(void)setUpOldReQ {
    [self.qstoredAddr setTitle:@"Use Stored Address" forState:UIControlStateNormal];
    self.qstoredAddr.enabled = NO;
    [self.qsubmit setTitle:@"Venmo Quester" forState:UIControlStateNormal];
    [self.qsubmit addTarget:self action:@selector(payWithVenmo:) forControlEvents:UIControlEventTouchUpInside];
    
    editable = NO;
    [self.qdescription setEditable:NO];
    
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"Title"];
    self.qtitle.text = [NSString stringWithFormat:@" %@", string];
    float cost = [[NSUserDefaults standardUserDefaults] floatForKey:@"Cost"];
    self.qcost.text = [NSString stringWithFormat:@" $%.02f", cost];
    string = [[NSUserDefaults standardUserDefaults] objectForKey:@"daddr1"];
    self.qaddr1.text = [NSString stringWithFormat:@" %@", string];;
    string = [[NSUserDefaults standardUserDefaults] objectForKey:@"daddr2"];
    self.qaddr2.text = [NSString stringWithFormat:@" %@", string];;
    string = [[NSUserDefaults standardUserDefaults] objectForKey:@"dcity"];
    self.qcity.text = [NSString stringWithFormat:@" %@", string];;
    string = [[NSUserDefaults standardUserDefaults] objectForKey:@"dstate"];
    self.qstate.text = [NSString stringWithFormat:@" %@", string];;
    NSInteger zip = [[NSUserDefaults standardUserDefaults] integerForKey:@"dzip"];
    self.qzipcode.text = [NSString stringWithFormat:@" %ld", (long)zip];
    string = [[NSUserDefaults standardUserDefaults] objectForKey:@"ddescription"];
    self.qdescription.text = [NSString stringWithFormat:@" %@", string];;
}

-(void)closePage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)useStoredAddr:(id)sender {
    NSLog(@"stored addr");
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"Address1"];
    self.qaddr1.text = string;
    string = [[NSUserDefaults standardUserDefaults] objectForKey:@"Address2"];
    self.qaddr2.text = string;
    string = [[NSUserDefaults standardUserDefaults] objectForKey:@"City"];
    self.qcity.text = string;
    string = [[NSUserDefaults standardUserDefaults] objectForKey:@"State"];
    self.qstate.text = string;
    NSInteger zip = [[NSUserDefaults standardUserDefaults] integerForKey:@"Zipcode"];
    self.qzipcode.text = [NSString stringWithFormat:@"%ld", (long)zip];
}

-(void)submitReQ:(id)sender {
    NSLog(@"request submitted");
    
    if ([self.qtitle.text length] == 0 || [self.qcost.text length] == 0 || [self.qaddr1.text length] == 0 || [self.qcity.text length] == 0 || [self.qstate.text length] == 0 || [self.qzipcode.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Complete"
                                                        message:@"The request you are submitting is not complete."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.qtitle.text forKey:@"Title"];
    [[NSUserDefaults standardUserDefaults] setFloat:[self.qcost.text floatValue] forKey:@"Cost"];
    [[NSUserDefaults standardUserDefaults] setObject:self.qaddr1.text forKey:@"daddr1"];
    [[NSUserDefaults standardUserDefaults] setObject:self.qaddr2.text forKey:@"daddr2"];
    [[NSUserDefaults standardUserDefaults] setObject:self.qcity.text forKey:@"dcity"];
    [[NSUserDefaults standardUserDefaults] setObject:self.qstate.text forKey:@"dstate"];
    [[NSUserDefaults standardUserDefaults] setObject:self.qzipcode.text forKey:@"dzip"];
    [[NSUserDefaults standardUserDefaults] setObject:self.qdescription.text forKey:@"ddescription"];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRequest"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    NSString * userAddr = [NSString stringWithFormat:@"%@, %@, %@ %ld", [[NSUserDefaults standardUserDefaults] objectForKey:@"daddr1"], [[NSUserDefaults standardUserDefaults] objectForKey:@"dcity"], [[NSUserDefaults standardUserDefaults] objectForKey:@"dstate"], (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"dzipcode"]];
    __block double userLat = 0;
    __block double userLong = 0;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:userAddr completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            userLat = placemark.location.coordinate.latitude;
            userLong = placemark.location.coordinate.longitude;
            
            
            Firebase *ref = [[Firebase alloc] initWithUrl:@"https://flickering-torch-6571.firebaseio.com/"];
            
            NSMutableArray *questArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [self.questCollection count]; i++) {
                Quest *currQuest = [self.questCollection objectAtIndex:i];
                [questArray addObject:currQuest.myDict];
            }
            
            float cost = [[NSUserDefaults standardUserDefaults] floatForKey:@"Cost"];
            NSInteger zip = [[NSUserDefaults standardUserDefaults] integerForKey:@"dzipcode"];
            NSDictionary *addr = @{
                                   @"address1" : [[NSUserDefaults standardUserDefaults] objectForKey:@"daddr1"],
                                   @"address2" : [[NSUserDefaults standardUserDefaults] objectForKey:@"daddr2"],
                                   @"city" : [[NSUserDefaults standardUserDefaults] objectForKey:@"dcity"],
                                   @"state" : [[NSUserDefaults standardUserDefaults] objectForKey:@"dstate"],
                                   @"zip" : [NSNumber numberWithInteger:zip],
                                   @"latude" : [NSNumber numberWithFloat:userLat],
                                   @"lotude" : [NSNumber numberWithFloat:userLong]
                                   };
            NSDictionary *newQuest = @{
                                        @"title" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Title"],
                                        @"user" : [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"],
                                        @"state" : @4,
                                        @"description" : [[NSUserDefaults standardUserDefaults] objectForKey:@"ddescription"],
                                        @"cost" : [NSNumber numberWithFloat:cost],
                                        @"address" : addr
                                        };
            
            Firebase *usersRef = [ref childByAppendingPath: @"quests"];
            
            [questArray addObject:newQuest];
            [usersRef setValue: questArray];
            
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"reQuest Submitted"
                                                            message:@"Your reQuest has successfully been submitted"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            [self.qsubmit setTitle:@"Venmo Quester" forState:UIControlStateNormal];
            [self closePage:nil];
        }
    }];
    
}

-(void)payWithVenmo:(id)sender {
    NSLog(@"payed");
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRequest"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alerted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://flickering-torch-6571.firebaseio.com/"];
    
    NSMutableArray *questArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.questCollection count]; i++) {
        Quest *currQuest = [self.questCollection objectAtIndex:i];
        
        
        NSString *title = [[NSUserDefaults standardUserDefaults] objectForKey:@"Title"];
        if (![currQuest.qtitle isEqualToString:title]) {
            [questArray addObject:currQuest.myDict];
        }
    }
    
    Firebase *usersRef = [ref childByAppendingPath: @"quests"];
    [usersRef setValue: questArray];
    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quest completed"
                                                    message:@"Quester has been payed"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    self.qtitle.text = nil;
    self.qcost.text = nil;
    self.qaddr1.text = nil;
    self.qaddr2.text = nil;
    self.qcity.text = nil;
    self.qstate.text = nil;
    self.qzipcode.text = nil;
    self.qdescription.text = @"Ex. rice, beans, chicken...";
    self.qdescription.textColor = [UIColor lightGrayColor];
    
    [self.qsubmit setTitle:@"reQuest" forState:UIControlStateNormal];
    [self closePage:nil];
}

-(void)textViewDidBeginEditing:(UITextField *)textField {
    [self moveView:self.view :0 :-90 :0.5];
    if ([self.qdescription.text isEqualToString:@"Ex. rice, beans, chicken..."]) {
        self.qdescription.text = nil;
    }
    self.qdescription.textColor = [UIColor blackColor];
 }
 
-(void)textViewDidEndEditing:(UITextField *)textField {
     [self moveView:self.view :0 :0 :0.5];
     UIColor *color;
     if (self.qdescription.text && self.qdescription.text.length > 0) {
         color = [UIColor lightGrayColor];
     }
     else {
         color = [UIColor blackColor];
         self.qdescription.text = @"Ex. rice, beans, chicken...";
         self.qdescription.textColor = [UIColor lightGrayColor];
     }
 }

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return editable;
}
 
-(void)moveView:(UIView *)viewToMove :(float)xorigin :(float)yorigin :(float)duration {
     [UIView animateWithDuration:duration
                           delay:0.0
                         options: UIViewAnimationOptionCurveEaseOut
                      animations:^
      {
          CGRect frame = viewToMove.frame;
          frame.origin.y = yorigin;
          frame.origin.x = xorigin;
          viewToMove.frame = frame;
      }
                      completion:nil];
 }

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    
    [tap setNumberOfTapsRequired:1];
    [tap setCancelsTouchesInView:NO];
    
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.view removeGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.qtitle resignFirstResponder];
    [self.qcost resignFirstResponder];
    [self.qaddr1 resignFirstResponder];
    [self.qaddr2 resignFirstResponder];
    [self.qcity resignFirstResponder];
    [self.qstate resignFirstResponder];
    [self.qzipcode resignFirstResponder];
    [self.qdescription resignFirstResponder];
}

-(BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
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
