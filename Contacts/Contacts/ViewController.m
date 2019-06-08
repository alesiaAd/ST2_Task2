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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, ContactTableViewCellDelegate>

@property (strong,nonatomic) UITableView *table;
@property (nonatomic, strong) CNContactStore *contactsStore;
@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSDictionary *contactsDictionary;
@property (nonatomic, strong) NSArray *dictionaryKeys;
@property (nonatomic, strong) Contact *contact;
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
    self.contactsDictionary = [self makeDictionaryFromArray:self.contacts];
    self.dictionaryKeys = [self.contactsDictionary allKeys];
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

- (NSDictionary *)makeDictionaryFromArray:(NSMutableArray *)array {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    for (Contact *contact in array) {
        NSArray *keys = [dictionary allKeys];
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
        if (keys.count == 0) {
            [dictionary setObject:[NSMutableArray new] forKey:newKey];
            [[dictionary objectForKey:newKey] addObject:contact];
        }
        for (NSString *key in keys) {
            if ([key isEqualToString:newKey]) {
                [[dictionary objectForKey:newKey] addObject:contact];
                break;
            }
            else if ([keys indexOfObject:key] == keys.count - 1) {
                [dictionary setObject:[NSMutableArray new] forKey:newKey];
                [[dictionary objectForKey:newKey] addObject:contact];
            }
        }
    }
    return [dictionary copy];
}

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contactsDictionary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = [self.dictionaryKeys objectAtIndex:section];
    NSArray *sectionContacts = [self.contactsDictionary objectForKey:sectionTitle];
    return [sectionContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ContactTableViewCell";
    
    ContactTableViewCell *cell = (ContactTableViewCell *)[self.table dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = (ContactTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    NSString *sectionTitle = [self.dictionaryKeys objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [self.contactsDictionary objectForKey:sectionTitle];
    Contact *contact = [sectionContacts objectAtIndex:indexPath.row];
    
    cell.contact = contact;
    [cell displayContactInfo];
    cell.delegate = self;
    
    return cell;
}


#pragma mark - Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.dictionaryKeys objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = [self.dictionaryKeys objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [self.contactsDictionary objectForKey:sectionTitle];
    Contact *contact = [sectionContacts objectAtIndex:indexPath.row];
    
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
