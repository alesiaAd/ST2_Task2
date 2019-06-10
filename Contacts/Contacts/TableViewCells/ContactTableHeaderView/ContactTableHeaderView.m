//
//  PhoneTableHeaderView.m
//  Contacts
//
//  Created by Alesia Adereyko on 10/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ContactTableHeaderView.h"

@implementation ContactTableHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.textLabel.hidden = YES;
        self.backgroundColor = [UIColor colorWithRed:0xF9/255.0f
                                                     green:0xF9/255.0f
                                                      blue:0xF9/255.0f alpha:1];
        self.layer.borderColor = [UIColor colorWithRed:0xDF/255.0f
                                                       green:0xDF/255.0f
                                                        blue:0xDF/255.0f alpha:1].CGColor;
        [self.heightAnchor constraintEqualToConstant:60].active = YES;
        
        self.alphabetLabel = [UILabel new];
        [self.alphabetLabel setFont:[UIFont boldSystemFontOfSize:17]];
        self.alphabetLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.alphabetLabel];
        
        self.contactsAmountLabel = [UILabel new];
        [self.contactsAmountLabel setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightLight]];
        self.contactsAmountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.contactsAmountLabel];
        
        self.arrowImage = [UIImageView new];
        self.arrowImage.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.arrowImage];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.alphabetLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:25],
            [self.alphabetLabel.widthAnchor constraintEqualToConstant:20],
            [self.alphabetLabel.heightAnchor constraintEqualToConstant:44],
            [self.alphabetLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
            ]];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.contactsAmountLabel.leadingAnchor constraintEqualToAnchor:self.alphabetLabel.trailingAnchor constant:10],
            [self.contactsAmountLabel.trailingAnchor constraintEqualToAnchor:self.arrowImage.leadingAnchor constant:-20],
            [self.contactsAmountLabel.heightAnchor constraintEqualToAnchor:self.alphabetLabel.heightAnchor multiplier:1],
            [self.contactsAmountLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
            ]];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.arrowImage.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
            [self.arrowImage.heightAnchor constraintEqualToConstant:20],
            [self.arrowImage.widthAnchor constraintEqualToAnchor:self.arrowImage.heightAnchor multiplier:1],
            [self.arrowImage.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
            ]];
        [self setExpanded:YES];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTapped:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)sectionTapped:(UITapGestureRecognizer *)recognizer {
    if (self.delegate) {
        [self.delegate didTapOnHeader:self];
    }
}

- (void)setExpanded:(BOOL)expanded {
    if (expanded) {
        self.arrowImage.image = [UIImage imageNamed:@"arrowDown"];
        self.alphabetLabel.textColor = [UIColor blackColor];
        self.contactsAmountLabel.textColor = [UIColor grayColor];
        
    }
    else {
        self.arrowImage.image = [UIImage imageNamed:@"arrowUp"];
        self.alphabetLabel.textColor = [UIColor colorWithRed:0xD9/255.0f
                                               green:0x91/255.0f
                                                blue:0x00/255.0f alpha:1];
        self.contactsAmountLabel.textColor = [UIColor colorWithRed:0xD9/255.0f
                                                        green:0x91/255.0f
                                                         blue:0x00/255.0f alpha:1];
    }
}

- (void)setSection:(Section *)section {
    _section = section;
    self.alphabetLabel.text = section.title;
    self.contactsAmountLabel.text = [NSString stringWithFormat:@"контактов: %lu", (unsigned long)section.contacts.count];
}

@end
