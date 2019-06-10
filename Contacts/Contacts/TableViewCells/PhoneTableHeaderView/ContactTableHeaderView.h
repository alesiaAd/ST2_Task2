//
//  ContactTableHeaderView.h
//  Contacts
//
//  Created by Alesia Adereyko on 10/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Section.h"

@class ContactTableHeaderView;

@protocol ContactTableHeaderViewDelegate <NSObject>

- (void)didTapOnHeader:(ContactTableHeaderView *)header;

@end

@interface ContactTableHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) id <ContactTableHeaderViewDelegate> delegate;
@property (strong, nonatomic) UILabel *alphabetLabel;
@property (strong, nonatomic) UILabel *contactsAmountLabel;
@property (strong, nonatomic) UIImageView *arrowImage;

@property (strong, nonatomic) Section *section;

- (void)setExpanded:(BOOL)expanded;

@end
