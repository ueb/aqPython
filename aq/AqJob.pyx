#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

from AqBase cimport datetime, DatetimeFromGwentime, GwentimeFromDatetime

cdef class JobList:
    def __init__(self):
        self.jobList = list()
        
    def __dealloc__(self):
        self.jobList = None
    
    cdef AB_JOB_LIST2* GetJobList(self):
        cdef AB_JOB_LIST2* jl = AB_Job_List2_new()
        if jl == NULL:
            raise RuntimeError("Could not creare JobList!")
        cdef Job job
        for job in self.jobList:
            AB_Job_List2_PushBack(jl, job.abJob)
        return jl            
    
    def append(self, Job job):
        self.jobList.append(job)        
    
    def __len__(self):
        return len(self.jobList)
    
    def __getitem__(self, x):
        return self.jobList[x]
    
    def __setitem__(self, x, Job y):
        self.jobList[x] = y
    
    def __delitem__(self, x):
        del self.jobList[x]
    
    def __contains__(self, Job x):
        return x in self.jobList
    
    def __iter__(self):
        return self.jobList.__iter__()    


cdef class Job:
    def __cinit__(self, Account account, magic):
        if magic is not account.banking.magic:
            raise RuntimeError("Class can only be created on C level!")
        self.account = account
    
    cdef void SetJob(self, AB_JOB* job):            
        self.abJob = job;
        if AB_Job_CheckAvailability(self.abJob, 0) != 0:
            raise RuntimeError("Job is not available for this account!")
        
    def __dealloc__(self):
        if self.abJob != NULL:
            AB_Job_free(self.abJob)
        self.account = None
    
    def GetJobId(self):
        return AB_Job_GetJobId(self.abJob)
    
    def GetCreatedBy(self):
        return AB_Job_GetCreatedBy(self.abJob)
    
    def GetStatus(self):
        return AB_Job_GetStatus(self.abJob)
    
    def GetLastStatusChange(self):
        cdef GWEN_TIME* gwTime = AB_Job_GetLastStatusChange(self.abJob)
        if gwTime == NULL:
            return None
        return DatetimeFromGwentime(gwTime)
    
    def GetType(self):
        return AB_Job_GetType(self.abJob)
    
    def GetAccount(self):
        return self.account
    
    def GetResultText(self):
        return AB_Job_GetResultText(self.abJob)
    
    def GetUsedTan(self):
        return AB_Job_GetUsedTan(self.abJob)
    
    
cdef class JobGetBalance(Job):
    pass


cdef class JobGetTransactions(Job):
    pass
#    def SetFromTime(self, datetime dt not None):
#        cdef GWEN_TIME *gt = GwentimeFromDatetime(dt)
