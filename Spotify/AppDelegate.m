//
//  AppDelegate.m
//  Spotify
//
//  Created by Daniel on 9/2/16.
//  Copyright © 2016 DanielCompany. All rights reserved.
//

#import "AppDelegate.h"

//#import "SPTAudioStreamingController.h"


@interface AppDelegate ()

@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTAudioStreamingController *player;
@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SPTAuth defaultInstance] setClientID:@"b850cb49c41649ad9a75e2af2a1bde1e"];
    [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:@"spotify-example-app-login://callback"]];
    [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthStreamingScope]];
    
    // Construct a login URL and open it
    NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
    
    // Opening a URL in Safari close to application launch may trigger
    // an iOS bug, so we wait a bit before doing so.
    [application performSelector:@selector(openURL:)
                      withObject:loginURL afterDelay:0.1];
    
    return YES;
}

// Handle auth callback
-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {
    
    // Ask SPTAuth if the URL given is a Spotify authentication callback
    if ([[SPTAuth defaultInstance] canHandleURL:url]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            
            if (error != nil) {
                NSLog(@"*** Auth error: %@", error);
                return;
            }
            
            // Call the -loginUsingSession: method to login SDK
            [self loginUsingSession:session];
        }];
        return YES;
    }
    
    return NO;
}

-(void)loginUsingSession:(SPTSession *)session {
    // Get the player instance
    self.player = [SPTAudioStreamingController sharedInstance];
    self.player.delegate = self;
    // Start the player (will start a thread)
    [self.player startWithClientId:@"b850cb49c41649ad9a75e2af2a1bde1e" error:nil];
    // Login SDK before we can start playback
    [self.player loginWithAccessToken:session.accessToken];
}



@end
