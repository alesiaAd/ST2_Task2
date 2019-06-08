//
//  ContactTableViewCell.h
//  Contacts
//
//  Created by Alesia Adereyko on 08/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@class ContactTableViewCell;
@protocol ContactTableViewCellDelegate <NSObject>

- (void) showInfoControllerWithContact: (Contact *)contact;

@end

@interface ContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoIcon;
@property (nonatomic, strong) Contact *contact;

@property (nonatomic, weak) id <ContactTableViewCellDelegate> delegate;

- (void) displayContactInfo;

@end

