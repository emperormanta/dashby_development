# Dashby Query Documentation

Value of proposal
-----

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

```
query($token: String){
  getHitRate(userToken: $token){
    target
    monthlyResult{
      name
      current
      percentage
      lastMonth
    }
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
    yearlyResult{
      name
      current
      percentage
      currentMonthTarget
    }
  }
}
```

New User
------

```
query($token: String){
  newUser(userToken: $token){
    target
    monthlyResult{
      name
      current
      percentage
      lastMonth
    }
    yearlyResult{
      name
      current
      percentage
      currentMonthTarget
    }
  }
}
```