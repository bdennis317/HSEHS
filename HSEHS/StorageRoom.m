//
//  StorageRoom.m
//  StorageRoomExample
//
//  Created by Sascha Konietzke on 11/11/10.
//  Copyright 2012 Thriventures UG (haftungsbeschränkt). See LICENSE for details.
//

#import "StorageRoom.h"



NSString * const StorageRoomAccountId = @"5116a0a30f660206d600094a";
NSString * const StorageRoomAPIKey = @"nigoByijE4996dyzsf1i";
NSString * const StorageRoomHost = @"api.storageroomapp.com"; 


NSString *StorageRoomURL(NSString *path) {
  return [NSString stringWithFormat:@"http://%@/accounts/%@%@", StorageRoomHost, StorageRoomAccountId, path];
}

id NilOrValue(id aValue) {
  if ((NSNull *)aValue == [NSNull null]) {
    return nil;
  }
  else {
    return aValue;
  }
}