#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

cdef extern from "gwenhywfar/gwentime.h":
    ctypedef struct GWEN_TIME
    GWEN_TIME *GWEN_Time_new(int, int, int, int, int, int, int)
    int GWEN_Time_GetBrokenDownTime(GWEN_TIME*, int*, int*, int*)
    int GWEN_Time_GetBrokenDownDate(GWEN_TIME*, int*, int*, int*)
    
cdef extern from "cobject.h":
    pass #needed by PyDateTime_IMPORT

cdef extern from "datetime.h":
    ctypedef class datetime.datetime [object PyDateTime_DateTime]:
        pass
    void PyDateTime_IMPORT()
    datetime PyDateTime_FromDateAndTime(int, int, int, int, int, int, int)
    int PyDateTime_GET_YEAR(datetime)
    int PyDateTime_GET_MONTH(datetime)
    int PyDateTime_GET_DAY(datetime)
    int PyDateTime_DATE_GET_HOUR(datetime)
    int PyDateTime_DATE_GET_MINUTE(datetime)
    int PyDateTime_DATE_GET_SECOND(datetime)
    
cdef datetime DatetimeFromGwentime(GWEN_TIME* gt)
cdef GWEN_TIME *GwentimeFromDatetime(datetime dt)