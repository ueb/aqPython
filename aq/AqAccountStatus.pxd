#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================
from AqValue cimport Value, AB_VALUE
from AqImExporter cimport ImExporterAccountInfo

cdef extern from "gwenhywfar/gwentime.h":
    ctypedef struct GWEN_TIME

cdef extern from "aqbanking/balance.h":
    ctypedef struct AB_BALANCE
    
    AB_VALUE* AB_Balance_GetValue(AB_BALANCE*)
#    void AB_Balance_SetValue(AB_BALANCE*, AB_VALUE*)
    GWEN_TIME* AB_Balance_GetTime(AB_BALANCE*)

cdef extern from "aqbanking/accstatus.h":
    ctypedef struct AB_ACCOUNT_STATUS
    
    GWEN_TIME* AB_AccountStatus_GetTime(AB_ACCOUNT_STATUS*)
#    void AB_AccountStatus_SetTime(AB_ACCOUNT_STATUS*, const GWEN_TIME *t)
    AB_VALUE* AB_AccountStatus_GetBankLine(AB_ACCOUNT_STATUS*)
#    void AB_AccountStatus_SetBankLine(AB_ACCOUNT_STATUS*, AB_VALUE*)
    AB_VALUE* AB_AccountStatus_GetDisposable(AB_ACCOUNT_STATUS*)
#    void AB_AccountStatus_SetDisposable(AB_ACCOUNT_STATUS*, AB_VALUE*)
    AB_VALUE* AB_AccountStatus_GetDisposed(AB_ACCOUNT_STATUS*)
#    void AB_AccountStatus_SetDisposed(AB_ACCOUNT_STATUS*, AB_VALUE*)
    AB_BALANCE* AB_AccountStatus_GetBookedBalance(AB_ACCOUNT_STATUS*)
#    void AB_AccountStatus_SetBookedBalance(AB_ACCOUNT_STATUS*, AB_BALANCE*)
    AB_BALANCE* AB_AccountStatus_GetNotedBalance(AB_ACCOUNT_STATUS*)
#    void AB_AccountStatus_SetNotedBalance(AB_ACCOUNT_STATUS*, AB_BALANCE*)


cdef class AccountStatus:
    cdef AB_ACCOUNT_STATUS* abAccStatus
    cdef ImExporterAccountInfo accountInfo

    cdef void SetAccountStatus(self, AB_ACCOUNT_STATUS* accountStatus)
    

cdef class Balance:
    cdef AB_BALANCE* abBalance
    cdef AccountStatus accountStatus
    
    cdef void SetBalance(self, AB_BALANCE* balance)

