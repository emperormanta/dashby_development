# Dashby Query Documentation

Value of proposal
-----
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
### Yearly
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

Revenue
------

### Monthly
```
query($token: String){
  revenue(userToken: $token){
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

### Yearly
```
query($token: String){
  revenueYearly(userToken: $token){
    target
    yearlyResult{
      name
      current
      percentage
      currentMonthTarget
    }
  }
}
```

Hit Rate
------

### Monthly
```
query($token: String){
  getHitRate(userToken: $token){
    target
    monthlyResult{
      name
      current
      percentage
      currentMonthTarget
    }
  }
}
```

### Yearly
```
query($token: String){
  getHitRateYearly(userToken: $token){
    target
    yearlyResult{
      name
      current
      percentage
      currentMonthTarget
    }
  }
}
```

Network Installation & Registration
-----

### Monthly
```
query($token: String){
  networkInstallationRegistration(userToken: $token){
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

### Yearly
```
query($token: String){
  networkInstallationRegistrationYearly(userToken: $token){
    target
    yearlyResult{
      name
      current
      percentage
      currentMonthTarget
    }
  }
}
```