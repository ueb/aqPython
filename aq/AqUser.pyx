#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

cdef class User:    
    def __cinit__(self, Banking banking, uniqueId):
        self.banking = banking        
        #if there is magic, abAccount will be set via SetAccount
        if uniqueId is not self.banking.magic:
            self.abUser = AB_Banking_GetUser(self.banking.abInstance, uniqueId)
            if self.abUser == NULL:
                raise RuntimeError("No user with id %s" % uniqueId)
        else:
            self.abUser = NULL
    
    cdef void SetUser(self, AB_USER* user):
        self.abUser = user
    
    def __dealloc__(self):
        self.banking = None        
    
    def __str__(self):
        return "aq.User(%s)" % self.GetUserName()
    
    def __repr__(self):
        return self.__str__()
    
    def GetBanking(self):
        return self.banking

    def IsModified(self):
        return AB_User_IsModified(self.abUser) > 0
    
    def GetUniqueId(self):
        return AB_User_GetUniqueId(self.abUser)

    def GetBackendName(self):
        cdef char* name = AB_User_GetBackendName(self.abUser)
        if name == NULL:
            return None
        return name
    
    def GetUserName(self):
        cdef char* name = AB_User_GetUserName(self.abUser)
        if name == NULL:
            return None
        return name
    
    def GetUserId(self):
        cdef char* id = AB_User_GetUserId(self.abUser)
        if id == NULL:
            return None
        return id        
    
    def GetCustomerId(self):
        cdef char* id = AB_User_GetCustomerId(self.abUser)
        if id == NULL:
            return None
        return id
    
    def GetCountry(self):
        cdef char* country = AB_User_GetCountry(self.abUser)
        if country == NULL:
            return None
        return country
    
    def GetBankCode(self):
        cdef char* code = AB_User_GetBankCode(self.abUser)
        if code == NULL:
            return None
        return code
    
    def GetLastSessionId(self):
        return AB_User_GetLastSessionId(self.abUser)
    
    
cdef class UserIterator:
    def __cinit__(self, Banking banking, magic):
        if magic is not banking.magic:
            raise RuntimeError("Class can only be created on C level!")
        self.banking = banking                
                
    cdef void SetUserList(self, AB_USER_LIST2* user):
        self.user = user
        if (self.user != NULL):
            self.it = AB_User_List2_First(self.user)
            if (self.it != NULL):
                self.nextUser = AB_User_List2Iterator_Data(self.it)
            else:
                AB_User_List2_free(self.user)
                
    def __iter__(self):
        return self
    
    def __next__(self):
        if (self.nextUser == NULL):
            raise StopIteration()
        cdef User userInst = User(self.banking, self.banking.magic)
        userInst.SetUser(self.nextUser)
        AB_User_List2Iterator_Next(self.it)
        self.nextUser = AB_User_List2Iterator_Data(self.it)
        return userInst        
    
    def __dealloc__(self):
        if self.user != NULL:
            AB_User_List2_free(self.user)
            AB_User_List2Iterator_free(self.it)    
