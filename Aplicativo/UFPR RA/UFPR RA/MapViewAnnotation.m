//
//  MapViewAnnotation.m
//  MapsTest
//
//  Created by Roberto  Beraldo Chaiben on 25/02/12.
//  Copyright (c) 2012 C3SL. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title, coordinate;


- (id) initWithTitle:(NSString *)t coordinate:(CLLocationCoordinate2D)c
{
    self.title = t;
    self.coordinate = c;
    
    return self;
}

@end
