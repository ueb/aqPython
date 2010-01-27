#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

import traceback

from AqAccount import AccountIterator
from AqAccount cimport AccountIterator
from AqUser import UserIterator
from AqUser cimport UserIterator
from AqJob cimport JobList
from AqImExporter import ImExporterContext
from AqImExporter cimport ImExporterContext


cdef class Banking:
    def __cinit__(self, name="aqPython"):
        self.abInstance = AB_Banking_new(name, <char*> NULL, 0)
        if self.abInstance == NULL:
            raise RuntimeError("abinstance is NULL")
        
        if AB_Banking_Init(self.abInstance) != 0 \
        or AB_Banking_OnlineInit(self.abInstance, 0) != 0:
            AB_Banking_free(self.abInstance)
            raise RuntimeError("Could not init abinstance")
        AB_Banking_SetUserData(self.abInstance, <void*> self)
        self.magic = object()
	                
    def GetVersion(self):
        cdef int major, minor, patch, build
        AB_Banking_GetVersion (&major, &minor, &patch, &build)
        return major, minor, patch, build
    
    def GetAccounts(self):
        return list(self.IterAccounts())
        
    def IterAccounts(self):
        cdef AccountIterator it = AccountIterator(self, self.magic) 
        it.SetAccountList(AB_Banking_GetAccounts(self.abInstance))  
        return it
    
    def GetUsers(self):
        return list(self.IterUsers())
        
    def IterUsers(self):
        cdef UserIterator it = UserIterator(self, self.magic)
        it.SetUserList(AB_Banking_GetUsers(self.abInstance))
        return it
    
    def ExecuteJobs(self, JobList jobList not None):
        cdef AB_JOB_LIST2* jl = jobList.GetJobList()
        cdef ImExporterContext ctx = ImExporterContext(self)
        result = AB_Banking_ExecuteJobs(self.abInstance, jl, ctx.GetContext(), 0)
        AB_Job_List2_free(jl)
        if result != 0:
            raise RuntimeError("Could not execute jobs!")
        return ctx
    
    def __dealloc__(self):
        if self.abInstance != NULL:
            AB_Banking_OnlineFini(self.abInstance, 0)
            AB_Banking_Fini(self.abInstance)
            AB_Banking_free(self.abInstance)
  
cdef GWEN_GUI *gui

gui=GWEN_Gui_CGui_new()
GWEN_Gui_SetGui(gui) 

#cdef Banking GetInstance(AB_BANKING *ab):
#    cdef Banking b
#    b = <Banking> AB_Banking_GetUserData(ab)
#    return b