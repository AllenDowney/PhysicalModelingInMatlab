% retailer variables
Demand(1) = 4
RetInv(1) = 4
RetBack(1) = 0
Mail(1) = 4
RetCost(1) = 4

% factory variables
Production(1) = 4
FacInv(1) = 4
FacBack(1) = 0
Shipping(1) = 4
FacCost(1) = 4

for week = 2:52

    % what's the demand for the week?
    if week <= 4
        demand = 4
    else
        demand = 7
    end
    
    % retailer goes first; read last week's info
    onhand = RetInv(week-1)
    backlog = RetBack(week-1)
    received = Shipping(week-1)
    
    % add the backlog to this week's demand
    totalDemand = demand + backlog
    
    % if we have enough to meet demand, sell it; otherwise,
    % sell what we have
    shipping = min(onhand, totalDemand)

    % update inventory and backlog
    onhand = onhand - shipping + received
    backlog = totalDemand - shipping
    
    % place an order
    % strategy: order whatever was demanded, plus one for good luck
    myOrder = demand + 1

    % compute cost
    cost = onhand + 2 * backlog
    
    % store the updated values
    Demand(week) =  demand
    RetInv(week) = onhand
    RetBack(week) = backlog
    Mail(week) = myOrder
    RetCost(week) = cost

    % factory goes next
    % read last week's data
    newOrders = Mail(week-1)
    onhand = FacInv(week-1)
    backlog = FacBack(week-1)
    received = Production(week-1)

    % update inventory and backlog
    totalDemand = newOrders + backlog
    shipping = min(onhand, totalDemand)

    % update inventory and backlog
    onhand = onhand - shipping + received
    backlog = totalDemand - shipping
    
    % move units into production
    % strategy: start producing whatever was ordered
    % plus one for good luck
    myOrder = newOrders + 1
    
    % compute cost
    cost = onhand + 2 * backlog

    % store the updated values
    Production(week) =  myOrder
    FacInv(week) = onhand
    FacBack(week) = backlog
    Shipping(week) = shipping
    FacCost(week) = cost
end

