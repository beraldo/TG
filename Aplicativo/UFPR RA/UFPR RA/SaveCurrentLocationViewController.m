#import "SaveCurrentLocationViewController.h"

@interface SaveCurrentLocationViewController () <CLLocationManagerDelegate>
{
    __weak IBOutlet UITextField *locationName;
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentLocation;
}

- (IBAction) cancelSaveAction;
- (IBAction) saveLocation;


@end



@implementation SaveCurrentLocationViewController


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
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    
    [locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidUnload
{
    [locationManager stopUpdatingLocation];
    
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


#pragma mark - IBActions

- (IBAction) cancelSaveAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) saveLocation
{
    float currentLatitude = (float) currentLocation.latitude;
    float currentLongitude = (float) currentLocation.longitude;
    
    NSString *strLocationName = [locationName text];
    
    NSLog(@"Salvando '%@', nas coordenadas (%f,%f)", strLocationName, currentLatitude, currentLongitude);
    
    [Location saveLocation:strLocationName latitude:currentLatitude longitude:currentLongitude];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark CoreLocation Delegate Methods

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation.coordinate;
}





@end




