# Dashby Query Documentation
## Value of proposal

### Monthly
```
query($token: String){
  valueOfProposal(userToken: $token){
    target
    monthlyResult{
      name
      current
      percentage
      lastMonth
    }
  }
}
```
## Yearly
```
query($token: String){
  valueOfProposalYearly(userToken: $token){
    target
    yearlyResult{
      name
      current
      currentMonthTarget
    }
  }
}
```