//
//  iPropinaAppDelegate.m
//  iPropina
//
//  Created by Chris Martinez on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "iPropinaAppDelegate.h"


@implementation iPropinaAppDelegate {
    NSURLConnection *_connection;
    NSMutableData *_response;
    NSDictionary *_JSON;
    NSString * _updateURL;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self checkForNewVersion];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#define TIMEOUT_INTERVAL 30

- (void) checkForNewVersion {
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=586099258"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TIMEOUT_INTERVAL];

    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"0" forHTTPHeaderField:@"Content-length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:nil];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    if (_connection) {
        [_connection cancel];
        _connection = nil;
    }
    
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if ( !_connection )
    {

    }
}


- (BOOL)responseToJSON {
    /*
     if (![_response length]) {
     return YES;
     }
     */
    
    NSError *error = nil;
    
    _JSON = [NSJSONSerialization JSONObjectWithData:[self response]
                                            options:kNilOptions
                                              error:&error];
    
    NSLog(@"JSON Response: %@", _JSON);
    if(error) {
        return NO;
    }
    
    return YES;
}

- (void)processJSON {
    
    NSDictionary *jsonResponse = _JSON;
    NSString * appStoreVersion = nil;
    
    NSArray *configData = [jsonResponse valueForKey:@"results"];
    for (id config in configData)
    {
        appStoreVersion = [config valueForKey:@"version"];
        _updateURL = [config valueForKey:@"trackViewUrl"];
        NSLog(@"version: %@", appStoreVersion);
        NSLog(@"update URL: %@", _updateURL);
    }
    
    // Compare Both Versions
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];

    float dCurrentVersion;
    float dAppStoreVersion;
    
    // try to compare the versions as numbers
    dCurrentVersion = [currentVersion floatValue];
    dAppStoreVersion = [appStoreVersion floatValue];
    
    // Compare current version against appStore version
    if (![appStoreVersion isEqualToString:currentVersion] && dCurrentVersion < dAppStoreVersion)
    {
#ifdef FORCE
        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:appName message: @"A new version of the app is available to download" delegate:self cancelButtonTitle:nil otherButtonTitles: @"Update", nil];
#else
        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:appName message: @"A new version of the app is available to download" delegate:self cancelButtonTitle:@"I'll do it later" otherButtonTitles: @"Update Now", nil];
#endif
        [createUserResponseAlert show];
    }
}

// Redirect User
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateURL]];
    }
}

#pragma mark - NSURL Delegate Methods

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

// This method will/should be overridden unless it is a fire and forget call.
- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    
    if ([self responseToJSON]) {
        [self processJSON];
    }
    conn = nil;
}

- (void)connection:(NSURLConnection *)conn
  didFailWithError:(NSError *)error {
    
    conn = nil;
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
    [[self response] setLength:0];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)theData {
    [self responseAppendData:theData];
}

#pragma mark - Getters and Setters

- (NSMutableData *)response {
    if( _response == nil) {
        _response = [NSMutableData data];
    }
    return _response;
}

- (void)responseAppendData:(NSData *)argResponseData {
    if( _response == nil) {
        _response = [NSMutableData data];
    }
    [_response appendData:argResponseData];
}


@end
