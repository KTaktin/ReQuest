//
//  QuestCell.h
//  reQuest
//
//  Created by Vinu Ilangovan on 11/22/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *cost;
@property (nonatomic, strong) IBOutlet UILabel *distance;
@property (nonatomic, strong) IBOutlet UIButton *viewOffer;


@end
