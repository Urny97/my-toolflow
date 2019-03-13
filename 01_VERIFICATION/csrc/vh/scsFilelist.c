#include "stdio.h"
#ifdef __cplusplus
extern "C" {
#endif
extern char at_least_one_object_file;
extern void *kernel_scs_file_ht_new(const void *, int);
extern int kernel_scs_file_ht_get(void *, const char *, int *);
extern int  strcmp(const char*, const char*);
  typedef struct {
    char* dFileName;
  } lPkgFileInfoStruct;

  typedef struct {
    char* dFileName;
    char* dRealFileName;
    long dFileOffset;
    unsigned long dFileSize;
    int dFileModTime;
    unsigned int simFlag;
  } lFileInfoStruct;

static int lNumOfScsFiles;
  static lFileInfoStruct lFInfoArr[] = {
  {"synopsys_sim.setup_0", "/esat/micas-data/software/vcs-mx_2017.03/bin/synopsys_sim.setup", 3226, 4548, 1487217818, 0},
  {"./64/AES128_TB.sim", "", 0, 3226, 0, 1},
  {"linux64/packages/IEEE/lib/64/STD_LOGIC_TEXTIO__.sim", "", 7774, 182509, 0, 0},
  {"linux64/packages/IEEE/lib/64/STD_LOGIC_TEXTIO.sim", "", 190283, 30841, 0, 0},
  {"./64/PKG_AES128__.sim", "", 221124, 30299, 0, 1},
  {"./64/PKG_AES128.sim", "", 251423, 25875, 0, 1},
  {"./64/DUMMY_MHDL_CFG_AES128_TB.sim", "", 277298, 43206, 0, 0},
  {"./64/AES128_TB__BEHAVIOURAL.sim", "", 320504, 49187, 0, 1},
  {"linux64/packages/IEEE/lib/64/STD_LOGIC_UNSIGNED__.sim", "", 369691, 90037, 0, 0},
  {"linux64/packages/IEEE/lib/64/STD_LOGIC_UNSIGNED.sim", "", 459728, 42655, 0, 0},
  {"./64/AES128.sim", "", 502383, 5396, 0, 1},
  {"./64/AES128__BEHAVIORAL.sim", "", 507779, 39073, 0, 1},
  {"./64/KEYSCHEDULER.sim", "", 546852, 5470, 0, 1},
  {"./64/KEYSCHEDULER__BEHAVIORAL.sim", "", 552322, 38769, 0, 1},
  {"./64/CONTROL_FSM.sim", "", 591091, 6515, 0, 1},
  {"./64/CONTROL_FSM__BEHAVIOURAL.sim", "", 597606, 38450, 0, 1},
  {"./64/ADDROUNDKEY.sim", "", 636056, 3979, 0, 1},
  {"./64/ADDROUNDKEY__ADDROUNDKEY_ARCH.sim", "", 640035, 13067, 0, 1},
  {"./64/SUBBYTES.sim", "", 653102, 4010, 0, 1},
  {"./64/SUBBYTES__BEHAVIOURAL.sim", "", 657112, 23839, 0, 1},
  {"./64/SHIFTROW.sim", "", 680951, 3690, 0, 1},
  {"./64/SHIFTROW__SHIFTROW_ARCH.sim", "", 684641, 9328, 0, 1},
  {"./64/MIXCOLUMN.sim", "", 693969, 3677, 0, 1},
  {"./64/MIXCOLUMN__MIXCOLUMN_ARCH.sim", "", 697646, 26237, 0, 1},
  {"./64/BYTESUB.sim", "", 723883, 3623, 0, 1},
  {"./64/BYTESUB__INTERNALS.sim", "", 727506, 214544, 0, 1},

  };
  static lPkgFileInfoStruct lPkgFileInfoArr[] = {
  {"linux64/packages/IEEE/lib/64/STD_LOGIC_TEXTIO__.sim"},
  {"./64/PKG_AES128__.sim"},
  {"linux64/packages/IEEE/lib/64/STD_LOGIC_UNSIGNED__.sim"},

  };
int gGetFileInfo(char *xFileName, long xTimeStamp, long *xFileOffsetPtr, size_t *xFileSizePtr, int xCheckInPkgSimFiles,  char **xRealFileName)
{
  int j, lNumOfPkgSimFiles;
  static void *ht = 0;
  static int i = 0;
  static int k = 0;
at_least_one_object_file = 1;
  lNumOfScsFiles = 26;
  lNumOfPkgSimFiles = 3;
  if (xCheckInPkgSimFiles)
  {
     for (j = 0; j < lNumOfPkgSimFiles; j++)
     {
       char* lFName;
       lFName = lPkgFileInfoArr[k].dFileName;
       if (strcmp(lFName, xFileName) == 0)
           return 0;
       k = (k + 1) % lNumOfPkgSimFiles;
     }
     return 1;
  }
  if (!ht)
  {
    ht  = kernel_scs_file_ht_new(lFInfoArr, lNumOfScsFiles);
  }
  if (ht && (kernel_scs_file_ht_get(ht, xFileName, &i) == 0))
  { /* found it! The indicator 'i' was set properly. */
    if (xRealFileName)
        *xRealFileName = lFInfoArr[i].dRealFileName;
    *xFileSizePtr = lFInfoArr[i].dFileSize;
    *xFileOffsetPtr = lFInfoArr[i].dFileOffset;
    return 0;
  }
  return 1;
}
int getNextSimFile(char **fn, long *offset)
{
  static int cur;
  for ( ; cur < lNumOfScsFiles; ) {
    if (!lFInfoArr[cur].simFlag) {
      cur++;
      continue;
    }
    *fn = lFInfoArr[cur].dFileName;
    *offset = lFInfoArr[cur].dFileOffset;
    cur++;
    return 1;
  }
  return 0;
}

#ifdef __cplusplus
}
#endif
