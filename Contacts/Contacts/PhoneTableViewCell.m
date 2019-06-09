//
//  PhoneTableViewCell.m
//  Contacts
//
//  Created by Alesia Adereyko on 09/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "PhoneTableViewCell.h"

@implementation PhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.phoneLabel = [UILabel new];
        [self addSubview:self.phoneLabel];
        self.phoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.phoneLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
                                                  [self.phoneLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
                                                  [self.phoneLabel.heightAnchor constraintEqualToConstant:44],
                                                  [self.phoneLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
                                                  ]
         ];
    }
    return self;
}

@end
