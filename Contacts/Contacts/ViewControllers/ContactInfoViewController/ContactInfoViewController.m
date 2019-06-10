//
//  ContactInfoViewController.m
//  Contacts
//
//  Created by Alesia Adereyko on 08/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ContactInfoViewController.h"
#import "PhoneTableViewCell.h"
#import "PhotoAndNameTableViewCell.h"

@interface ContactInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ContactInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Контакты";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[PhoneTableViewCell class] forCellReuseIdentifier:@"PhoneTableViewCell"];
    [self.tableView registerClass:[PhotoAndNameTableViewCell class] forCellReuseIdentifier:@"PhotoAndNameTableViewCell"];
    
    self.tableView.tableFooterView = [UIView new];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"arrowLeft.png"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.navigationItem.leftBarButtonItem.customView.widthAnchor constraintEqualToConstant:30].active = YES;
    [self.navigationItem.leftBarButtonItem.customView.heightAnchor constraintEqualToConstant:30].active = YES;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contact.phoneNumbers.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"PhotoAndNameTableViewCell";
        
        PhotoAndNameTableViewCell *cell = (PhotoAndNameTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = (PhotoAndNameTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        
        if (self.contact.contactImage) {
            cell.contactImage.image = self.contact.contactImage;
            cell.contactImage.contentMode = UIViewContentModeScaleAspectFill;
            cell.contactImage.layer.cornerRadius = 75;
            cell.contactImage.clipsToBounds = YES;
        }
        else {
            cell.contactImage.image = [UIImage imageNamed:@"noPhotoImage"];
        }
        cell.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.contact.lastName, self.contact.firstName];
        
        return cell;
    }
    
    else {
        static NSString *cellIdentifier = @"PhoneTableViewCell";
    
        PhoneTableViewCell *cell = (PhoneTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
        if(cell == nil) {
            cell = (PhoneTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        }
    
        cell.phoneLabel.text = self.contact.phoneNumbers[indexPath.row - 1];
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
