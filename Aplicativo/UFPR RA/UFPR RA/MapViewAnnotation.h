//
//  MapViewAnnotation.h
//  MapsTest
//
//  Created by Roberto  Beraldo Chaiben on 25/02/12.
//  Copyright (c) 2012 C3SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>


@property (nonatomic, copy) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id) initWithTitle:(NSString *)t coordinate:(CLLocationCoordinate2D)c;

@end
