//
//  AugmentedRealityViewController.m
//  UFPR RA
//
//  Created by Roberto Beraldo Chaiben on 06/03/13.
//  Copyright (c) 2013 Roberto Beraldo Chaiben. All rights reserved.
//

#import "AugmentedRealityViewController.h"
#import "iPhone-AR-Toolkit/ARKit.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "MarkerView.h"
#import "ContentManager.h"
#import "Location.h"

@interface AugmentedRealityViewController () <ARLocationDelegate,ARDelegate,ARMarkerDelegate>
{
    AugmentedRealityController  *arc;
}

@property (nonatomic, retain) UIViewController *infoViewController;
@property (weak, nonatomic) IBOutlet UIView *arView;


- (void) displayAR;
- (void)addGeoLocationtoArray:(NSMutableArray*)locArray withLatitude:(float)latitude Longitude:(float)longitude usingName:(NSString*)label;


@end



@implementation AugmentedRealityViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self displayAR];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self displayAR];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}



- (void)notSupportView
{
    UIViewController *newInfoViewController = [[UIViewController alloc] init];
    [self setInfoViewController:newInfoViewController];
    
    UILabel *errorLabel = [[UILabel alloc] init];
    [errorLabel setNumberOfLines:0];
    [errorLabel setText: @"Augmented Reality is not supported on this device"];
    [errorLabel setFrame: [[_infoViewController view] bounds]];
    [errorLabel setTextAlignment:NSTextAlignmentCenter];
    [[_infoViewController view] addSubview:errorLabel];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    
    [closeButton setBackgroundColor:[UIColor blueColor]];
    [closeButton addTarget:self action:@selector(closeNotSupportedView:) forControlEvents:UIControlEventTouchUpInside];
    [[_infoViewController view] addSubview:closeButton];
    
    [self.view addSubview:[_infoViewController view]];
}

- (void) populateGeoLocations
{
    GEOLocations* locations = [[GEOLocations alloc] initWithDelegate:self];
    
    if ([[locations returnLocations] count] > 0)
    {
        for (ARGeoCoordinate *coordinate in [locations returnLocations])
        {
            NSLog(@"location: %fx%f: distance: %f", coordinate.geoLocation.coordinate.latitude, coordinate.geoLocation.coordinate.longitude, coordinate.distanceFromOrigin);
            
            
            
            MarkerView *cv = [[MarkerView alloc] initForCoordinate:coordinate withDelgate:self] ;
            [coordinate setDisplayView:cv];
            
            [arc addCoordinate:coordinate];
        }
    }
}

- (void) displayAR
{
    if ([ARKit deviceSupportsAR])
    {
        arc = [[AugmentedRealityController alloc] initWithView:[self arView] parentViewController:self withDelgate:self];
        
        //[arc setDebugMode:[[ContentManager sharedContentManager] debugMode]];
        [arc setDebugMode:NO];
        //[arc setScaleViewsBasedOnDistance:[[ContentManager sharedContentManager] scaleOnDistance]];
        [arc setScaleViewsBasedOnDistance:NO];
        [arc setMinimumScaleFactor:0.5];
        [arc setRotateViewsBasedOnPerspective:YES];
        //[arc updateDebugMode:![arc debugMode]];
        
        /*
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        
        [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
        
        [closeBtn setBackgroundColor:[UIColor greenColor]];
        [closeBtn addTarget:self action:@selector(clearARView:) forControlEvents:UIControlEventTouchUpInside];
        [[self arView] addSubview:closeBtn];
        */
        
        [self populateGeoLocations];
    }
    else
    {
        [self notSupportView];
    }
    
}





- (IBAction)closeNotSupportedView:(id)sender
{
    [[[self infoViewController] view] removeFromSuperview];
    _infoViewController = nil;
}



- (IBAction)closeButtonClicked:(id)sender
{
    [[[self infoViewController] view] removeFromSuperview];
    _infoViewController = nil;
}

- (IBAction)clearARView:(id)sender {
    
    [arc unloadAV];
    [[[self arView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    arc = nil;
}



-(void) locationClicked:(ARGeoCoordinate *) coordinate {
    
    if (coordinate != nil) {
        NSLog(@"Main View Controller received the click Event for: %@",[coordinate title]);
        
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        UIViewController *infovc = [[UIViewController alloc] init];
        
        UILabel *errorLabel = [[UILabel alloc] init];
        [errorLabel setNumberOfLines:0];
        [errorLabel setText: [NSString stringWithFormat:@"You clicked on %@ and distance is %.2f km",[coordinate title], [coordinate distanceFromOrigin]/1000.0f]];
        [errorLabel setFrame: [[infovc view] bounds]];
        [errorLabel setTextAlignment:NSTextAlignmentCenter];
        [[infovc view] addSubview:errorLabel];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        
        [closeButton setBackgroundColor:[UIColor blueColor]];
        [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [[infovc view] addSubview:closeButton];
        
        [[appDelegate window] addSubview:[infovc view]];
        
        [self setInfoViewController:infovc];
    }
}

-(void) didTapMarker:(ARGeoCoordinate *) coordinate {
    NSLog(@"delegate worked click on %@", [coordinate title]);
    [self locationClicked:coordinate];
    
}

-(void) didUpdateHeading:(CLHeading *)newHeading {
    //   NSLog(@"Heading Updated");
    
}
-(void) didUpdateLocation:(CLLocation *)newLocation
{
    //NSLog(@"Location Updated");
}

-(void) didUpdateOrientation:(UIDeviceOrientation) orientation
{
    //NSLog(@"Orientation Updated");
    
    if (orientation == UIDeviceOrientationPortrait)
        NSLog(@"Protrait");
}


- (void)addGeoLocationtoArray:(NSMutableArray*)locArray withLatitude:(float)latitude Longitude:(float)longitude usingName:(NSString*)label
{
    
    CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    ARGeoCoordinate *tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:label];
    
    NSLog(@"addGeoLocationtoArray: %@ (%fx%f)", label, latitude, longitude);
    
    [locArray addObject:tempCoordinate];
}



-(NSMutableArray*) geoLocations
{
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    
//    [self addGeoLocationtoArray:locationArray withLatitude:39.550051 Longitude:-105.782067 usingName:@"Denver"];
//    [self addGeoLocationtoArray:locationArray withLatitude:45.523875 Longitude:-122.670399 usingName:@"Portland"];
//    [self addGeoLocationtoArray:locationArray withLatitude:41.879535 Longitude:-87.624333 usingName:@"Chicago"];
//    [self addGeoLocationtoArray:locationArray withLatitude:30.268735 Longitude:-97.745209 usingName:@"Austin"];
//    [self addGeoLocationtoArray:locationArray withLatitude:51.500152 Longitude:-0.126236 usingName:@"London"];
//    [self addGeoLocationtoArray:locationArray withLatitude:48.856667 Longitude:2.350987 usingName:@"Paris"];
//    [self addGeoLocationtoArray:locationArray withLatitude:55.676294 Longitude:12.568116 usingName:@"Copenhagen"];
//    [self addGeoLocationtoArray:locationArray withLatitude:52.373801 Longitude:4.890935 usingName:@"Amsterdam"];
//    [self addGeoLocationtoArray:locationArray withLatitude:40.756054 Longitude:-73.986951 usingName:@"New York City"];
//    [self addGeoLocationtoArray:locationArray withLatitude:45.545447 Longitude:-73.639076 usingName:@"Montreal"];
//    [self addGeoLocationtoArray:locationArray withLatitude:32.78 Longitude:-117.15 usingName:@"San Diego"];
//    [self addGeoLocationtoArray:locationArray withLatitude:53.566667 Longitude:-113.516667 usingName:@"Edmonton"];
//    [self addGeoLocationtoArray:locationArray withLatitude:19.26 Longitude:-99.8 usingName:@"Mexico City"];
//    [self addGeoLocationtoArray:locationArray withLatitude:47.620973 Longitude:-122.347276 usingName:@"Seattle"];
    
    
    NSArray *myLocations = [Location loadLocatoins];
    
    for ( Location *l in myLocations )
    {
        NSString *name = l.name;
        float latitude = [l.latitude floatValue];
        float longitude = [l.longitude floatValue];
        
        //NSLog(@"add ao array: %@ (%fx%f)", name, latitude, longitude);
        
        [self addGeoLocationtoArray:locationArray withLatitude:latitude Longitude:longitude usingName:name];
    }
    
    
    return locationArray;
}
















@end
