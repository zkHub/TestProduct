//
//  RSASecurity.h
//  TestProduct
//
//  Created by zhangke on 16/1/14.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSASecurity : NSObject

-(void)getPublicKeyFromDERFile:(NSString*)derFilePath;
-(SecKeyRef)extractPublicKeyFromCertificateData:(NSData *)certData;

-(void)getPrivateKeyFromPKCS12File:(NSString*)p12FilePath password:(NSString*)p12Password;
-(SecKeyRef)extractPrivateKeyFromPKCS12Data:(NSData*)p12Data password:(NSString*)p12Password;

-(NSString*)rsaEncryptString:(NSString*)string;
-(NSData*)rsaEncryptData:(NSData*)data;

- (NSString*)rsaDecryptString:(NSString*)string;
- (NSData*)rsaDecryptData:(NSData*)data;

@end
