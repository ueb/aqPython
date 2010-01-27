#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

from AqBanking cimport Banking

cdef extern from "aqbanking/accstatus.h":
    ctypedef struct AB_ACCOUNT_STATUS
    
cdef extern from "aqbanking/transaction.h":
    ctypedef struct AB_TRANSACTION

cdef extern from "aqbanking/imexporter.h":
    ctypedef struct AB_IMEXPORTER_CONTEXT
    ctypedef struct AB_IMEXPORTER_ACCOUNTINFO
    
    AB_IMEXPORTER_CONTEXT* AB_ImExporterContext_new()
    void AB_ImExporterContext_free(AB_IMEXPORTER_CONTEXT*)
#    int AB_ImExporterContext_toDb (const AB_IMEXPORTER_CONTEXT *iec, GWEN_DB_NODE *db)
#    AB_IMEXPORTER_CONTEXT * AB_ImExporterContext_fromDb (GWEN_DB_NODE *db)
#    int AB_ImExporterContext_ReadDb (AB_IMEXPORTER_CONTEXT *iec, GWEN_DB_NODE *db)
#    void AB_ImExporterContext_AddContext (AB_IMEXPORTER_CONTEXT *iec, AB_IMEXPORTER_CONTEXT *toAdd)
#    void AB_ImExporterContext_AddAccountInfo (AB_IMEXPORTER_CONTEXT *iec, AB_IMEXPORTER_ACCOUNTINFO*)
    AB_IMEXPORTER_ACCOUNTINFO* AB_ImExporterContext_GetFirstAccountInfo(AB_IMEXPORTER_CONTEXT*)
    AB_IMEXPORTER_ACCOUNTINFO* AB_ImExporterContext_GetNextAccountInfo(AB_IMEXPORTER_CONTEXT*)
#    AB_IMEXPORTER_ACCOUNTINFO * AB_ImExporterContext_AccountInfoForEach (AB_IMEXPORTER_CONTEXT *iec, AB_IMEXPORTER_ACCOUNTINFO_LIST2_FOREACH func, void *user_data)
#    AB_IMEXPORTER_ACCOUNTINFO * AB_ImExporterContext_FindAccountInfo (AB_IMEXPORTER_CONTEXT *iec, const char *bankCode, const char *accountNumber)
#    AB_IMEXPORTER_ACCOUNTINFO * AB_ImExporterContext_GetAccountInfo (AB_IMEXPORTER_CONTEXT *iec, const char *bankCode, const char *accountNumber)
#    int AB_ImExporterContext_GetAccountInfoCount (const AB_IMEXPORTER_CONTEXT *iec)
#    void AB_ImExporterContext_AddTransaction (AB_IMEXPORTER_CONTEXT *iec, AB_TRANSACTION *t)
#    void AB_ImExporterContext_AddTransfer (AB_IMEXPORTER_CONTEXT *iec, AB_TRANSACTION *t)
#    void AB_ImExporterContext_AddStandingOrder (AB_IMEXPORTER_CONTEXT *iec, AB_TRANSACTION *t)
#    void AB_ImExporterContext_AddDatedTransfer (AB_IMEXPORTER_CONTEXT *iec, AB_TRANSACTION *t)

    char* AB_ImExporterAccountInfo_GetBankCode(AB_IMEXPORTER_ACCOUNTINFO*)
#    void AB_ImExporterAccountInfo_SetBankCode(AB_IMEXPORTER_ACCOUNTINFO*, char*)
    char* AB_ImExporterAccountInfo_GetBankName(AB_IMEXPORTER_ACCOUNTINFO*)
#    void AB_ImExporterAccountInfo_SetBankName(AB_IMEXPORTER_ACCOUNTINFO*, char*)
    char* AB_ImExporterAccountInfo_GetAccountNumber(AB_IMEXPORTER_ACCOUNTINFO*)
#    void AB_ImExporterAccountInfo_SetAccountNumber(AB_IMEXPORTER_ACCOUNTINFO*, char*)
    char* AB_ImExporterAccountInfo_GetAccountName(AB_IMEXPORTER_ACCOUNTINFO*)
#    void AB_ImExporterAccountInfo_SetAccountName(AB_IMEXPORTER_ACCOUNTINFO*, char*)
    char* AB_ImExporterAccountInfo_GetIban(AB_IMEXPORTER_ACCOUNTINFO*)
#    void AB_ImExporterAccountInfo_SetIban(AB_IMEXPORTER_ACCOUNTINFO*, char*)
    char* AB_ImExporterAccountInfo_GetBic(AB_IMEXPORTER_ACCOUNTINFO*)
#    void AB_ImExporterAccountInfo_SetBic(AB_IMEXPORTER_ACCOUNTINFO*, char*)
    char* AB_ImExporterAccountInfo_GetCurrency(AB_IMEXPORTER_ACCOUNTINFO*)
#    void AB_ImExporterAccountInfo_SetCurrency(AB_IMEXPORTER_ACCOUNTINFO*, char*)
    char* AB_ImExporterAccountInfo_GetOwner(AB_IMEXPORTER_ACCOUNTINFO*)
#    void AB_ImExporterAccountInfo_SetOwner(AB_IMEXPORTER_ACCOUNTINFO*, char*)
    unsigned int AB_ImExporterAccountInfo_GetType(AB_IMEXPORTER_ACCOUNTINFO*)
#    void AB_ImExporterAccountInfo_SetType(AB_IMEXPORTER_ACCOUNTINFO*, unsigned int)
    char* AB_ImExporterAccountInfo_GetDescription(AB_IMEXPORTER_ACCOUNTINFO*)
#    void AB_ImExporterAccountInfo_SetDescription(AB_IMEXPORTER_ACCOUNTINFO*, char*)
    unsigned int AB_ImExporterAccountInfo_GetAccountId(AB_IMEXPORTER_ACCOUNTINFO*)
#    void AB_ImExporterAccountInfo_SetAccountId(AB_IMEXPORTER_ACCOUNTINFO*, unsigned int)

    AB_TRANSACTION* AB_ImExporterAccountInfo_GetFirstTransaction(AB_IMEXPORTER_ACCOUNTINFO*)
    AB_TRANSACTION* AB_ImExporterAccountInfo_GetNextTransaction(AB_IMEXPORTER_ACCOUNTINFO*)
    
    AB_ACCOUNT_STATUS* AB_ImExporterAccountInfo_GetFirstAccountStatus(AB_IMEXPORTER_ACCOUNTINFO*)
    AB_ACCOUNT_STATUS* AB_ImExporterAccountInfo_GetNextAccountStatus(AB_IMEXPORTER_ACCOUNTINFO*)


cdef class ImExporterContext:
    cdef AB_IMEXPORTER_CONTEXT* abContext
    cdef Banking banking
    cdef object itRef
        
    cdef AB_IMEXPORTER_CONTEXT* GetContext(self)
    

cdef class ImExporterAccountInfo:
    cdef ImExporterContext ctx
    cdef AB_IMEXPORTER_ACCOUNTINFO* abAccountInfo
    cdef object itTransactionRef, itAccountStatusRef
    
    cdef void SetAccountInfo(self, AB_IMEXPORTER_ACCOUNTINFO* accountInfo)