//
//  MapViewController.m
//  UFPR RA
//
//  Created by Roberto Beraldo Chaiben on 06/03/13.
//  Copyright (c) 2013 Roberto Beraldo Chaiben. All rights reserved.
//


#import "Location.h"
#import "MapViewAnnotation.h"
#import "MapViewController.h"
#import "SaveCurrentLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyLocationsViewController.h"
#import "AppDelegate.h"


@interface MapViewController ()  <CLLocationManagerDelegate, MKMapViewDelegate, UIActionSheetDelegate, MyLocationsDelegate>
{
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UISegmentedControl *mapSatelliteSegControl;
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentLocation;
    BOOL hasZoomedAtStartUp;
    
    NSMutableArray *annotationsArray;
    
    UIActionSheet *actionSheet;
}

- (IBAction) actionButtonTouched:(UIBarButtonItem *)sender;
- (IBAction) mapSatelliteSegControlTouched:(UISegmentedControl *)sender;


- (void) addAnnotations;
- (void) showMyLocation;


@end

@implementation MapViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    hasZoomedAtStartUp = NO;
    
    mapView.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    
    [mapView setShowsUserLocation:YES];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setMapType:MKMapTypeStandard];
    
    [locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**
     *TODO: verificar por que, ao descomentar aqui, não funciona a seleção do marcador ao centralizar o mapa em um ponto conhecido (selecionar ponto no Meus Locais)
     */
    //[mapView removeAnnotations:annotationsArray];
    [self addAnnotations];
}

- (void)viewDidUnload
{
    [locationManager stopUpdatingLocation];
    
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


#pragma mark - Storyboard Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"showMyLocations"] )
    {
        MyLocationsViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}



#pragma mark -
#pragma mark CoreLocation Delegate Methods

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if ( hasZoomedAtStartUp == NO )
    {
        CLLocationCoordinate2D coord;
        coord.latitude = newLocation.coordinate.latitude;
        coord.longitude = newLocation.coordinate.longitude;
        
        [self zoomToRegion:coord];
        
        hasZoomedAtStartUp = YES;
    }
    
    currentLocation = newLocation.coordinate;
}


#pragma mark -
#pragma mark MapView Delegate Methods

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
}




#pragma mark -
#pragma mark MapView Helper Methods

-(void) zoomToRegion:(CLLocationCoordinate2D)location
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 200, 200);
    
    [mapView setRegion:region animated:YES];
}


-(void) zoomCloserToRegion:(CLLocationCoordinate2D)location
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 100, 100);
    
    [mapView setRegion:region animated:YES];
    
    NSLog(@"selecionando..");
    for ( MapViewAnnotation *annotation in annotationsArray )
    {
        if ( annotation.coordinate.latitude == location.latitude && annotation.coordinate.longitude == location.longitude )
        {
            NSLog(@"selecionar: %@", annotation.title);
            [mapView selectAnnotation:annotation animated:YES];
            break;
        }
    }
    
    
}



- (void) addAnnotations
{
    NSArray *savedLocations = [Location loadLocatoins];
    
    annotationsArray = [[NSMutableArray alloc] initWithCapacity:savedLocations.count];
    
    if ( [savedLocations count] > 0 )
    {
        for ( Location *l in savedLocations )
        {
            CLLocationCoordinate2D location;
            location.latitude = [[l latitude] doubleValue];
            location.longitude = [[l longitude] doubleValue];
            
            MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:[l name] coordinate:location];
            
            [mapView addAnnotation:annotation];
            [annotationsArray addObject:annotation];
        }
    }
}



#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch ( buttonIndex )
    {
        case 0:
            // mostrar localização atual
            [self showMyLocation];
            break;
            
        // salvar localização atual
        case 1:
        {
            [self performSegueWithIdentifier:@"saveCurrentLocation" sender:nil];
            break;
        }
            
        // mostra a lista de locais salvos
        case 2:
        {
            [self performSegueWithIdentifier:@"showMyLocations" sender:nil];
            
            break;
        }
    }
}





#pragma mark -
#pragma mark IBActions

- (IBAction) actionButtonTouched:(UIBarButtonItem *)sender
{
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:@"Cancelar"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:@"Mostrar Minha Localização", @"Salvar Localização Atual", @"Meus Locais Salvos", nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}


- (IBAction) mapSatelliteSegControlTouched:(UISegmentedControl *)sender
{
    if ( sender.selectedSegmentIndex == 0 )
    {
        // Mapa
        [mapView setMapType:MKMapTypeStandard];
    }
    else
    {
        // Satélite
        [mapView setMapType:MKMapTypeSatellite];
    }
}



#pragma mark - MyLocationsDelegate Methods

- (void)didSelectLocation:(CLLocationCoordinate2D)location
{
    [self zoomCloserToRegion:location];
}


#pragma mark - Other Methods

- (void) showMyLocation
{
    CLLocationCoordinate2D coord;
    coord.latitude  = mapView.userLocation.coordinate.latitude;
    coord.longitude = mapView.userLocation.coordinate.longitude;
    
    [self zoomToRegion:coord];
}










@end
