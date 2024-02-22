//
//  BroadcastUploadHelpers.m
//  TikTok ReporterScreenCapture
//
//  Created by Emrah Korkmaz on 16.02.2024.
//

#import <Foundation/Foundation.h>
#import "BroadcastUploadHelpers.h"

void finishBroadcastGracefully(RPBroadcastSampleHandler * _Nonnull broadcastSampleHandler) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    [broadcastSampleHandler finishBroadcastWithError:nil];
#pragma clang diagnostic pop
}
