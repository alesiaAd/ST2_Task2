//
//  ContactTableViewCell.h
//  Contacts
//
//  Created by Alesia Adereyko on 08/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoIcon;

@end

