//
//  RSASecurity.m
//  TestProduct
//
//  Created by zhangke on 16/1/14.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "RSASecurity.h"

@interface RSASecurity ()
@property (nonatomic, readonly) SecKeyRef publicKey;
@property (nonatomic, readonly) SecKeyRef privateKey;
@end

@implementation RSASecurity



-(void)getPublicKeyFromDERFile:(NSString*)derFilePath{
    NSData *derData = [NSData dataWithContentsOfFile:derFilePath];
    _publicKey = [self extractPublicKeyFromCertificateData:derData];
}
-(SecKeyRef)extractPublicKeyFromCertificateData:(NSData *)certData{
    SecKeyRef publicKeyRef = nil;
    if (certData) {
        SecCertificateRef certRef = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certData);
        SecPolicyRef policyRef = SecPolicyCreateBasicX509();
        SecTrustRef trustRef;
        OSStatus status = SecTrustCreateWithCertificates(certRef, policyRef, &trustRef);
        if (status == errSecSuccess && trustRef) {
            
//            NSArray *certs = [NSArray arrayWithObject:(__bridge id)certRef];
//            status = SecTrustSetAnchorCertificates(trustRef, (__bridge CFArrayRef)certs);
//            if (status == errSecSuccess) {
            
                SecTrustResultType trustResult;
                status = SecTrustEvaluate(trustRef, &trustResult);
            
//                if (status == errSecSuccess && (trustResult == kSecTrustResultUnspecified || trustResult == kSecTrustResultProceed)) {
            
                    publicKeyRef = SecTrustCopyPublicKey(trustRef);
                    if (publicKeyRef) {
                        NSLog(@"Etract publickey success --\n%@",publicKeyRef);
                    }
            
//                }
//            }
            
        }
        CFRelease(certRef);
        CFRelease(policyRef);
        CFRelease(trustRef);
    }
    return publicKeyRef;
}

-(void)getPrivateKeyFromPKCS12File:(NSString*)p12FilePath password:(NSString*)p12Password{
    NSData *p12Data = [NSData dataWithContentsOfFile:p12FilePath];
    _privateKey = [self extractPrivateKeyFromPKCS12Data:p12Data password:p12Password];
}
-(SecKeyRef)extractPrivateKeyFromPKCS12Data:(NSData*)p12Data password:(NSString*)p12Password{
    SecKeyRef privateKeyRef = nil;
    if (p12Data) {
        NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
        [options setObject:p12Password forKey:(__bridge id)kSecImportExportPassphrase];
        CFArrayRef items = CFArrayCreate(kCFAllocatorDefault, NULL, 0, NULL);
        OSStatus status = SecPKCS12Import((__bridge CFDataRef)p12Data, (__bridge CFDictionaryRef)options, &items);
        if (status == errSecSuccess && CFArrayGetCount(items) > 0) {
            CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
            SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
            status = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
            if (status == errSecSuccess && privateKeyRef) {
                NSLog(@"Extract privateKey success --\n%@",privateKeyRef);
            }
        }
        CFRelease(items);
        
//        if (status == errSecSuccess) {
//            SecIdentityRef identity;
//            SecTrustRef trust;
//            CFDictionaryRef item_dic = CFArrayGetValueAtIndex(items, 0);
//            identity = (SecIdentityRef)CFDictionaryGetValue(item_dic, kSecImportItemIdentity);
//            trust = (SecTrustRef)CFDictionaryGetValue(item_dic, kSecImportItemTrust);
//            // certs数组中包含了所有的证书
//            CFArrayRef certs = (CFArrayRef)CFDictionaryGetValue(item_dic, kSecImportItemCertChain);
//            if ([(__bridge NSArray*)certs count] && trust && identity) {
//                // 如果没有下面一句，自签名证书的评估信任结果永远是kSecTrustResultRecoverableTrustFailure
//                status = SecTrustSetAnchorCertificates(trust, certs);
//                if (status == errSecSuccess) {
//                    SecTrustResultType trustResultType;
//                    // 通常, 返回的trust result type应为kSecTrustResultUnspecified，如果是，就可以说明签名证书是可信的
//                    status = SecTrustEvaluate(trust, &trustResultType);
//                    if ((trustResultType == kSecTrustResultUnspecified || trustResultType == kSecTrustResultProceed) && status == errSecSuccess) {
//                        // 证书可信，可以提取私钥与公钥，然后可以使用公私钥进行加解密操作
//                        status = SecIdentityCopyPrivateKey(identity, &privateKeyRef);
//                        if (status == errSecSuccess && privateKeyRef) {
//                            NSLog(@"Extract privateKey success --\n%@",privateKeyRef);
//                        }
//                    }
//                }
//            }
//        }
//        CFRelease(items);
    }
    return privateKeyRef;
}

-(NSString*)rsaEncryptString:(NSString*)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [self rsaEncryptData:data];
    return [encryptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
-(NSData*)rsaEncryptData:(NSData*)data{
    if (self.publicKey) {
        // 分配内存块，用于存放加密后的数据段
        size_t cipherBufferSize = SecKeyGetBlockSize(self.publicKey);
        uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
        /*
         为什么这里要减12而不是减11?
         苹果官方文档给出的说明是，加密时，如果sec padding使用的是kSecPaddingPKCS1，
         那么支持的最长加密长度为SecKeyGetBlockSize()-11，
         这里说的最长加密长度，我估计是包含了字符串最后的空字符'\0'，
         因为在实际应用中我们是不考虑'\0'的，所以，支持的真正最长加密长度应为SecKeyGetBlockSize()-12
         */
        double totalLength = [data length];
        size_t blockSize = cipherBufferSize - 12;// 使用cipherBufferSize - 11是错误的!
        size_t blockCount = (size_t)ceil(totalLength / blockSize);
        NSMutableData *encryptedData = [NSMutableData data];
        // 分段加密
        for (int i = 0; i < blockCount; i++) {
            NSUInteger loc = i * blockSize;
            // 数据段的实际大小。最后一段可能比blockSize小。
            unsigned long dataSegmentRealSize = MIN(blockSize, [data length] - loc);
            // 截取需要加密的数据段
            NSData *dataSegment = [data subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
            OSStatus status = SecKeyEncrypt(self.publicKey, kSecPaddingPKCS1, (const uint8_t *)[dataSegment bytes], dataSegmentRealSize, cipherBuffer, &cipherBufferSize);
            if (status == errSecSuccess) {
                NSData *encryptedDataSegment = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
                // 追加加密后的数据段
                [encryptedData appendData:encryptedDataSegment];
            } else {
                if (cipherBuffer) {
                    free(cipherBuffer);
                }
                return nil;
            }
        }
        if (cipherBuffer) {
            free(cipherBuffer);
        }
        return encryptedData;
    }else{
        return nil;
    }
}


-(NSString*)rsaDecryptString:(NSString *)string{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [self rsaDecryptData:data];
    return [[NSString alloc]initWithData:decryptData encoding:NSUTF8StringEncoding];
}

-(NSData*)rsaDecryptData:(NSData *)data{
    
    if (self.privateKey) {
        // 分配内存块，用于存放解密后的数据段
        size_t plainBufferSize = SecKeyGetBlockSize(self.privateKey);
        uint8_t *plainBuffer = malloc(plainBufferSize * sizeof(uint8_t));
        // 计算数据段最大长度及数据段的个数
        double totalLength = [data length];
        size_t blockSize = plainBufferSize;
        size_t blockCount = (size_t)ceil(totalLength / blockSize);
        NSMutableData *decryptedData = [NSMutableData data];
        // 分段解密
        for (int i = 0; i < blockCount; i++) {
            NSUInteger loc = i * blockSize;
            // 数据段的实际大小。最后一段可能比blockSize小。
            int dataSegmentRealSize = MIN(blockSize, totalLength - loc);
            // 截取需要解密的数据段
            NSData *dataSegment = [data subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
            OSStatus status = SecKeyDecrypt(self.privateKey, kSecPaddingPKCS1, (const uint8_t *)[dataSegment bytes], dataSegmentRealSize, plainBuffer, &plainBufferSize);
            if (status == errSecSuccess) {
                NSData *decryptedDataSegment = [[NSData alloc] initWithBytes:(const void *)plainBuffer length:plainBufferSize];
                [decryptedData appendData:decryptedDataSegment];
            }else{
                if (plainBuffer) {
                    free(plainBuffer);
                }
                return nil;
            }
        }
        if (plainBuffer) {
            free(plainBuffer);
        }
        return decryptedData;
    }else{
        return nil;
    }
    
}



@end
