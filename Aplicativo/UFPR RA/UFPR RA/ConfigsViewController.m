//
//  ConfigsViewController.m
//  UFPR RA
//
//  Created by Roberto Beraldo Chaiben on 09/03/13.
//  Copyright (c) 2013 Roberto Beraldo Chaiben. All rights reserved.
//

#import "ConfigsViewController.h"
#import "SaveCurrentLocationViewController.h"
#import "MyLocationsViewController.h"
#import "MapViewController.h"


#define TOTAL_MENU_OPTIONS 2


@interface ConfigsViewController () <UITableViewDataSource, UITableViewDelegate, MyLocationsDelegate>
{
    __weak IBOutlet UITableView *menuTableView;
}
@end

@implementation ConfigsViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [menuTableView deselectRowAtIndexPath:[menuTableView indexPathForSelectedRow] animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


#pragma mark - StoryBoard Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"showMyLocations"] )
    {
        MyLocationsViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
    /*else if ( [segue.identifier isEqualToString:@"saveCurrentLocation"] )
    {
        SaveCurrentLocationViewController *vc = [segue destinationViewController];
        
    }*/
}



#pragma mark - UITableView Delegate/DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TOTAL_MENU_OPTIONS;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"menuOption";
    
    UITableViewCell *cell = [menuTableView dequeueReusableCellWithIdentifier:cellID];
    
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    switch ( indexPath.row )
    {
        case 0:
            // Salvar localização atual
            cell.textLabel.text = @"Salvar Localização Atual";
            break;
        
        case 1:
            // Meus Locais
            cell.textLabel.text = @"Meus Locais";
            break;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ( indexPath.row )
    {
        case 0:
            // Salvar localização atual
            [self performSegueWithIdentifier:@"saveCurrentLocation" sender:nil];
            break;
            
        case 1:
            // Meus Locais
            [self performSegueWithIdentifier:@"showMyLocations" sender:nil];
            break;
    }
}


#pragma mark - MyLocationsDelegate Methods

- (void)didSelectLocation:(CLLocationCoordinate2D)location
{
    // mover para a aba 1 e dar zoom na região
    [self.tabBarController setSelectedIndex:0];
    
    MapViewController *mapViewController = [[self.tabBarController viewControllers] objectAtIndex:0];
    [mapViewController zoomCloserToRegion:location];
}










@end
