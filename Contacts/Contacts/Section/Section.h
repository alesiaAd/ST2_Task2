//
//  Section.h
//  Contacts
//
//  Created by Alesia Adereyko on 09/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject

@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL expanded;

@end
