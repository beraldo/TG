#import "MyLocationsViewController.h"

@implementation MyLocationsViewController


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    locations = [[NSMutableArray alloc] initWithArray:[Location loadLocatoins]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableView Delegate/DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"locationCell";
    
    UITableViewCell *cell = [_locationsTableView dequeueReusableCellWithIdentifier:cellID];
    
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSUInteger totalLocations = [locations count];
    NSUInteger row = [indexPath row];
    
    if ( totalLocations <= 0 )
    {
        //TODO mostrar uma view com "Nenhum local"
        cell.textLabel.text = @"Nenhum local salvo";
    }
    else
    {
        Location *locationAtRow = [locations objectAtIndex:row];
        cell.textLabel.text = [locationAtRow name];
    }
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location *l = [locations objectAtIndex:[indexPath row]];
    
    CLLocationCoordinate2D coord;
    coord.latitude = [[l latitude] doubleValue];
    coord.longitude = [[l longitude] doubleValue];
    
    
    [_delegate didSelectLocation:coord];
    
    [self closeWindow];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObjectID *locID = [[locations objectAtIndex:[indexPath row]] locationID];
        
        if ( [Location removeLocation:locID] )
        {
            NSLog(@"Localização removida removida");
            [locations removeObjectAtIndex: [indexPath row] ];
            [self.locationsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }  
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    return @"Apagar";
}



// permite fazer swipe para mostrar editar
-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}








#pragma mark - IBActions

- (IBAction) closeWindow
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction) editAction
{
    NSLog(@"EDITANDO...");
    [super setEditing:YES animated:YES];
    [self.locationsTableView setEditing:YES animated:YES];
}



@end








