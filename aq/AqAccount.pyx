#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

from AqUser import UserIterator
from AqUser cimport UserIterator
from AqJob import JobGetBalance, JobGetTransactions 
from AqJob cimport JobGetBalance, JobGetTransactions

cdef class Account:
    #account types
    TYPE_UNKNOW       = AB_AccountType_Unknown
    TYPE_BANK         = AB_AccountType_Bank
    TYPE_CREDIT_CARD  = AB_AccountType_CreditCard
    TYPE_CHECKING     = AB_AccountType_Checking
    TYPE_SAVING       = AB_AccountType_Savings
    TYPE_INVESTMENT   = AB_AccountType_Investment
    TYPE_CASH         = AB_AccountType_Cash
    TYPE_MONEY_MARKET = AB_AccountType_MoneyMarket
    
    def __cinit__(self, Banking banking, uniqueId):
        self.banking = banking        
        #if there is magic, abAccount will be set via SetAccount
        if uniqueId is not self.banking.magic:
            self.abAccount = AB_Banking_GetAccount(self.banking.abInstance, uniqueId)
            if self.abAccount == NULL:
                raise RuntimeError("No account with id %s" % uniqueId)
        else:
            self.abAccount = NULL
    
    cdef void SetAccount(self, AB_ACCOUNT* account):
        self.abAccount = account
    
    def __dealloc__(self):
        self.banking = None        
    
    def __str__(self):
        return "aq.Account(%s)" % self.GetAccountName()
    
    def __repr__(self):
        return self.__str__()
    
    def GetBanking(self):
        return self.banking
    
    def GetAccountType(self):
        return AB_Account_GetAccountType(self.abAccount)
    
    def GetUniqueId(self):
        return AB_Account_GetUniqueId(self.abAccount)
    
    def GetBackendName(self):
        cdef char* name = AB_Account_GetBackendName(self.abAccount)
        if name == NULL:
            return None
        return name
    
    def GetAccountNumber(self):
        cdef char* number = AB_Account_GetAccountNumber(self.abAccount)
        if number == NULL:
            return None
        return number
    
    def GetBankCode(self):
        cdef char* code = AB_Account_GetBankCode(self.abAccount)
        if code == NULL:
            return None
        return code
    
    def GetAccountName(self):
        cdef char* name = AB_Account_GetAccountName(self.abAccount)
        if name == NULL:
            return None
        return name
    
    def GetBankName(self):
        cdef char* name = AB_Account_GetBankName(self.abAccount)
        if name == NULL:
            return None
        return name
    
    def GetIBAN(self):
        cdef char* iban = AB_Account_GetIBAN(self.abAccount)
        if iban == NULL:
            return None
        return iban
    
    def GetBIC(self):
        cdef char* bic = AB_Account_GetBIC(self.abAccount)
        if bic == NULL:
            return None
        return bic
    
    def GetOwnerName(self):
        cdef char* name = AB_Account_GetOwnerName(self.abAccount)
        if name == NULL:
            return None
        return name
    
    def GetCurrency(self):
        cdef char* currency = AB_Account_GetCurrency(self.abAccount)
        if currency == NULL:
            return None
        return currency
    
    def GetCountry(self):
        cdef char* country = AB_Account_GetCountry(self.abAccount)
        if country == NULL:
            return None
        return country
    
    def GetUsers(self):
        return list(self.IterUsers())
        
    def IterUsers(self):
        cdef UserIterator it = UserIterator(self.banking, self.banking.magic)
        it.SetUserList(AB_Account_GetUsers(self.abAccount))
        return it
    
    def NewJobGetBalance(self):
        cdef AB_JOB* abJob = AB_JobGetBalance_new(self.abAccount)
        if abJob == NULL:
            raise RuntimeError("Could not create job GetBalance")
        cdef JobGetBalance job = JobGetBalance(self, self.banking.magic)
        job.SetJob(abJob)
        return job
    
    def NewJobGetTransactions(self):
        cdef AB_JOB* abJob = AB_JobGetTransactions_new(self.abAccount)
        if abJob == NULL:
            raise RuntimeError("Could not create job GetTransactions")
        cdef JobGetTransactions job = JobGetTransactions(self, self.banking.magic)
        job.SetJob(abJob)
        return job
        

cdef class AccountIterator:
    def __cinit__(self, Banking banking, magic):
        if magic is not banking.magic:
            raise RuntimeError("Class can only be created on C level!")        
        self.banking = banking
        
    cdef void SetAccountList(self, AB_ACCOUNT_LIST2* accounts):
        self.accounts = accounts      
        if (self.accounts != NULL):
            self.it = AB_Account_List2_First(self.accounts)
            if (self.it != NULL):
                self.nextAccount = AB_Account_List2Iterator_Data(self.it)
            else:
                AB_Account_List2_free(self.accounts)            
                
    def __iter__(self):
        return self
    
    def __next__(self):
        if (self.nextAccount == NULL):
            raise StopIteration()
        cdef Account accountInst = Account(self.banking, self.banking.magic)
        accountInst.SetAccount(self.nextAccount)
        AB_Account_List2Iterator_Next(self.it)
        self.nextAccount = AB_Account_List2Iterator_Data(self.it)
        return accountInst        
    
    def __dealloc__(self):
        if self.accounts != NULL:
            AB_Account_List2_free(self.accounts)
            AB_Account_List2Iterator_free(self.it)