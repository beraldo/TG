//
//  SplashScreenViewController.m
//  UFPR RA
//
//  Created by Roberto Beraldo Chaiben on 02/03/13.
//  Copyright (c) 2013 Roberto Beraldo Chaiben. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "AppDelegate.h"
#import "Common.h"
#import "Location.h"

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController


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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showRateAppDialog];
    
    [self performSegueWithIdentifier:@"exitSplashScreen" sender:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


#pragma mark - First Core Data Load

/**
 * Carrega no Core Data os dados iniciais dos pontos de interesse
 */
- (void) loadInitialCoreDataInfo
{
    // array com os arquivos PLIST que devem ser carregados no Core Data
    NSArray *plistFiles = @[@{@"basename" : @"places_politecnico", @"extension" : @"plist"}];
    
    for ( NSDictionary *plistDict in plistFiles )
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:plistDict[@"basename"] ofType:plistDict[@"extension"]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ( ! [fileManager fileExistsAtPath:path] )
        {
            NSLog(@"Arquivo '%@' não existe", path);
            continue;
        }
        
        NSArray *locations = [NSArray arrayWithContentsOfFile:path];
        
        for ( NSDictionary *locationDict in locations )
        {
            NSString *name = locationDict[@"name"];
            NSNumber *latitude = locationDict[@"latitude"];
            NSNumber *longitude = locationDict[@"longitude"];
            
            [Location saveLocation:name latitude:[latitude floatValue] longitude:[longitude floatValue]];
        }
    }
}


#pragma mark - Rate App Methods

- (void) showRateAppDialog
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSUInteger totalOfLaunches = [userDefaults integerForKey:TOTAL_OF_APP_LAUNCHES_KEY];
    BOOL didUserRateApp = [userDefaults boolForKey:DID_USER_RATE_APP_KEY];
    BOOL shouldShowDialog = [userDefaults boolForKey:SHOULD_SHOW_RATE_APP_DIALOG_KEY];
    
    totalOfLaunches++;
    
    if ( didUserRateApp )
    {
        return;
    }
    
    if ( totalOfLaunches == 1 )
    {
        // primeira vez
        
        // carrega os dados no core data
        [self loadInitialCoreDataInfo];
        
        // apens incrementa o contador (feito acima) e diz que deve lembrar mais tarde
        [userDefaults setBool:YES forKey:SHOULD_SHOW_RATE_APP_DIALOG_KEY];
        [userDefaults setBool:NO forKey:DID_USER_RATE_APP_KEY];
    }
    else
    {
        if ( totalOfLaunches % 5 == 0 )
        {
            if ( shouldShowDialog )
            {
                // mostra o diálogo
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Avalie este app"
                                                                message:@"Gostou do app? Dê sua opinião!"
                                                               delegate:self
                                                      cancelButtonTitle:@"Não, obrigado"
                                                      otherButtonTitles:@"Sim, Claro!", @"Lembrar mais tarde", nil];
                
                [alert show];
            }
        }
    }
    
    [userDefaults setInteger:totalOfLaunches forKey:TOTAL_OF_APP_LAUNCHES_KEY];
    [userDefaults setBool:didUserRateApp forKey:DID_USER_RATE_APP_KEY];
    [userDefaults synchronize];
}


#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* rateURL;
    BOOL didUserRateApp = [userDefaults boolForKey:DID_USER_RATE_APP_KEY];
    BOOL shouldShowDialog = [userDefaults boolForKey:SHOULD_SHOW_RATE_APP_DIALOG_KEY];
    
    switch ( buttonIndex )
    {
        case 0:
            // não lembrar mais
            shouldShowDialog = NO;
            break;
            
            
        case 1:
            // avaliar
            didUserRateApp = YES;
            
            rateURL = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%i", APP_ID];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:rateURL]];
            
            break;
            
            
        case 2:
            // lembrar mais tarde
            shouldShowDialog = YES;
            break;
    }
    
    [userDefaults setBool:shouldShowDialog forKey:SHOULD_SHOW_RATE_APP_DIALOG_KEY];
    [userDefaults setBool:didUserRateApp forKey:DID_USER_RATE_APP_KEY];
    [userDefaults synchronize];
}



@end
