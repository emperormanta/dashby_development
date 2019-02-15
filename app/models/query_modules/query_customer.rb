module QueryModules
  module QueryCustomer
    def self.get_proposal(
      tokens,
      month
      )
      %(query{
        proposals(params: {token: #{tokens},month: #{month}}){
        project{
          id
          projectName
        }
        customer{
          name
        }
        product{
          name
          periodicFee{
            componentName
            quantity
            unit
            finalPrice
          }
        }
      }
      })
    end
    def self.get_sf(tokens, month)
      %(query{
        mousWithComponent(params: {token: #{tokens},month: #{month}}){
        mouProducts{
          name
          periodicFee{
            componentName
            finalPrice
            quantity
            unit
            componentType
            chargePeriod
          }
        }
        pic{
          email
        }
      }
      })
    end

    def self.get_proposal_user(token, month)
      %(query{
          user(token: "#{token}"){
            proposals(params: {month: #{month}}){
              project{
                id
                projectName
                pic{
                  fullName
                }
              }
              customer{
                 name
              }
              product{
                name
                periodicFee{
                  componentName
                  quantity
                  unit
                  finalPrice
                }
              }
            }
          }
        }
      )
    end

    def self.get_sf_user(token,month)
      %(query{
        user(token: "#{token}") {
          mousWithComponent(params: {month: #{month}}) {
            mouProducts {
              name
              periodicFee {
                componentName
                finalPrice
                quantity
                unit
                componentType
                chargePeriod
              }
            }
            pic {
              email
            }
          }
        }
      }
      )
    end

    def self.get_proposal_yearly(token)
      %(query{
          user(token: "#{token}"){
            proposalYearly{
              project{
                id
                projectName
                pic{
                  fullName
                }
              }
              customer{
                name
              }
              product{
                name
                periodicFee{
                  componentName
                  quantity
                  unit
                  finalPrice
                }
              }
              createdAt
            }
          }
        }
      )
    end
    
    def self.get_mou_yearly(token)
      %(query{
          user(token: "#{token}"){
            mousWithComponentYearly{
              projectId
              projectType
              pic{
                fullName
              }
              customer{
                name
              }
              mouProducts{
                name
                periodicFee{
                  finalPrice
                }
              }
              createdAt
            }
          }
        }
      )
    end
  end
end