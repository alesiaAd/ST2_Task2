//
//  ViewController.m
//  Contacts
//
//  Created by Alesia Adereyko on 07/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ViewController.h"
#import "ContactTableViewCell.h"
#import "ContactInfoViewController.h"
#import "Section.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, ContactTableViewCellDelegate>

@property (strong,nonatomic) UITableView *table;
@property (nonatomic, strong) CNContactStore *contactsStore;
@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSArray *sections;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Контакты";
    
    self.table = [UITableView new];
    [self.view addSubview:self.table];
    self.table.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (@available(iOS 11.0, *)) {
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.table.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                                  [self.table.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                                  [self.table.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                                  [self.table.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                                  ]
         ];
    } else {
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.table.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                                  [self.table.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                                  [self.table.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                                  [self.table.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
                                                  ]
         ];
    }
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"ContactTableViewCell" bundle:nil];
    [self.table registerNib:nib forCellReuseIdentifier:@"ContactTableViewCell"];
    
    self.contactsStore = [[CNContactStore alloc] init];
    self.contacts = [NSMutableArray new];
    [self fetchAllContacts];

    self.sections = [self makeArrayOfSections:self.contacts];
}

- (void)fetchAllContacts {
    
    [self requestContactsAccessWithHandler:^(BOOL grandted) {
        
        if (grandted) {
            
            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey]];
            [self.contactsStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                
                Contact *newContact = [Contact new];
                newContact.firstName = contact.givenName;
                newContact.lastName = contact.familyName;
                newContact.phoneNumbers = [NSMutableArray new];
                
                for (CNLabeledValue *label in contact.phoneNumbers)
                {
                    NSString *phone = [label.value stringValue];
                    if ([phone length] > 0)
                    {
                        [newContact.phoneNumbers addObject:phone];
                    }
                }
                
                UIImage *image = [UIImage imageWithData:contact.imageData];
                newContact.contactImage = image;
                
                [self.contacts addObject:newContact];
            }];
        }
    }];
}

- (void)requestContactsAccessWithHandler:(void (^)(BOOL grandted))handler {
    
    switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]) {
        case CNAuthorizationStatusAuthorized:
            handler(YES);
            break;
        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusNotDetermined:{
            [self.contactsStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                handler(granted);
            }];
            break;
        }
        case CNAuthorizationStatusRestricted:
            handler(NO);
            break;
    }
}

- (NSArray *)makeArrayOfSections:(NSArray *)array {
    NSMutableArray *arrayOfSections = [NSMutableArray new];
    for (Contact *contact in array) {
        NSString *newKey = [NSString new];
        if (contact.lastName.length > 0 && [[NSCharacterSet letterCharacterSet] characterIsMember: [contact.lastName characterAtIndex:0]] == YES) {
            newKey = [contact.lastName substringToIndex:1];
        }
        else if (contact.firstName.length > 0 && [[NSCharacterSet letterCharacterSet] characterIsMember: [contact.firstName characterAtIndex:0]] == YES) {
            newKey = [contact.firstName substringToIndex:1];
        }
        else {
            newKey = @"#";
        }
        if (arrayOfSections.count == 0) {
            Section *section = [Section new];
            section.title = newKey;
            section.expanded = YES;
            section.contacts = [NSMutableArray new];
            [section.contacts addObject:contact];
            [arrayOfSections addObject:section];
        }
        for (Section *sectionItem in arrayOfSections) {
            if ([sectionItem.title isEqualToString:newKey]) {
                [sectionItem.contacts addObject:contact];
                break;
            }
            else if ([arrayOfSections indexOfObject:sectionItem] == arrayOfSections.count - 1) {
                Section *section = [Section new];
                section.title = newKey;
                section.expanded = YES;
                section.contacts = [NSMutableArray new];
                [section.contacts addObject:contact];
                [arrayOfSections addObject:section];
            }
        }
    }
    return [arrayOfSections copy];
}

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Section *sect = (Section *)self.sections[section];
    return [sect.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ContactTableViewCell";
    
    ContactTableViewCell *cell = (ContactTableViewCell *)[self.table dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = (ContactTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    Section *section = (Section *)self.sections[indexPath.section];
    Contact *contact = section.contacts[indexPath.row];
    
    cell.contact = contact;
    [cell displayContactInfo];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Section *sect = (Section *)self.sections[section];
    return sect.title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Section *section = (Section *)self.sections[indexPath.section];
    Contact *contact = section.contacts[indexPath.row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:[NSString stringWithFormat:@"Контакт %@ %@, номер телефона %@", contact.firstName, contact.lastName, contact.phoneNumbers[0]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ContactTableViewCellDelegate

-(void)showInfoControllerWithContact:(Contact *)contact {
    ContactInfoViewController *vc = [[ContactInfoViewController alloc] initWithNibName:@"ContactInfoViewController" bundle:nil];
    vc.contact = contact;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
