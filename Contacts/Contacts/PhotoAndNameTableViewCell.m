//
//  PhotoAndNameTableViewCell.m
//  Contacts
//
//  Created by Alesia Adereyko on 10/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "PhotoAndNameTableViewCell.h"

@implementation PhotoAndNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contactImage = [UIImageView new];
        [self addSubview:self.contactImage];
        self.contactImage.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.contactImage.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                                  [self.contactImage.heightAnchor constraintEqualToConstant:150],
                                                  [self.contactImage.widthAnchor constraintEqualToAnchor:self.contactImage.heightAnchor multiplier:1],
                                                  [self.contactImage.topAnchor constraintEqualToAnchor:self.topAnchor constant:50]
                                                  ]
         ];
        
        self.fullNameLabel = [UILabel new];
        [self.fullNameLabel sizeToFit];
        [self addSubview:self.fullNameLabel];
        self.fullNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.fullNameLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                                  [self.fullNameLabel.heightAnchor constraintEqualToConstant:50],
                                                  [self.fullNameLabel.topAnchor constraintEqualToAnchor:self.contactImage.bottomAnchor constant:20],
                                                  [self.fullNameLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-20]
                                                  ]
         ];
    }
    return self;
}

@end
