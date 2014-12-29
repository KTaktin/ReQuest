//
//  ViewController.m
//  reQuest
//
//  Created by Vinu Ilangovan on 11/22/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import "ViewController.h"
#import "UsersViewController.h"
#import "ReQuestViewController.h"
#import "QuestCell.h"
#import "Quest.h"
#import "QuestViewController.h"
#import <Firebase/Firebase.h>

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpNavBar];
    [self chooseUserPage:self];
    
    [NSTimer scheduledTimerWithTimeInterval:7.5 target:self selector:@selector(checkRequest:) userInfo:nil repeats:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [self reloadQuests:self];
}

-(void)setUpNavBar {
    self.navigationItem.title = @"reQuest";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor whiteColor],NSForegroundColorAttributeName,
                                                                   [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIButton *chooseUserButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [chooseUserButton addTarget:self
                   action:@selector(chooseUserPage:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *chooseUserBarButton = [[UIBarButtonItem alloc] initWithCustomView:chooseUserButton];
    
    UIBarButtonItem *requestButton = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                               target:self
                               action:@selector(requestPage:)];
    
    self.navigationItem.rightBarButtonItems = @[chooseUserBarButton, requestButton];
    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(reloadQuests:)];
    
    self.navigationItem.leftBarButtonItem = reloadButton;
    
}

-(void)chooseUserPage:(id)sender {
    NSLog(@"Choose User Button");
    UsersViewController * userpage = [[UsersViewController alloc] init];
    userpage = [self.storyboard instantiateViewControllerWithIdentifier:@"userPageController"];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:userpage];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)requestPage:(id)sender {
    NSLog(@"reQuest Button");
    ReQuestViewController * requestpage = [[ReQuestViewController alloc] init];
    requestpage = [self.storyboard instantiateViewControllerWithIdentifier:@"requestsPageController"];
    requestpage.questCollection = self.questCollection;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:requestpage];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)checkRequest:(id)sender {
    //NSLog(@"checking %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"isRequest"]);
    //NSLog(@"checking %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"alerted"]);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isRequest"] && ![[NSUserDefaults standardUserDefaults] boolForKey:@"alerted"]) {
        
        
        Firebase *ref = [[Firebase alloc] initWithUrl: @"https://flickering-torch-6571.firebaseio.com/quests/"];
        __block NSInteger count = 0;
        
        // Retrieve new posts as they are added to Firebase
        [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            count++;
            //NSLog(@"%@", snapshot.value[@"state"]);
            NSString * title1 = snapshot.value[@"title"];
            NSString * myreq = [[NSUserDefaults standardUserDefaults] objectForKey:@"Title"];
            
            NSString * name1 = snapshot.value[@"user"];
            NSString * myname = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
            
            NSInteger state = [snapshot.value[@"state"] integerValue];
            
            if (state == 1) {
                //NSLog(@"STATE %@ %@ %@ %@", title1, myreq, name1, myname);
            }
            if ([title1 isEqualToString:myreq] && state == 1 && [name1 isEqualToString:myname]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quest Accepted"
                                                                message:@"Your Quest has been Accepted"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alerted"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        }];
        
        
    }
}

-(void)reloadQuests:(id)sender {
    NSLog(@"reload Quests");
    
    self.questCollection = [[NSMutableArray alloc] init];
    
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:[[NSUserDefaults standardUserDefaults] floatForKey:@"Lat"] longitude:[[NSUserDefaults standardUserDefaults] floatForKey:@"Long"]];
    
    // Get a reference to our posts
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://flickering-torch-6571.firebaseio.com/quests/"];
    __block NSInteger count = 0;
    
    // Retrieve new posts as they are added to Firebase
    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        count++;
        
        NSString *user = snapshot.value[@"user"];
        NSString *myUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
        if ([user isEqualToString:myUser]) {
            [[NSUserDefaults standardUserDefaults] setObject:snapshot.value[@"title"] forKey:@"Title"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRequest"];
            
            [[NSUserDefaults standardUserDefaults] setFloat:[snapshot.value[@"cost"] floatValue] forKey:@"Cost"];
            
            NSDictionary *userAddrDict = snapshot.value[@"address"];
            [[NSUserDefaults standardUserDefaults] setObject:userAddrDict[@"address1"] forKey:@"daddr1"];
            [[NSUserDefaults standardUserDefaults] setObject:userAddrDict[@"address2"] forKey:@"daddr2"];
            [[NSUserDefaults standardUserDefaults] setObject:userAddrDict[@"city"] forKey:@"dcity"];
            [[NSUserDefaults standardUserDefaults] setObject:userAddrDict[@"state"] forKey:@"dstate"];
            [[NSUserDefaults standardUserDefaults] setInteger:[userAddrDict[@"zip"] integerValue] forKey:@"dzip"];
            
            [[NSUserDefaults standardUserDefaults] setObject:snapshot.value[@"description"] forKey:@"ddescription"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        //NSLog(@"%@", snapshot.value[@"state"]);
        NSInteger state = [snapshot.value[@"state"] integerValue];
        if (state == 0) {
            
        NSString *title = snapshot.value[@"title"];
        NSString *description = snapshot.value[@"description"];
        float cost = [snapshot.value[@"cost"] floatValue];
        
        NSDictionary *addrDict = snapshot.value[@"address"];
        
        CLLocation *questerLocation = [[CLLocation alloc] initWithLatitude:[addrDict[@"latude"] floatValue] longitude:[addrDict[@"lotude"] floatValue]];
        NSInteger dist = [self getDistanceFrom:userLocation questLoc:questerLocation];
        
        
            
            
        NSString *addr1 = addrDict[@"address1"];
        NSString *addr2 = addrDict[@"address2"];
        NSString *city = addrDict[@"city"];
        NSString *state = addrDict[@"state"];
        NSInteger zip = [addrDict[@"zip"] integerValue];
        
        Quest * neQuest = [[Quest alloc] initWithData:title description:description cost:cost dist:dist user:user address1:addr1 address2:addr2 city:city state:state zipcode:zip lat:[addrDict[@"latude"] floatValue] longt:[addrDict[@"lotude"] floatValue] dict:snapshot.value];
        
        
            [self.questCollection addObject:neQuest];
        }
        
        
    }];
    
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"initial data loaded! %d", count == snapshot.childrenCount);
        [self.questTable reloadData];
    }];
    
    
    //---------JSON PARSE
    
    /*NSURL *url = [[NSURL alloc] initWithString:@"http://re-quest.herokuapp.com/available_quests"];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"JSON FAILED");
        } else {
            NSArray *listOfQuests = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]];
            
            for (NSDictionary * jsonDict in listOfQuests)
            {
                NSString *title = jsonDict[@"title"];
                NSString *description = jsonDict[@"description"];
                float cost = [jsonDict[@"cost"] floatValue];
                
                NSDictionary *addrDict = jsonDict[@"address"];
                
                CLLocation *questerLocation = [[CLLocation alloc] initWithLatitude:[addrDict[@"latude"] floatValue] longitude:[addrDict[@"lotude"] floatValue]];
                NSInteger dist = [self getDistanceFrom:userLocation questLoc:questerLocation];
                
                NSString *user = jsonDict[@"user"];
                NSString *addr1 = addrDict[@"address1"];
                NSString *addr2 = addrDict[@"address2"];
                NSString *city = addrDict[@"city"];
                NSString *state = addrDict[@"state"];
                NSInteger zip = [addrDict[@"zip"] integerValue];
                
                Quest * neQuest = [[Quest alloc] initWithData:title description:description cost:cost dist:dist user:user address1:addr1 address2:addr2 city:city state:state zipcode:zip lat:[addrDict[@"latude"] floatValue] longt:[addrDict[@"lotude"] floatValue] dict:jsonDict];
                
                [self.questCollection addObject:neQuest];
                
                
            }
            dispatch_async (dispatch_get_main_queue(), ^{
                [self.questTable reloadData];
            });
        }
    }];*/
    
    //--------------------
    
    //TEST DATA
    /*
    CLLocation *questerLocation = [[CLLocation alloc] initWithLatitude:40.113766 longitude:-88.229701];
    NSInteger dist = [self getDistanceFrom:userLocation questLoc:questerLocation];
    
    Quest * newQuest = [[Quest alloc] initWithData:@"Burrito from Chipotle" description:@"rice\nbeans\nsalsa" cost:10.00 dist:dist user:@"alex" address1:@"606 Stoughton St" address2:@"apt 101" city:@"Champaign" state:@"IL" zipcode:61820 lat:40.113766 longt:-88.229701];
    
    [self.questCollection addObject:newQuest];
    
    Quest * newQuest1 = [[Quest alloc] initWithData:@"Sandwich from Panera" description:@"rice\nbeans\nsalsa" cost:15.00 dist:dist user:@"andrew" address1:@"606 Stoughton St" address2:@"apt 101" city:@"Champaign" state:@"IL" zipcode:61820 lat:40.113766 longt:-88.229701];
    
    [self.questCollection addObject:newQuest1];
    
    Quest * newQuest2 = [[Quest alloc] initWithData:@"Tylenol from Walgreens" description:@"extra strength" cost:8.00 dist:dist user:@"mike" address1:@"606 Stoughton St" address2:@"apt 101" city:@"Champaign" state:@"IL" zipcode:61820 lat:40.113766 longt:-88.229701];
    
    [self.questCollection addObject:newQuest2];
    
    Quest * newQuest3 = [[Quest alloc] initWithData:@"Coffee from Starbucks" description:@"Iced Coffee\nlittle cream" cost:7.00 dist:dist user:@"vinu" address1:@"761 W Bloomfield Ct" address2:nil city:@"Palatine" state:@"IL" zipcode:60067 lat:40.113766 longt:-88.229701];
    
    [self.questCollection addObject:newQuest3];
    */
    
    
    [self.questTable reloadData];
    
}

-(NSInteger)getDistanceFrom:(CLLocation *)userLocation questLoc:(CLLocation*)questerLocation {
    CLLocationDistance distance = [questerLocation distanceFromLocation:userLocation];
    float distToMiles = 0.000621371*distance;
    
    return (NSInteger)distToMiles;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger selectedRow = indexPath.row;
    NSLog(@"touch on row %ld", (long)selectedRow);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.questCollection count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"questCellID";
    QuestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[QuestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Quest *currQuest = [self.questCollection objectAtIndex:indexPath.row];
    
    cell.title.text = [NSString stringWithFormat:@" %@", currQuest.qtitle];
    cell.cost.text = [NSString stringWithFormat:@"$%.02f", currQuest.qcost];
    cell.distance.text = [NSString stringWithFormat:@"%ld miles", (long)currQuest.qdistance];
    cell.viewOffer.tag = indexPath.row;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showQuest"])
    {
        QuestViewController *destViewController = (QuestViewController*)segue.destinationViewController;
        UIButton* button = (UIButton*) sender;
        long index = (long)button.tag;
        Quest *currQuest = [self.questCollection objectAtIndex:index];
        destViewController.questCollection = self.questCollection;
        destViewController.currentQuest = currQuest;
    }
}

-(BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
