#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

from AqBanking cimport Banking

cdef class Value:
    def __init__(self, Banking banking, magic):
        if magic is not banking.magic:
            raise RuntimeError("Class can only be created on C level!")        
        self.abValue = NULL
         
    cdef void SetValue(self, AB_VALUE* value):
        self.abValue = value
        
    def ToFloat(self):
        return AB_Value_GetValueAsDouble(self.abValue)
    
    def __str__(self):
        return str(self.ToFloat())