//
//  ReQuestViewController.h
//  reQuest
//
//  Created by Vinu Ilangovan on 11/22/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReQuestViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField * qtitle;
@property (nonatomic, strong) IBOutlet UITextField * qcost;

@property (nonatomic, strong) IBOutlet UIButton * qstoredAddr;

@property (nonatomic, strong) IBOutlet UITextField * qaddr1;
@property (nonatomic, strong) IBOutlet UITextField * qaddr2;
@property (nonatomic, strong) IBOutlet UITextField * qcity;
@property (nonatomic, strong) IBOutlet UITextField * qstate;
@property (nonatomic, strong) IBOutlet UITextField * qzipcode;

@property (nonatomic, strong) IBOutlet UITextView * qdescription;

@property (nonatomic, strong) IBOutlet UIButton * qsubmit;

@property (nonatomic, strong) NSMutableArray *questCollection;

@end
