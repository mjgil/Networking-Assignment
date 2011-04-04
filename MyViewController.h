//
//  MyViewController.h
//  Test
//
//  Created by Malcom Gilbert on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyViewController : UIViewController <UITextFieldDelegate> {
    UITextField *textField;
    UILabel *label;
    NSString *userName;
    NSURLConnection *connection;
    NSMutableData *connectionData;
    NSDate *startDate;
    NSDate *initDate;
    NSNumber *tenSecCount;
    NSNumber *startLength;
}

- (IBAction)changeGreeting:(id)sender;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *connectionData;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *initDate;
@property (nonatomic, retain) NSNumber *tenSecCount;
@property (nonatomic, retain) NSNumber *startLength;

@end
NSMutableData *connectionData;
