#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

cdef extern from "aqbanking/value.h":
    ctypedef struct AB_VALUE
    
    double AB_Value_GetValueAsDouble(AB_VALUE*)


cdef class Value:
    cdef AB_VALUE* abValue
    
    cdef void SetValue(self, AB_VALUE* value)