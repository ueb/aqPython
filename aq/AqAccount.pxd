#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

from AqBanking cimport Banking 

cdef extern from "inttypes.h":
    ctypedef unsigned long uint32_t

cdef extern from "aqbanking/banking.h":
    ctypedef struct AB_BANKING
    
cdef extern from "aqbanking/user.h":
    ctypedef struct AB_USER_LIST2
    
cdef extern from "aqbanking/account.h":
    ctypedef struct AB_ACCOUNT
    ctypedef struct AB_ACCOUNT_LIST2
    ctypedef struct AB_ACCOUNT_LIST2_ITERATOR
    
    ctypedef enum AB_ACCOUNT_TYPE:
        AB_AccountType_Unknown = 0
        AB_AccountType_Bank
        AB_AccountType_CreditCard
        AB_AccountType_Checking
        AB_AccountType_Savings
        AB_AccountType_Investment
        AB_AccountType_Cash
        AB_AccountType_MoneyMarket
    
    void AB_Account_free(AB_ACCOUNT*)
    
    AB_ACCOUNT_LIST2_ITERATOR* AB_Account_List2_First(AB_ACCOUNT_LIST2*)
    void AB_Account_List2Iterator_Next(AB_ACCOUNT_LIST2_ITERATOR*)
    AB_ACCOUNT* AB_Account_List2Iterator_Data(AB_ACCOUNT_LIST2_ITERATOR*)
    void AB_Account_List2_free(AB_ACCOUNT_LIST2*)
    void AB_Account_List2Iterator_free(AB_ACCOUNT_LIST2_ITERATOR*)

    AB_ACCOUNT_TYPE AB_Account_GetAccountType(AB_ACCOUNT*)
    void AB_Account_SetAccountType(AB_ACCOUNT*, AB_ACCOUNT_TYPE)
    uint32_t AB_Account_GetUniqueId(AB_ACCOUNT*)
    #void AB_Account_SetUniqueId(AB_ACCOUNT*, uint32_t id)
    char* AB_Account_GetBackendName(AB_ACCOUNT*)
    #AB_PROVIDER * AB_Account_GetProvider(AB_ACCOUNT*)
    char* AB_Account_GetAccountNumber(AB_ACCOUNT*)
    #void AB_Account_SetAccountNumber(AB_ACCOUNT*, char*)
    char* AB_Account_GetBankCode(AB_ACCOUNT*)
    #void AB_Account_SetBankCode(AB_ACCOUNT*, char*)
    char* AB_Account_GetAccountName(AB_ACCOUNT*)
    #void AB_Account_SetAccountName(AB_ACCOUNT*, char*)
    char* AB_Account_GetBankName(AB_ACCOUNT*)
    #void AB_Account_SetBankName(AB_ACCOUNT*, char*)
    char* AB_Account_GetIBAN(AB_ACCOUNT*)
    #void AB_Account_SetIBAN(AB_ACCOUNT*, char*)
    char* AB_Account_GetBIC(AB_ACCOUNT*)
    #void AB_Account_SetBIC(AB_ACCOUNT*, char*)
    char* AB_Account_GetOwnerName(AB_ACCOUNT*)
    #void AB_Account_SetOwnerName(AB_ACCOUNT*, char*)
    char* AB_Account_GetCurrency(AB_ACCOUNT*)
    #void AB_Account_SetCurrency(AB_ACCOUNT*, char*)
    char* AB_Account_GetCountry(AB_ACCOUNT*)
    #void AB_Account_SetCountry(AB_ACCOUNT*, char*)
    AB_USER_LIST2* AB_Account_GetUsers(AB_ACCOUNT*)
    #AB_USER* AB_Account_GetFirstUser(AB_ACCOUNT*)
    #void AB_Account_SetUsers(AB_ACCOUNT*, AB_USER_LIST2)
    #void AB_Account_SetUser(AB_ACCOUNT*, AB_USER*)
    #AB_USER_LIST2* AB_Account_GetSelectedUsers(AB_ACCOUNT*)
    #AB_USER* AB_Account_GetFirstSelectedUser(AB_ACCOUNT*)
    #void AB_Account_SetSelectedUsers(AB_ACCOUNT*, AB_USER_LIST2*)
    #void AB_Account_SetSelectedUser(AB_ACCOUNT*, AB_USER*)
    
cdef extern from "aqbanking/banking.h":
    AB_ACCOUNT* AB_Banking_GetAccount(AB_BANKING*, uint32_t)

cdef extern from "aqbanking/job.h":
    ctypedef struct AB_JOB
    
cdef extern from "aqbanking/jobgetbalance.h":
    AB_JOB* AB_JobGetBalance_new(AB_ACCOUNT*)
cdef extern from "aqbanking/jobgettransactions.h":
    AB_JOB* AB_JobGetTransactions_new(AB_ACCOUNT*)

    
cdef class Account:    
    cdef AB_ACCOUNT* abAccount
    cdef Banking banking
    
    cdef void SetAccount(self, AB_ACCOUNT* account)
    
cdef class AccountIterator:
    cdef Banking banking
    cdef AB_ACCOUNT* nextAccount
    cdef AB_ACCOUNT_LIST2* accounts
    cdef AB_ACCOUNT_LIST2_ITERATOR* it
    
    cdef void SetAccountList(self, AB_ACCOUNT_LIST2* accounts)