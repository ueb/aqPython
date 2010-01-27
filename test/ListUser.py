import aq

b = aq.Banking("Test")
for user in b.IterUsers():
    print "User:", user.GetUserName(), user.GetUniqueId()
    print "\tIsModified", user.IsModified()
    print "\tUserId", user.GetUserId()
    print "\tCustomerId", user.GetCustomerId()
    print "\tCountry", user.GetCountry()
    print "\tBankCode", user.GetBankCode()    