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
    self.layer.borderColor = [UIColor colorWithRed:0xDF/255.0f
                                             green:0xDF/255.0f
                                              blue:0xDF/255.0f alpha:1].CGColor;
    UIView *view =[UIView new];
    view.backgroundColor = [UIColor colorWithRed:0xFE/255.0f
                                           green:0xF6/255.0f
                                            blue:0xF6/255.0f alpha:1];
    self.selectedBackgroundView = view;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)displayContactInfo {
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.contact.lastName, self.contact.firstName];
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
