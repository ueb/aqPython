import aq

b = aq.Banking("Test")
for account in b.IterAccounts():
    print "Account:", account.GetAccountName(), account.GetUniqueId(), account.GetAccountType()
    print "\tBackendName", account.GetBackendName()
    print "\tAccountNumber", account.GetAccountNumber()
    print "\tBankCode", account.GetBankCode()
    print "\tBankName", account.GetBankName()
    print "\tIBAN", account.GetIBAN()
    print "\tBIC", account.GetBIC()
    print "\tOwnerName", account.GetOwnerName()
    print "\tCurrency", account.GetCurrency()
    print "\tCountry", account.GetCountry()