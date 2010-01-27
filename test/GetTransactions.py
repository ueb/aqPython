import aq

b = aq.Banking()
a = b.GetAccounts()[1]
jl = aq.JobList()
jl.append(a.NewJobGetTransactions())
ctx = b.ExecuteJobs(jl)
for accountInfo in ctx.IterAccountInfos():
    for accountStatus in accountInfo.IterAccountStatus():
        balance = accountStatus.GetBookedBalance()
        print "Booked balance:", balance.GetValue(), "on", balance.GetTime().isoformat()