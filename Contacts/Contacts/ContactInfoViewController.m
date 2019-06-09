//
//  ContactInfoViewController.m
//  Contacts
//
//  Created by Alesia Adereyko on 08/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ContactInfoViewController.h"
#import "PhoneTableViewCell.h"

@interface ContactInfoViewController () <UITableViewDelegate, UITableViewDataSource>

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[PhoneTableViewCell class] forCellReuseIdentifier:@"PhoneTableViewCell"];
}

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contact.phoneNumbers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PhoneTableViewCell";
    
    PhoneTableViewCell *cell = (PhoneTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = (PhoneTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    cell.phoneLabel.text = self.contact.phoneNumbers[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
