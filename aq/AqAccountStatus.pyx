#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

from AqBase cimport DatetimeFromGwentime

cdef class Balance:
    def __init__(self, AccountStatus accountStatus, magic):
        if magic is not accountStatus.accountInfo.ctx.banking.magic:
            raise RuntimeError("Class can only be created on C level!")        
        self.accountStatus = accountStatus
        self.abBalance = NULL
         
    cdef void SetBalance(self, AB_BALANCE* balance):
        self.abBalance = balance
        
    def GetValue(self):
        cdef AB_VALUE* abValue = AB_Balance_GetValue(self.abBalance)
        if abValue == NULL:
            return None
        cdef Value value = Value(self.accountStatus.accountInfo.ctx.banking, self.accountStatus.accountInfo.ctx.banking.magic)
        value.SetValue(abValue)
        return value
    
    def GetTime(self):
        cdef GWEN_TIME* gwTime = AB_Balance_GetTime(self.abBalance)
        if gwTime == NULL:
            return None
        return DatetimeFromGwentime(gwTime)
    

cdef class AccountStatus:
    def __init__(self, ImExporterAccountInfo accountInfo, magic):
        if magic is not accountInfo.ctx.banking.magic:
            raise RuntimeError("Class can only be created on C level!")        
        self.accountInfo = accountInfo
        self.abAccStatus = NULL
         
    cdef void SetAccountStatus(self, AB_ACCOUNT_STATUS* accountStatus):
        self.abAccStatus = accountStatus
        
    def GetTime(self):        
        cdef GWEN_TIME* gwTime = AB_AccountStatus_GetTime(self.abAccStatus)
        if gwTime == NULL:
            return None
        return DatetimeFromGwentime(gwTime)
    
    def GetBankline(self):
        cdef AB_VALUE* abValue = AB_AccountStatus_GetBankLine(self.abAccStatus)
        if abValue == NULL:
            return None
        cdef Value value = Value(self.accountInfo.ctx.banking, self.accountInfo.ctx.banking.magic)
        value.SetValue(abValue)
        return value
    
    def GetDisposable(self):
        cdef AB_VALUE* abValue = AB_AccountStatus_GetDisposable(self.abAccStatus)
        if abValue == NULL:
            return None
        cdef Value value = Value(self.accountInfo.ctx.banking, self.accountInfo.ctx.banking.magic)
        value.SetValue(abValue)
        return value
    
    def GetDisposed(self):
        cdef AB_VALUE* abValue = AB_AccountStatus_GetDisposed(self.abAccStatus)
        if abValue == NULL:
            return None
        cdef Value value = Value(self.accountInfo.ctx.banking, self.accountInfo.ctx.banking.magic)
        value.SetValue(abValue)
        return value

    def GetBookedBalance(self):
        cdef AB_BALANCE* abBalance = AB_AccountStatus_GetBookedBalance(self.abAccStatus)
        if abBalance == NULL:
            return None
        cdef Balance balance = Balance(self, self.accountInfo.ctx.banking.magic)
        balance.SetBalance(abBalance)
        return balance

    def GetNotedBalance(self):
        cdef AB_BALANCE* abBalance = AB_AccountStatus_GetNotedBalance(self.abAccStatus)
        if abBalance == NULL:
            return None
        cdef Balance balance = Balance(self, self.accountInfo.ctx.banking.magic)
        balance.SetBalance(abBalance)
        return balance    