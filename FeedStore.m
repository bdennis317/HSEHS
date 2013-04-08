//
//  FeedStore.m
//  HSEHS
//
//  Created by Ben Dennis on 3/11/13.
//  Copyright (c) 2013 Dennis Tech. All rights reserved.
//

#import "FeedStore.h"
#import "AppDelegate.h"
#import "Announcement.h"
#import "CoreDataHelper.h"

@implementation FeedStore

@synthesize managedObjectContext;

-(id)init {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    managedObjectContext = appDelegate.managedObjectContext;
    return self;
}

-(void)storeData:(NSArray *)dataArray InEntityName:(NSString *)entityName {
    if ([entityName isEqualToString:@"Announcement"]) {
        for (Announcement *announce  in dataArray) {
            [self storeAnnouncement:announce];
        }
    }
}

-(void)storeAnnouncement:(Announcement *)announcement {
    
    //Create a new core data object 
    Announcement *savedAnnouncement = (Announcement *)[NSEntityDescription insertNewObjectForEntityForName:@"Announcement" inManagedObjectContext:managedObjectContext];
    
    //Set the new data object to our object that already has the information stored in it 
    savedAnnouncement = announcement;
}


@end
