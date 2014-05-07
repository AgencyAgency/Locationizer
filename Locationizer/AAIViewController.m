//
//  AAIViewController.m
//  Locationizer
//
//  Created by Kyle Oba on 5/6/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AAIViewController.h"

@interface AAIViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (weak, nonatomic) IBOutlet UILabel *subLocalityLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
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
        
        [self.locationManager startMonitoringSignificantLocationChanges];
        
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
//        [self.locationManager startUpdatingLocation];
        
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
    for (CLLocation *loc in locations) {
        [self grabCityFromLocation:loc];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manage did fail: %@", [error localizedDescription]);
}

- (void)updateLocationLabelsWithPlacemark:(CLPlacemark *)placemark
{
    self.subLocalityLabel.text = [placemark.addressDictionary[@"SubLocality"] description];
    self.nameLabel.text = [placemark.addressDictionary[@"Name"] description];
    self.cityLabel.text = [placemark.addressDictionary[@"City"] description];
    self.stateLabel.text = [placemark.addressDictionary[@"State"] description];
    self.countryLabel.text = [placemark.addressDictionary[@"Country"] description];
}

- (void)grabCityFromLocation:(CLLocation *)location
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && placemarks.count > 0) {
            CLPlacemark *placemark = placemarks[0];
            [self updateLocationLabelsWithPlacemark:placemark];
            
        } else if (error == nil && placemarks.count == 0) {
            NSLog(@"No results were returned.");
            
        } else if (error != nil) {
            NSLog(@"An error occurred: %@", error);
        }
    }];
}


@end
