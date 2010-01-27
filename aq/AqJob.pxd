#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

from AqBanking cimport Banking
from AqAccount cimport Account

cdef extern from "inttypes.h":
    ctypedef unsigned long uint32_t
    
cdef extern from "gwenhywfar/gwentime.h":
    ctypedef struct GWEN_TIME
    
cdef extern from "aqbanking/account.h":
    ctypedef struct AB_ACCOUNT

cdef extern from "aqbanking/job.h":
    ctypedef struct AB_JOB
    ctypedef struct AB_JOB_LIST2
    ctypedef struct AB_JOB_LIST2_ITERATOR
    
    ctypedef enum AB_JOB_STATUS:
        AB_Job_StatusNew = 0
        AB_Job_StatusUpdated
        AB_Job_StatusEnqueued
        AB_Job_StatusSent
        AB_Job_StatusPending
        AB_Job_StatusFinished
        AB_Job_StatusError
        AB_Job_StatusUnknown = 999

    ctypedef enum AB_JOB_TYPE:
        AB_Job_TypeUnknown = 0
        AB_Job_TypeGetBalance
        AB_Job_TypeGetTransactions
        AB_Job_TypeTransfer
        AB_Job_TypeDebitNote
        AB_Job_TypeEuTransfer
        AB_Job_TypeGetStandingOrders
        AB_Job_TypeGetDatedTransfers
        AB_Job_TypeCreateStandingOrder
        AB_Job_TypeModifyStandingOrder
        AB_Job_TypeDeleteStandingOrder
        AB_Job_TypeCreateDatedTransfer
        AB_Job_TypeModifyDatedTransfer
        AB_Job_TypeDeleteDatedTransfer
        AB_Job_TypeInternalTransfer
        AB_Job_TypeLoadCellPhone
        AB_Job_TypeSepaTransfer
        AB_Job_TypeSepaDebitNote

    void AB_Job_free(AB_JOB*)
    
    AB_JOB_LIST2* AB_Job_List2_new()
    void AB_Job_List2_PushBack(AB_JOB_LIST2*, AB_JOB*)
    
    uint32_t AB_Job_GetJobId(AB_JOB*)
    char* AB_Job_GetCreatedBy(AB_JOB*)
    #GWEN_DB_NODE* AB_Job_GetAppData(AB_JOB*)
    int AB_Job_CheckAvailability(AB_JOB*, uint32_t)
    AB_JOB_STATUS AB_Job_GetStatus(AB_JOB*)
    #void AB_Job_SetStatus(AB_JOB*, AB_JOB_STATUS)
    GWEN_TIME* AB_Job_GetLastStatusChange(AB_JOB*)
    AB_JOB_TYPE AB_Job_GetType(AB_JOB*)
    AB_ACCOUNT* AB_Job_GetAccount(AB_JOB*)
    char* AB_Job_GetResultText(AB_JOB*)
    char* AB_Job_GetUsedTan(AB_JOB*)

    
cdef class JobList:
    cdef object jobList
    cdef AB_JOB_LIST2* GetJobList(self)


cdef class Job:    
    cdef AB_JOB* abJob
    cdef Account account
    
    cdef void SetJob(self, AB_JOB* job)
    
cdef class JobGetBalance(Job): pass
cdef class JobGetTransactions(Job): pass
