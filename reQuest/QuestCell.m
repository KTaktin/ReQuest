//
//  QuestCell.m
//  reQuest
//
//  Created by Vinu Ilangovan on 11/22/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import "QuestCell.h"

@implementation QuestCell

- (void)awakeFromNib {
    // Initialization code
    self.viewOffer.layer.cornerRadius = 5;
    self.viewOffer.clipsToBounds = YES;
    
    self.title.layer.cornerRadius = 5;
    self.title.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
