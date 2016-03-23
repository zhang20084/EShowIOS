//
//  CrashMasterC.h
//  CrashMaster
//
//  Copyright (c) 2014 testin. All rights reserved.
//

#ifndef __CRASH_MASTER_C_H_
#define __CRASH_MASTER_C_H_

#define CMASTER_TYPE_JAVA    0
#define CMASTER_TYPE_CPP     1
#define CMASTER_TYPE_OBJC    2
#define CMASTER_TYPE_LUA     3
#define CMASTER_TYPE_JS      4

typedef struct __CrashMasterCConfig
{
    int enabledMonitorException:1; //default true.
    int useLocationInfo:1;         //default false.
    int reportOnlyWIFI:1;          //default true.
    int printLogForDebug:1;        //default false.
}CrashMasterCConfig;

#ifdef __cplusplus
extern "C" {
#endif
    
    void cmasterInit(const char* cAppId, const char* cChannel);
    void cmasterInitWithConfig(const char* cAppId, const char* cChannel, CrashMasterCConfig config);
    void cmasterSetUserInfo(const char* cUserInfo);
    void cmasterLeaveBreadcrumb(const char* cString);
    void cmasterReportException(int nType, const char* cMessage, const char* cStacktrace);
    void cmasterTerminate();
    
#ifdef __cplusplus
    }
#endif

#endif //__CMASTER_C_H_
