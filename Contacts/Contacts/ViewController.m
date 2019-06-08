//
//  ViewController.m
//  Contacts
//
//  Created by Alesia Adereyko on 07/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ViewController.h"
#import "ContactTableViewCell.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *table;
@property (nonatomic, strong) CNContactStore *contactsStore;
@property (nonatomic, strong) NSMutableArray *contacts;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}

-(void)fetchAllContacts{
    
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

-(void)requestContactsAccessWithHandler:(void (^)(BOOL grandted))handler{
    
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

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ContactTableViewCell";
    
    ContactTableViewCell *cell = (ContactTableViewCell *)[self.table dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Contact *contact = (Contact *) self.contacts[indexPath.row];
    
    if(cell == nil) {
        cell = (ContactTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    cell.infoIcon.image = [UIImage imageNamed:@"infoIcon"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
