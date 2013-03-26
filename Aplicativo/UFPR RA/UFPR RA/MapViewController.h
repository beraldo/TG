//
//  MapViewController.h
//  UFPR RA
//
//  Created by Roberto Beraldo Chaiben on 06/03/13.
//  Copyright (c) 2013 Roberto Beraldo Chaiben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController


- (void) zoomToRegion:(CLLocationCoordinate2D)location;
- (void) zoomCloserToRegion:(CLLocationCoordinate2D)location;


@end
