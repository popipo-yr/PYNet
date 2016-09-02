//
//  PYNetClientSimple.m
//  test
//
//  Created by yr on 16/5/16.
//  Copyright © 2016年 yr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYNetClient_Addtion.h"

@implementation PYNetClient (Addtion)


- (void)postJpegImageTo:(NSString *)path
             parameters:(NSDictionary *)parameters
             ImageInfos:(NSDictionary *)imageInfos
                quality:(float)compressionQuality
           successBlock:(void (^)(NSDictionary *res))successBlock
           failureBlock:(void (^)(NSDictionary *res))failureBlock
           netFailBlock:(void (^)(NSError *error))netFailBlock
{
    NSArray<PYNetFile *> *files = [self _coverToNetFilesWithJPGEInfo:imageInfos quality:compressionQuality];

    [self postFileTo:path parameters:parameters fileEntities:files successBlock:successBlock
        failureBlock :failureBlock netFailBlock:netFailBlock];
}


- (void)postPngImageTo:(NSString *)path
            parameters:(NSDictionary *)parameters
            ImageInfos:(NSDictionary *)imageInfos
          successBlock:(void (^)(NSDictionary *res))successBlock
          failureBlock:(void (^)(NSDictionary *res))failureBlock
          netFailBlock:(void (^)(NSError *error))netFailBlock
{
    NSArray<PYNetFile *> *files = [self _coverToNetFilesWithPNGInfo:parameters];

    [self postFileTo:path parameters:parameters fileEntities:files successBlock:successBlock
        failureBlock :failureBlock netFailBlock:netFailBlock];
}


- (void)postAmrsTo:(NSString *)path
        parameters:(NSDictionary *)parameters
          AmrInfos:(NSDictionary *)amrInfos
      successBlock:(void (^)(NSDictionary *res))successBlock
      failureBlock:(void (^)(NSDictionary *res))failureBlock
      netFailBlock:(void (^)(NSError *error))netFailBlock
{
    NSArray<PYNetFile *> *files = [self _coverToNetFilesWithAmrInfo:parameters];

    [self postFileTo:path parameters:parameters fileEntities:files successBlock:successBlock
        failureBlock :failureBlock netFailBlock:netFailBlock];
}


////PNG参数转换为netfile
- (NSArray<PYNetFile *> *)_coverToNetFilesWithPNGInfo:(NSDictionary *)imageInfo
{
    NSMutableArray<PYNetFile *> *files = [NSMutableArray array];

    //转换为 netFile
    [imageInfo enumerateKeysAndObjectsUsingBlock:^(NSString *name, UIImage *image, BOOL *stop) {
         if (![name isKindOfClass:[NSString class]]) return;

         if (![image isKindOfClass:[UIImage class]]) return;

         NSData *data = UIImagePNGRepresentation(image);

         if (data == nil) return;

         PYNetFile* aFile = [PYNetFile new];
         aFile.name = name;
         aFile.fileName = [NSString stringWithFormat:@"%@.png", name];
         aFile.type = @"image/png";
         aFile.data = data;

         [files addObject:aFile];
     }];

    return files;
}


////JPGE参数转换为netfile
- (NSArray<PYNetFile *> *)_coverToNetFilesWithJPGEInfo:(NSDictionary *)imageInfo
                                               quality:(CGFloat)compressionQuality
{
    NSMutableArray<PYNetFile *> *files = [NSMutableArray array];

    //转换为 netFile
    [imageInfo enumerateKeysAndObjectsUsingBlock:^(NSString *name, UIImage *image, BOOL *stop) {
         if (![name isKindOfClass:[NSString class]]) return;

         if (![image isKindOfClass:[UIImage class]]) return;

         NSData *data = UIImageJPEGRepresentation(image, compressionQuality);

         if (data == nil) return;

         PYNetFile* aFile = [PYNetFile new];
         aFile.name = name;
         aFile.fileName = [NSString stringWithFormat:@"%@.jpg", name];
         aFile.type = [NSString stringWithFormat:@"image/jpg"];
         aFile.data = data;

         [files addObject:aFile];
     }];

    return files;
}


////amr参数转换为netfile
- (NSArray<PYNetFile *> *)_coverToNetFilesWithAmrInfo:(NSDictionary *)amrInfos
{
    NSMutableArray *files = [NSMutableArray array];

    [amrInfos enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSData *data, BOOL *stop) {
         if (![name isKindOfClass:[NSString class]]) return;

         if (![data isKindOfClass:[NSData class]]) return;

         PYNetFile* aFile = [PYNetFile new];
         aFile.name = name;
         aFile.fileName = [NSString stringWithFormat:@"%@.amr", name];
         aFile.type = @"audio/amr-wb";
         aFile.data = data;

         [files addObject:aFile];
     }];

    return files;
}


@end