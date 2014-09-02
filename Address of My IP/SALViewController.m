//
//  SALViewController.m
//  Address of My IP
//
//  Created by Salman Khan on 8/26/14.
//  Copyright (c) 2014 Codiodes. All rights reserved.
//

#import "SALViewController.h"
#import "SALIPLocationFinder.h"
#import "SALAppConstants.h"

@interface SALViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtFieldIPAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UILabel *txtFieldResult;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;
@property (strong, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *ipLabel;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;

@property NSDictionary *jsonDataDictionary;

- (IBAction)onCheckButtonClick:(UIButton *)sender;
@end

NSString *txtFieldInput;

@implementation SALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(parseData:)
                                                name:kcNotificationResponseData
                                              object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kcNotificationResponseData object:nil];
}

/**
 *  Takes the data from notification and parse it NSDictionary
 *
 *  @param notification notification with JSON Data
 */
- (void) parseData:(NSNotification*)notification
{
    NSError *error = nil;
    NSDictionary *userInfoDictionary = [[NSDictionary alloc]initWithDictionary:[notification userInfo]];
    NSMutableData *jsonData = [userInfoDictionary objectForKey:kcDictionayKeyResponseData];
    self.jsonDataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    NSLog(@"%@",self.jsonDataDictionary);
    [self displayData:self.jsonDataDictionary];
}

/**
 *  Takes the NSDictionary Object and sets the label and hides the keyboard
 *
 *  @param json JSON data in NSDictionary format
 */
- (void) displayData:(NSDictionary*)json
{
    NSLog(@"%@",json);
    self.countryLabel.text = [json objectForKey:@"country_name"];
    self.countryCodeLabel.text = [json objectForKey:@"country_code"];
    self.ipLabel.text = [json objectForKey:@"ip"];
    self.latitudeLabel.text = @([[json objectForKey:@"latitude"] intValue]).stringValue;
    self.longitudeLabel.text = @([[json objectForKey:@"longitude"] intValue]).stringValue;
    
    self.txtFieldIPAddress.delegate = self;
    [self.view endEditing:YES];
}

/**
 *  Initializes the SALIPLocationFinder Class and gets the JSON Data
 *
 *  @param sender button attributes
 */
- (IBAction)onCheckButtonClick:(UIButton *)sender
{
    // Get IP Address from User
    SALIPLocationFinder *dataModel = [[SALIPLocationFinder alloc] initWithIPAddress:[self.txtFieldIPAddress text]];
}
@end
