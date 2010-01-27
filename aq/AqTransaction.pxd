#===============================================================================
# copyright   : (C) 2009 by Markus Wintermann
# email       : devel@tmft.net
# 
# This file is part of the project "aqPython".                           
# Please see toplevel file COPYING of that project for license details.   
#===============================================================================

from AqImExporter cimport ImExporterAccountInfo

cdef extern from "aqbanking/value.h":
    ctypedef struct AB_VALUE

cdef extern from "aqbanking/transaction.h":
    ctypedef struct AB_TRANSACTION
    
    AB_VALUE* AB_Transaction_GetValue (AB_TRANSACTION*)


cdef class Transaction:
    cdef AB_TRANSACTION* abTransaction
    cdef ImExporterAccountInfo accountInfo
    
    cdef void SetTransaction(self, AB_TRANSACTION* transaction)