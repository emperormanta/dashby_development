module QueryModules
  module QueryCustomer
    def self.get_proposal(tokens, month)
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

    def self.get_proposal_user(token, month, year)
      %(query{
          user(token: "#{token}"){
            proposals(params: {month: #{month}, year: #{year}}){
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

    def self.get_sf_user(token, month, year)
      %(query{
        user(token: "#{token}") {
          mousWithComponent(params: {month: #{month}, year: #{year}}) {
            mouId
            mouProducts {
              id
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
            paymentDate
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
              mouId
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

    def self.get_mou_dashby(token, month)
      query = "{
        getMouDashby(token: \"#{token}\", monthPaymentDate: #{month})
        {
          mouId
          projectId
          paymentStatus
          paymentDate
        }
      }"
    end

    def self.get_proposal_dashby(project_id)
      query = "{
        getProposalDashby(projectId: #{project_id}){
          id
          projectId
          createdAt
        }
      }"
    end

    def self.get_target_portofolio(token)
      %({
        user(token: "#{token}"){
          getTargetPortofolioCrm{
            customer {
              name
              id  
            }
            mouProductId
            product {
              name
              periodicFee {
                finalPrice
              }
            }
          }
        }
      })
    end

    def self.get_active_portofolio(token, month)
      %({
        user(token: "#{token}"){
          getActivePortofolioCrm(month: #{month}){
            customer {
              name
              id  
            }
            mouProductId
            product {
              name
              periodicFee {
                finalPrice
              }
              activeDate
              endContract
              parentProduct {
                name
                activeDate
              }
            }
          }
        }
      })
    end

    def self.get_installation_registration_fee(token, month, year)
      %(query{
        user(token: "#{token}") {
          mousWithComponent(params: {month: #{month}, year: #{year}}) {
            mouId
            mouProducts {
              id
              name
              installationFee {
                finalPrice
              }
              registrationFee {
                finalPrice
              }
            }
            paymentDate
            pic {
              email
            }
          }
        }
      }
      )
    end

    def self.get_registration_fee(token, month)
      %(query{
        user(token: "#{token}") {
          mousWithComponent(params: {month: #{month}}) {
            mouId
            mouProducts {
              id
              name
              registrationFee {
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
  end
end