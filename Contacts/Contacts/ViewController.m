//
//  ViewController.m
//  Contacts
//
//  Created by Alesia Adereyko on 07/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CNContactStore *contactsStore;
@property (nonatomic, strong) NSMutableArray *contacts;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
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


@end
