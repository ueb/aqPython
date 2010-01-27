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
    ctypedef struct AB_USER
    ctypedef struct AB_USER_LIST2
    ctypedef struct AB_USER_LIST2_ITERATOR
    void AB_User_free(AB_USER*)
    AB_USER_LIST2_ITERATOR* AB_User_List2_First(AB_USER_LIST2*)
    void AB_User_List2Iterator_Next(AB_USER_LIST2_ITERATOR*)
    AB_USER* AB_User_List2Iterator_Data(AB_USER_LIST2_ITERATOR*)
    void AB_User_List2_free(AB_USER_LIST2*)
    void AB_User_List2Iterator_free(AB_USER_LIST2_ITERATOR*)
    
    void AB_User_free(AB_USER*)
#    void AB_User_Attach(AB_USER*)
#    int AB_User_ReadDb(AB_USER*, GWEN_DB_NODE*)
#    int AB_User_toDb(AB_USER*, GWEN_DB_NODE*)
    int AB_User_IsModified(AB_USER*)
#    void AB_User_SetModified (AB_USER*, int)
    uint32_t AB_User_GetUniqueId(AB_USER*)
#    void AB_User_SetUniqueId(AB_USER*, uint32_t)
    char* AB_User_GetBackendName(AB_USER*)
#    void AB_User_SetBackendName (AB_USER*, char*)
    char* AB_User_GetUserName(AB_USER*)
#    void AB_User_SetUserName (AB_USER*, char*)
    char* AB_User_GetUserId(AB_USER*)
#    void AB_User_SetUserId (AB_USER*, char*)
    char* AB_User_GetCustomerId(AB_USER*)
#    void AB_User_SetCustomerId (AB_USER*, char*)
    char* AB_User_GetCountry(AB_USER*)
#    void AB_User_SetCountry (AB_USER*, char*)
    char* AB_User_GetBankCode(AB_USER*)
#    void AB_User_SetBankCode (AB_USER*, char*)
    uint32_t AB_User_GetLastSessionId(AB_USER*)
#    void AB_User_SetLastSessionId (AB_USER*, uint32_t d)

cdef extern from "aqbanking/banking.h":
    AB_USER* AB_Banking_GetUser(AB_BANKING*, uint32_t)    

    
cdef class User:    
    cdef AB_USER* abUser
    cdef Banking banking
    
    cdef void SetUser(self, AB_USER* user)
    

cdef class UserIterator:
    cdef Banking banking
    cdef AB_USER* nextUser
    cdef AB_USER_LIST2* user
    cdef AB_USER_LIST2_ITERATOR* it
    
    cdef void SetUserList(self, AB_USER_LIST2* user)