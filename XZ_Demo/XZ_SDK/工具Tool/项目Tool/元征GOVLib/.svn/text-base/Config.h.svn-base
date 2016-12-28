//
//  Config.h
//  GODiagnoseDemo
//
//  Created by Launch Tech Co.,Ltd on 5/21/15.
//  Copyright (c) 2015 allen. All rights reserved.
//

#define MOBILE_VERSION   0//1//如果是移动版本这里设置为1，基本版本改为0

#define PATH_IN_DOCUMENTS_DIR(f)    ([NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),f])

// 用户接口
#define REGISTERPRODUCT_URL @"http://open.api.dbscar.com/"
// 获取车辆品牌接口
#define GETCARBRAND_URL @"http://open.api.dbscar.com/"
// 获取车型接口
#define GETCARTYPE_URL @"http://apps.api.dbscar.com/"
// 激活GOLO头接口
#define ACTIVATEGOLO_URL @"http://open.api.dbscar.com/"
// 根据golo智能终端获取下载配置文件的参数值接口
#define GETCARCONFIGPARAM_URL @"http://open.api.dbscar.com/"
// 获取sys.ini文件参数
#define GETCARSYSINIPARAM_URL @"http://open.api.dbscar.com/"
// 下载车辆配置文件和EOBD配置文件接口
#define GETCARCONFIGDATA_URL @"http://dlcenter.x431.com/diag/downloadEncryptDiagSoft.action"
// 获取激活的车辆信息接口
#define GETACTIVATEDCARINFO_URL @"http://open.api.dbscar.com/"

#define DEVELOP_ID  @"10112" // 开发ID
#define GOVD_APPID  @"2013120200000001" // appid
#define DEVELOP_KEY @"5cde4abc54938ca0ad6cfe96b2942m" // 开发Key
#define CAR_DIAG_SOFT_PATH_KEY @"CARDIAGSOFT_PATH"
#define CAR_EOBD_SOFT_PATH_KEY @"CAREOBDSOFT_PATH"
#define kSerialNoKey(sn) ([NSString stringWithFormat:@"GOLOSerialNO_%@",(sn)])
#define Path_dpusysINI (PATH_IN_DOCUMENTS_DIR(@"DPUSYS.INI"))//dpusysINI文件位置
#define Path_Car_dpusysINI (PATH_IN_DOCUMENTS_DIR(@"Car_DPUSYS.INI"))//全车dpusysINI文件位置




//#pragma mark - 支付宝的 config
//
///**
// * \file config.h
// *
// * This set of compile-time options may be used to enable
// * or disable features selectively, and reduce the global
// * memory footprint.
// */
//#ifndef XYSSL_CONFIG_H
//#define XYSSL_CONFIG_H
//
//#ifndef _CRT_SECURE_NO_DEPRECATE
//#define _CRT_SECURE_NO_DEPRECATE 1
//#endif
//
///*
// * Uncomment if native integers are 8-bit wide.
// *
// #define XYSSL_HAVE_INT8
// */
//
///*
// * Uncomment if native integers are 16-bit wide.
// *
// #define XYSSL_HAVE_INT16
// */
//
///*
// * Uncomment if the compiler supports long long.
// *
// #define XYSSL_HAVE_LONGLONG
// */
//
///*
// * Uncomment to enable the use of assembly code.
// */
////#define XYSSL_HAVE_ASM
//
///*
// * Uncomment if the CPU supports SSE2 (IA-32 specific).
// *
// #define XYSSL_HAVE_SSE2
// */
//
///*
// * Enable all SSL/TLS debugging messages.
// #define XYSSL_DEBUG_MSG
// */
//
///*
// * Enable the checkup functions (*_self_test).
// */
//#define XYSSL_SELF_TEST
//
//
///*
// * Enable the prime-number generation code.
// */
//#define XYSSL_GENPRIME
//
///*
// * Uncomment this macro to store the AES tables in ROM.
// *
// #define XYSSL_AES_ROM_TABLES
// */
//
///*
// * Module:  library/aes.c
// * Caller:  library/ssl_tls.c
// *
// * This module enables the following ciphersuites:
// *      SSL_RSA_AES_128_SHA
// *      SSL_RSA_AES_256_SHA
// *      SSL_EDH_RSA_AES_256_SHA
// */
//#define XYSSL_AES_C
//
///*
// * Module:  library/arc4.c
// * Caller:  library/ssl_tls.c
// *
// * This module enables the following ciphersuites:
// *      SSL_RSA_RC4_128_MD5
// *      SSL_RSA_RC4_128_SHA
// */
//#define XYSSL_ARC4_C
//
///*
// * Module:  library/base64.c
// * Caller:  library/x509parse.c
// *
// * This module is required for X.509 support.
// */
//#define XYSSL_BASE64_C
//
///*
// * Module:  library/bignum.c
// * Caller:  library/dhm.c
// *          library/rsa.c
// *          library/ssl_tls.c
// *          library/x509parse.c
// *
// * This module is required for RSA and DHM support.
// */
//#define XYSSL_BIGNUM_C
//
///*
// * Module:  library/certs.c
// * Caller:
// *
// * This module is used for testing (ssl_client/server).
// */
//#define XYSSL_CERTS_C
//
///*
// * Module:  library/debug.c
// * Caller:  library/ssl_cli.c
// *          library/ssl_srv.c
// *          library/ssl_tls.c
// *
// * This module provides debugging functions.
// #define XYSSL_DEBUG_C
// */
//
///*
// * Module:  library/des.c
// * Caller:  library/ssl_tls.c
// *
// * This module enables the following ciphersuites:
// *      SSL_RSA_DES_168_SHA
// *      SSL_EDH_RSA_DES_168_SHA
// */
//#define XYSSL_DES_C
//
///*
// * Module:  library/dhm.c
// * Caller:  library/ssl_cli.c
// *          library/ssl_srv.c
// *
// * This module enables the following ciphersuites:
// *      SSL_EDH_RSA_DES_168_SHA
// *      SSL_EDH_RSA_AES_256_SHA
// */
//#define XYSSL_DHM_C
//
///*
// * Module:  library/havege.c
// * Caller:
// *
// * This module enables the HAVEGE random number generator.
// */
//#define XYSSL_HAVEGE_C
//
///*
// * Module:  library/md2.c
// * Caller:  library/x509parse.c
// *
// * Uncomment to enable support for (rare) MD2-signed X.509 certs.
// *
// #define XYSSL_MD2_C
// */
//
///*
// * Module:  library/md4.c
// * Caller:  library/x509parse.c
// *
// * Uncomment to enable support for (rare) MD4-signed X.509 certs.
// *
// #define XYSSL_MD4_C
// */
//
///*
// * Module:  library/md5.c
// * Caller:  library/ssl_tls.c
// *          library/x509parse.c
// *
// * This module is required for SSL/TLS and X.509.
// */
//#define XYSSL_MD5_C
//
///*
// * Module:  library/net.c
// * Caller:
// *
// * This module provides TCP/IP networking routines.
// */
//#define XYSSL_NET_C
//
///*
// * Module:  library/padlock.c
// * Caller:  library/aes.c
// *
// * This modules adds support for the VIA PadLock on x86.
// */
//#define XYSSL_PADLOCK_C
//
///*
// * Module:  library/rsa.c
// * Caller:  library/ssl_cli.c
// *          library/ssl_srv.c
// *          library/ssl_tls.c
// *          library/x509.c
// *
// * This module is required for SSL/TLS and MD5-signed certificates.
// */
//#define XYSSL_RSA_C
//
///*
// * Module:  library/sha1.c
// * Caller:  library/ssl_cli.c
// *          library/ssl_srv.c
// *          library/ssl_tls.c
// *          library/x509parse.c
// *
// * This module is required for SSL/TLS and SHA1-signed certificates.
// */
//#define XYSSL_SHA1_C
//
///*
// * Module:  library/sha2.c
// * Caller:
// *
// * This module adds support for SHA-224 and SHA-256.
// */
//#define XYSSL_SHA2_C
//
///*
// * Module:  library/sha4.c
// * Caller:
// *
// * This module adds support for SHA-384 and SHA-512.
// */
//#define XYSSL_SHA4_C
//
///*
// * Module:  library/ssl_cli.c
// * Caller:
// *
// * This module is required for SSL/TLS client support.
// */
//#define XYSSL_SSL_CLI_C
//
///*
// * Module:  library/ssl_srv.c
// * Caller:
// *
// * This module is required for SSL/TLS server support.
// */
//#define XYSSL_SSL_SRV_C
//
///*
// * Module:  library/ssl_tls.c
// * Caller:  library/ssl_cli.c
// *          library/ssl_srv.c
// *
// * This module is required for SSL/TLS.
// */
//#define XYSSL_SSL_TLS_C
//
///*
// * Module:  library/timing.c
// * Caller:  library/havege.c
// *
// * This module is used by the HAVEGE random number generator.
// */
//#define XYSSL_TIMING_C
//
///*
// * Module:  library/x509parse.c
// * Caller:  library/ssl_cli.c
// *          library/ssl_srv.c
// *          library/ssl_tls.c
// *
// * This module is required for X.509 certificate parsing.
// */
//#define XYSSL_X509_PARSE_C
//
///*
// * Module:  library/x509_write.c
// * Caller:
// *
// * This module is required for X.509 certificate writing.
// */
//#define XYSSL_X509_WRITE_C
//
//#endif /* config.h */