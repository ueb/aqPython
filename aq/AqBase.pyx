
cdef datetime DatetimeFromGwentime(GWEN_TIME* gt):
    cdef int year, month, day, hour, minute, second
    GWEN_Time_GetBrokenDownTime(gt, &hour, &minute, &second)
    GWEN_Time_GetBrokenDownDate(gt, &day, &month, &year) 
    return PyDateTime_FromDateAndTime(year, month, day, hour, minute, second, 0)

cdef GWEN_TIME *GwentimeFromDatetime(datetime dt):
    return GWEN_Time_new(PyDateTime_GET_YEAR(dt),
                         PyDateTime_GET_MONTH(dt),
                         PyDateTime_GET_DAY(dt),
                         PyDateTime_DATE_GET_HOUR(dt),
                         PyDateTime_DATE_GET_MINUTE(dt),
                         PyDateTime_DATE_GET_SECOND(dt),
                         0)
    
PyDateTime_IMPORT