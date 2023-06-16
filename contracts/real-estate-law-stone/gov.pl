% Load template.pl
consult('cosmwasm:okp4-objectarium:okp41lppz4x9dtmccek2m6cezjlwwzup6pdqrkvxjpk95806c3dewgrfq602kgx?query=%7B%22object_data%22%3A%7B%22id%22%3A%20%22f3f749569fb40cbb89a9a11bc65c351e58c5f2b09b933220651148eafb147e1c%22%7D%7D.

% Define the admin address
admin_addr('okp41u6vp630kpjpxqp2p6xwagtlkzq58tw3zadwrgu').

% Allow the 'key' DID method
allow_did_method('key').

% Allow 'okp4' addresses
allow_addr(Addr) :- bech32_address(-('okp4', _), Addr).

% Allow 'uknow' as the denomination for transactions
allow_denom('uknow').

% Define a minimum transaction amount for a property purchase
min_property_purchase_amount(1000000).
