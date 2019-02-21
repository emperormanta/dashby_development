module QueryModules
    module QueryXcost
        def self.get_costs(mou_ids)
            query = "query{
                getCosts(mouProductIds: #{mou_ids})
              }"
            return query
        end
    end
end