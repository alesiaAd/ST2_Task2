//
//  ContactInfoViewController.m
//  Contacts
//
//  Created by Alesia Adereyko on 08/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ContactInfoViewController.h"

@interface ContactInfoViewController ()

@end

@implementation ContactInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.contact.contactImage) {
        self.contactImage.image = self.contact.contactImage;
        self.contactImage.contentMode = UIViewContentModeScaleAspectFill;
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.width / 2;
        self.contactImage.clipsToBounds = YES;
    }
    else {
        self.contactImage.image = [UIImage imageNamed:@"noPhotoImage"];
    }
    
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.contact.firstName, self.contact.lastName];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
