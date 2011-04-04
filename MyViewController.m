//
//  MyViewController.m
//  Test
//
//  Created by Malcom Gilbert on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyViewController.h"


@implementation MyViewController
@synthesize textField;
@synthesize label;
@synthesize userName;
@synthesize connection;
@synthesize connectionData;
@synthesize startDate;
@synthesize initDate;
@synthesize tenSecCount;
@synthesize startLength;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{    [userName release];
    [textField release];
    [label release];
    [connection release];
    [connectionData release];
    [tenSecCount release];
    [startLength release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.connection cancel]; 
    self.connection = nil; 
    self.connectionData = nil;
    self.startDate = nil; 
    self.initDate = nil;
    self.tenSecCount = [NSNumber numberWithInt:1];
    self.startLength = [NSNumber numberWithInt:0];
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)changeGreeting:(id)sender {
    NSString *urlAsString = @"http://web.mit.edu/21w.789/www/papers/griswold2004.pdf";
    //NSString *urlAsString = @"http://web.mit.edu/jeanneyu/Public/C-Show%20Sophomore%20Dance.MP4";
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // place to store the data
    NSMutableData *data = [[NSMutableData alloc] init]; 
    self.connectionData = data;
    [data release];
    
    NSURLConnection *newConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    self.connection = newConnection;
    [newConnection release];
    
    if (self.connection != nil) {
        //NSLog(@"successfully connected");
        self.initDate = [NSDate date];
        //NSLog(@"Connection initialized at %@",self.initDate);
    }
        else {
            NSLog(@"could not connect");
        }
}

- (BOOL) textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == textField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)	connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"An error happened"); NSLog(@"%@", error);
}


- (void)	connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (self.startDate == nil) {
        self.startDate = [NSDate date];
        //NSLog(@"First Data recieved at %@",self.startDate);
        NSTimeInterval test2 = [self.startDate timeIntervalSinceDate:self.initDate];
        NSLog(@"Latency =  %0.9f seconds",test2);
    }
    [self.connectionData appendData:data];
    if (floor(-[self.startDate timeIntervalSinceNow]/10) == self.tenSecCount.intValue) {
        //NSLog(@"Interval %d : Starting Bytes: %d Ending Bytes: %d Throughput(Bytes/sec): %d",self.tenSecCount.intValue, self.startLength.intValue, [self.connectionData length], (([self.connectionData length] - self.startLength.intValue)/10));
        NSLog(@"Interval %d : Throughput(Bytes/sec): %d",self.tenSecCount.intValue, (([self.connectionData length] - self.startLength.intValue)/10));
        NSNumber *increment = [NSNumber numberWithInt:(self.tenSecCount.intValue + 1)];
        self.tenSecCount = increment;
        self.startLength = [NSNumber numberWithInt:[self.connectionData length]];
    }
}

- (void)	connectionDidFinishLoading :(NSURLConnection *)connection{
    NSLog(@"Successfully downloaded the contents of the URL.");
    NSDate *timeFinished = [NSDate date];
    NSLog(@"Total Time taken: %f", -[timeFinished timeIntervalSinceNow]);
    NSLog(@"Average Throughput = %.0f", ([self.connectionData length])/(-[timeFinished timeIntervalSinceNow]));
    /* do something with the data here */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingString:@"21w.pdf"];
    NSURL *filepath = [NSURL fileURLWithPath:path];
    [self.connectionData writeToURL:filepath atomically:YES];
} 

- (void)	connection:(NSURLConnection *)connection
   didReceiveResponse:(NSURLResponse *)response{ [self.connectionData setLength:0];
}


@end
