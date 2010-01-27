#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

from AqValue import Value
from AqValue cimport Value

cdef class Transaction:
    def __init__(self, ImExporterAccountInfo accountInfo, magic):
        if magic is not accountInfo.ctx.banking.magic:
            raise RuntimeError("Class can only be created on C level!")        
        self.accountInfo = accountInfo
        self.abTransaction = NULL
         
    cdef void SetTransaction(self, AB_TRANSACTION* transaction):
        self.abTransaction = transaction
        
    def GetValue(self):
        cdef AB_VALUE* abValue = AB_Transaction_GetValue(self.abTransaction)
        if abValue == NULL:
            return None 
        cdef Value value = Value(self.accountInfo.ctx.banking, self.accountInfo.ctx.banking.magic)
        value.SetValue(abValue)
        return value