% Check if a DID is valid for a buyer or seller
valid_did(DID, Addr) :- 
    did_components(DID, did(Method, Addr, _, _, _)), 
    allow_did_method(Method), 
    allow_addr(Addr).

% Check if a PID is valid
valid_pid(PID) :-
    pid_components(PID, pid(_, Addr, _, _, _)),
    allow_addr(Addr).

% Check if a buyer has sufficient funds
has_sufficient_balance(BuyerDID, PropertyPrice) :-
    valid_did(BuyerDID, Addr),
    bank_spendable_balances(Addr, Balances),
    member(Denom-Amount, Balances),
    allow_denom(Denom),
    Amount @>= PropertyPrice.

% Check if a seller owns the property
owns_property(SellerDID, PID) :-
    valid_did(SellerDID, Addr),
    valid_pid(PID),
    property_owner(PID, OwnerDID),
    OwnerDID = SellerDID.

% Allow for the transfer of ownership if all conditions are met
can(transfer_ownership, BuyerDID, SellerDID, PID, PropertyPrice) :-
    valid_did(BuyerDID, BuyerAddr),
    valid_did(SellerDID, SellerAddr),
    valid_pid(PID),
    has_sufficient_balance(BuyerDID, PropertyPrice),
    owns_property(SellerDID, PID).
