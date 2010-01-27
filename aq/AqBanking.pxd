#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

cdef extern from "string.h":
    char* strncpy(char*, char*, unsigned int)

cdef extern from "gwenhywfar/gui.h":
    ctypedef struct GWEN_GUI
    void GWEN_Gui_SetGui(GWEN_GUI*)
    
cdef extern from "gwenhywfar/cgui.h":
    GWEN_GUI* GWEN_Gui_CGui_new()
    
cdef extern from "aqbanking/account.h":
    ctypedef struct AB_ACCOUNT_LIST2
    
cdef extern from "aqbanking/user.h":
    ctypedef struct AB_USER_LIST2
    
cdef extern from "aqbanking/job.h":
    ctypedef struct AB_JOB_LIST2
    void AB_Job_List2_free(AB_JOB_LIST2*)  
    
cdef extern from "aqbanking/imexporter.h":
    ctypedef struct AB_IMEXPORTER_CONTEXT  
    
cdef extern from "aqbanking/banking.h":
    ctypedef struct AB_BANKING
    AB_BANKING *AB_Banking_new(char*, char*, unsigned int)
    int AB_Banking_Init(AB_BANKING*)
    int AB_Banking_OnlineInit(AB_BANKING*, unsigned int)
    void AB_Banking_GetVersion (int*, int*, int*, int*)
    int AB_Banking_Fini(AB_BANKING*)
    int AB_Banking_OnlineFini(AB_BANKING*, unsigned int)
    void AB_Banking_free(AB_BANKING*)
    void* AB_Banking_GetUserData(AB_BANKING*)
    void AB_Banking_SetUserData(AB_BANKING*, void*)
    AB_ACCOUNT_LIST2* AB_Banking_GetAccounts(AB_BANKING*)    
    AB_USER_LIST2* AB_Banking_GetUsers(AB_BANKING*)
    int AB_Banking_ExecuteJobs(AB_BANKING*, AB_JOB_LIST2*, AB_IMEXPORTER_CONTEXT*, unsigned int)
    
    
cdef class Banking:    
    cdef AB_BANKING *abInstance
    cdef object magic
   