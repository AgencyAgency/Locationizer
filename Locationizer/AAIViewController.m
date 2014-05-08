//
//  AAIViewController.m
//  Locationizer
//
//  Created by Kyle Oba on 5/6/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AAIViewController.h"
#import "NSArray+PDCUtils.h"

@interface AAIViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (weak, nonatomic) IBOutlet UILabel *subLocalityLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@end

@implementation AAIViewController

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
//        [self.locationManager startMonitoringSignificantLocationChanges];
        
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        [self.locationManager startUpdatingLocation];
        
    } else {
        /* Location services are not enabled.
           Take appropriate action: for instance, prompt the
           user to enable the location services */
        NSLog(@"Location services are not enabled.");
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"did update locations: %@", locations);
    CLLocation *firstLocation = [locations firstObject];
    if (firstLocation) {
        [self displayInfoFromLocation:firstLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWitCLhError:(NSError *)error
{
    NSLog(@"Location manage did fail: %@", [error localizedDescription]);
}

- (void)updateLocationLabelsWithLocationInfo:(NSDictionary *)locationInfo
{
    self.subLocalityLabel.text = locationInfo[@"sublocality"];
    self.nameLabel.text = locationInfo[@"name"];
    self.cityLabel.text = locationInfo[@"city"];
    self.stateLabel.text = locationInfo[@"state"];
    self.countryLabel.text = locationInfo[@"country"];
    self.latLabel.text = [NSString stringWithFormat:@"%0.2f", [locationInfo[@"latitude"] floatValue]];
    self.longLabel.text = [NSString stringWithFormat:@"%0.2f", [locationInfo[@"longitude"] floatValue]];
    
}

- (void)displayInfoFromLocation:(CLLocation *)location
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSDictionary *locInfo = @{};
        
        if (error == nil && placemarks.count > 0) {
            CLPlacemark *placemark = placemarks[0];
            locInfo = @{
                        @"sublocality":[placemark.addressDictionary[@"SubLocality"] description],
                        @"name":[placemark.addressDictionary[@"Name"] description],
                        @"city":[placemark.addressDictionary[@"City"] description],
                        @"state":[placemark.addressDictionary[@"State"] description],
                        @"country":[placemark.addressDictionary[@"Country"] description],
                        @"latitude": @(location.coordinate.latitude),
                        @"longitude": @(location.coordinate.longitude)
                        };
            
        } else if (error == nil && placemarks.count == 0) {
            NSLog(@"No results were returned.");
            
        } else if (error != nil) {
            NSLog(@"An error occurred: %@", error);
        }
        
        [self updateLocationLabelsWithLocationInfo:locInfo];
    }];
}


@end
