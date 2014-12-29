//
//  UsersViewController.m
//  reQuest
//
//  Created by Vinu Ilangovan on 11/22/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import "UsersViewController.h"

@interface UsersViewController ()

@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavBar];
    
    [self.alexButton addTarget:self action:@selector(choseAlex:) forControlEvents:UIControlEventTouchUpInside];
    [self.andrewButton addTarget:self action:@selector(choseAndrew:) forControlEvents:UIControlEventTouchUpInside];
    [self.mikeButton addTarget:self action:@selector(choseMike:) forControlEvents:UIControlEventTouchUpInside];
    [self.vinuButton addTarget:self action:@selector(choseVinu:) forControlEvents:UIControlEventTouchUpInside];
    [self.ryanButton addTarget:self action:@selector(choseRyan:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setUpNavBar {
    self.navigationItem.title = @"Choose User";
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
}

-(void)closePage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)choseAlex:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"alex" forKey:@"UserName"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1625 Trestle St" forKey:@"Address1"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Address2"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Mount Airy" forKey:@"City"];
    [[NSUserDefaults standardUserDefaults] setObject:@"MD" forKey:@"State"];
    [[NSUserDefaults standardUserDefaults] setInteger:21771 forKey:@"Zipcode"];
    
    [[NSUserDefaults standardUserDefaults] setFloat:39.369224 forKey:@"Lat"];
    [[NSUserDefaults standardUserDefaults] setFloat:-77.133978 forKey:@"Long"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRequest"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isQuest"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alerted"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self closePage:self];
}

-(void)choseAndrew:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"andrew" forKey:@"UserName"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"5219 S Kimbark Ave" forKey:@"Address1"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Address2"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Chicago" forKey:@"City"];
    [[NSUserDefaults standardUserDefaults] setObject:@"IL" forKey:@"State"];
    [[NSUserDefaults standardUserDefaults] setInteger:60615 forKey:@"Zipcode"];
    
    [[NSUserDefaults standardUserDefaults] setFloat:41.800416 forKey:@"Lat"];
    [[NSUserDefaults standardUserDefaults] setFloat:-87.594583 forKey:@"Long"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRequest"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isQuest"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alerted"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self closePage:self];
}

-(void)choseMike:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"mike" forKey:@"UserName"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"4016 Meandering Way" forKey:@"Address1"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Address2"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Crystal Lake" forKey:@"City"];
    [[NSUserDefaults standardUserDefaults] setObject:@"IL" forKey:@"State"];
    [[NSUserDefaults standardUserDefaults] setInteger:60014 forKey:@"Zipcode"];
    
    [[NSUserDefaults standardUserDefaults] setFloat:42.236572 forKey:@"Lat"];
    [[NSUserDefaults standardUserDefaults] setFloat:-88.276226 forKey:@"Long"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRequest"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isQuest"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alerted"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self closePage:self];
}

-(void)choseVinu:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"vinu" forKey:@"UserName"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"761 W Bloomfield Ct." forKey:@"Address1"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Address2"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Palatine" forKey:@"City"];
    [[NSUserDefaults standardUserDefaults] setObject:@"IL" forKey:@"State"];
    [[NSUserDefaults standardUserDefaults] setInteger:60067 forKey:@"Zipcode"];
    
    [[NSUserDefaults standardUserDefaults] setFloat:42.086258 forKey:@"Lat"];
    [[NSUserDefaults standardUserDefaults] setFloat:-88.061867 forKey:@"Long"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRequest"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isQuest"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alerted"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self closePage:self];
}

-(void)choseRyan:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"ryan" forKey:@"UserName"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"761 W Bloomfield Ct." forKey:@"Address1"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Address2"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Palatine" forKey:@"City"];
    [[NSUserDefaults standardUserDefaults] setObject:@"IL" forKey:@"State"];
    [[NSUserDefaults standardUserDefaults] setInteger:60067 forKey:@"Zipcode"];
    
    [[NSUserDefaults standardUserDefaults] setFloat:42.086258 forKey:@"Lat"];
    [[NSUserDefaults standardUserDefaults] setFloat:-88.061867 forKey:@"Long"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRequest"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isQuest"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alerted"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self closePage:self];
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
