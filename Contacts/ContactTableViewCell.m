//
//  ContactTableViewCell.m
//  Contacts
//
//  Created by Alesia Adereyko on 08/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)displayContactInfo {
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.contact.firstName, self.contact.lastName];
    self.infoIcon.image = [UIImage imageNamed:@"infoIcon"];
    self.infoIcon.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleInfoIconTap:)];
    [self.infoIcon addGestureRecognizer:tap];
}

- (void)handleInfoIconTap:(UITapGestureRecognizer *)recognizer {
    [self.delegate showInfoControllerWithContact:self.contact];
}

@end
