#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

from weakref import ref

from AqAccountStatus cimport AccountStatus
from AqTransaction cimport Transaction

cdef class ImExporterContext:
    def __cinit__(self, Banking banking):
        self.abContext = AB_ImExporterContext_new();
        if self.abContext == NULL:
            raise RuntimeError("Could not create ImExporterContext!")

    def __init__(self, Banking banking):
        self.banking = banking
        self.itRef = None
        
    def __dealloc__(self):
        if self.abContext != NULL:
            AB_ImExporterContext_free(self.abContext)
            
    cdef AB_IMEXPORTER_CONTEXT* GetContext(self):
        return self.abContext
    
    def __iter__(self):
        if self.itRef is not None and self.itRef() is not None:
            raise RuntimeError("Only one ImExporterContextIterator can be created at the same time")
        it = ImExporterContextIterator(self, self.banking.magic)
        self.itRef = ref(it)
        return it
    
    def IterAccountInfos(self):
        return self.__iter__()
    
    def GetAccountInfos(self):
        return list(self.IterAccountInfos())
        
    
cdef class ImExporterContextIterator:
    cdef object __weakref__
    cdef ImExporterContext ctx
    cdef AB_IMEXPORTER_ACCOUNTINFO *nextAccountInfo
    
    def __init__(self, ImExporterContext ctx, magic):
        if magic is not ctx.banking.magic:
            raise RuntimeError("Class can only be created on C level!")        
        self.ctx = ctx
        self.nextAccountInfo = AB_ImExporterContext_GetFirstAccountInfo(self.ctx.abContext)
        
    def __iter__(self):
        return self
    
    def __next__(self):
        if (self.nextAccountInfo == NULL):
            raise StopIteration()
        cdef ImExporterAccountInfo accountInfo = ImExporterAccountInfo(self.ctx, self.ctx.banking.magic)
        accountInfo.SetAccountInfo(self.nextAccountInfo)
        self.nextAccountInfo = AB_ImExporterContext_GetNextAccountInfo(self.ctx.abContext)
        return accountInfo        
            
            
cdef class ImExporterAccountInfo:
    def __init__(self, ImExporterContext ctx, magic):
        if magic is not ctx.banking.magic:
            raise RuntimeError("Class can only be created on C level!")        
        self.ctx = ctx
        self.itTransactionRef = None
        self.itAccountStatusRef = None
        self.abAccountInfo = NULL
         
    cdef void SetAccountInfo(self, AB_IMEXPORTER_ACCOUNTINFO* accountInfo):
        self.abAccountInfo = accountInfo
        
    def GetBankCode(self):
        cdef char* result = AB_ImExporterAccountInfo_GetBankCode(self.abAccountInfo)
        if result == NULL:
            return None 
        return result

    def GetBankName(self):
        cdef char* result = AB_ImExporterAccountInfo_GetBankName(self.abAccountInfo)
        if result == NULL:
            return None 
        return result
    
    def GetAccountNumber(self):
        cdef char* result = AB_ImExporterAccountInfo_GetAccountNumber(self.abAccountInfo)
        if result == NULL:
            return None 
        return result
    
    def GetAccountName(self):
        cdef char* result = AB_ImExporterAccountInfo_GetAccountName(self.abAccountInfo)
        if result == NULL:
            return None 
        return result
    
    def GetIban(self):
        cdef char* result = AB_ImExporterAccountInfo_GetIban(self.abAccountInfo)
        if result == NULL:
            return None 
        return result
    
    def GetBic(self):
        cdef char* result = AB_ImExporterAccountInfo_GetBic(self.abAccountInfo)
        if result == NULL:
            return None 
        return result
    
    def GetCurrency(self):
        cdef char* result = AB_ImExporterAccountInfo_GetCurrency(self.abAccountInfo)
        if result == NULL:
            return None 
        return result
    
    def GetOwner(self):
        cdef char* result = AB_ImExporterAccountInfo_GetOwner(self.abAccountInfo)
        if result == NULL:
            return None 
        return result
    
    def GetType(self):
        return AB_ImExporterAccountInfo_GetType(self.abAccountInfo)
    
    def GetDescription(self):
        cdef char* result = AB_ImExporterAccountInfo_GetDescription(self.abAccountInfo)
        if result == NULL:
            return None 
        return result
    
    def GetAccountId(self):
        return AB_ImExporterAccountInfo_GetAccountId(self.abAccountInfo)
    
    def IterTransactions(self):
        if self.itTransactionRef is not None and self.itTransactionRef() is not None:
            raise RuntimeError("Only one TransactionIterator can be created at the same time")
        it = TransactionIterator(self, self.ctx.banking.magic)
        self.itTransactionRef = ref(it)
        return it
    
    def GetTransactions(self):
        return list(self.IterTransactions)
    
    def IterAccountStatus(self):
        if self.itAccountStatusRef is not None and self.itAccountStatusRef() is not None:
            raise RuntimeError("Only one AccountStatusIterator can be created at the same time")
        it = AccountStatusIterator(self, self.ctx.banking.magic)
        self.itAccountStatusRef = ref(it)
        return it
    
    def GetAccountStatus(self):
        return list(self.IterAccountStatus())    


cdef class TransactionIterator:
    cdef object __weakref__
    cdef ImExporterAccountInfo accountInfo
    cdef AB_TRANSACTION *nextTransaction
    
    def __init__(self, ImExporterAccountInfo accountInfo, magic):
        if magic is not accountInfo.ctx.banking.magic:
            raise RuntimeError("Class can only be created on C level!")        
        self.accountInfo = accountInfo
        self.nextTransaction = AB_ImExporterAccountInfo_GetFirstTransaction(self.accountInfo.abAccountInfo)
            
    def __iter__(self):
        return self
    
    def __next__(self):
        if (self.nextTransaction == NULL):
            raise StopIteration()
        cdef Transaction transaction = Transaction(self.accountInfo, self.accountInfo.ctx.banking.magic)
        transaction.SetTransaction(self.nextTransaction)
        self.nextTransaction = AB_ImExporterAccountInfo_GetNextTransaction(self.accountInfo.abAccountInfo)
        return transaction        


cdef class AccountStatusIterator:
    cdef object __weakref__
    cdef ImExporterAccountInfo accountInfo
    cdef AB_ACCOUNT_STATUS *nextAccountStatus
    
    def __init__(self, ImExporterAccountInfo accountInfo, magic):
        if magic is not accountInfo.ctx.banking.magic:
            raise RuntimeError("Class can only be created on C level!")        
        self.accountInfo = accountInfo
        self.nextAccountStatus = AB_ImExporterAccountInfo_GetFirstAccountStatus(self.accountInfo.abAccountInfo)
            
    def __iter__(self):
        return self
    
    def __next__(self):
        if (self.nextAccountStatus == NULL):
            raise StopIteration()
        cdef AccountStatus accountStatus = AccountStatus(self.accountInfo, self.accountInfo.ctx.banking.magic)
        accountStatus.SetAccountStatus(self.nextAccountStatus)
        self.nextAccountStatus = AB_ImExporterAccountInfo_GetNextAccountStatus(self.accountInfo.abAccountInfo)
        return accountStatus        
        
    