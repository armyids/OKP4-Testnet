# Real Estate Contracts

This repository contains a sample governance template for real estate contracts on the OKP4 blockchain. It demonstrates how to use the OKP4 Law Stone smart contract to define and enforce real estate transactions rules using Prolog, a logical programming language. This template is inspired by the [multiple-source example](https://github.com/okp4/contracts/tree/v2.0.0/contracts/okp4-law-stone/examples/multiple-sources) in the OKP4 Contracts repository.

## About The Program

Real estate transactions involve complex rules and often require enforcement and verification of these rules. On the blockchain, this verification can be decentralized and automated. OKP4 allows us to encode these rules in Prolog, a language well-suited to express complex logical conditions.

This template defines a few simple rules related to real estate transactions, such as verifying the identity of the buyer and seller, checking if the buyer has sufficient funds, and ensuring the seller is the owner of the property. This is done using three main concepts:

- **DID (Decentralized Identifier)**: This is a type of identifier that allows verifiable, decentralized digital identity. Each DID is unique to the entity it represents and can be resolved to a DID Document that contains data such as public keys and service endpoints, enabling secure, privacy-preserving communication and interaction.

- **PID (Property Identifier)**: A unique identifier for each property in the system. This identifier is used to track the ownership and transaction history of each property.

- **ToD (Transfer of Deed)**: The act of transferring ownership of a property from one entity to another. This is the core operation this contract governs.

## Program Dependency

This contract consists of two Prolog programs:

- `template.pl`: This file contains the main logic of the real estate transaction. It checks if the buyer has sufficient funds, if the seller owns the property, and whether the property ID is valid.
- `gov.pl`: This file is used to load the `template.pl` and define configuration predicates.

These files are loaded into the OKP4 Law Stone smart contract using the `consult(File).` predicate, with the `File` variable being an URI that resolves to the content of the `template.pl` file.

## Instantiate

First, the `template.pl` program must be stored on a `okp4-objectarium` and the `gov.pl` updated with the right URI in the `consult(File).` predicate.

We can store an object by providing its data in base64 encoded, we can pin the stored object to prevent it from being removed:

```
okp4d tx wasm execute $CONTRACT_ADDR \
    --from $ADDR \
    --gas 10000000 \
    --gas-prices 0.025uknow \
    "{\"store_object\":{\"data\": \"$(cat template.pl | base64)\",\"pin\":true}}"
```

The instantiate will take as parameters the base64 encoded program and the address of a `okp4-objectarium` contract, on which the program will be stored and pinned.

```
okp4d tx wasm instantiate $CODE_ID \
    --label "real-estate-governance" \
    --from $ADDR \
    --admin $ADMIN_ADDR \
    --gas 10000000 \
    --gas-prices 0.025uknow \
    "{\"program\":\"$(cat gov.pl | base64)\", \"storage_address\": \"$STORAGE_ADDR\"}"
```

You can retrieve the new `okp4-law-stone` smart contract address in the `_contract_address` instantiate attribute of the transaction.

## Query

The `Ask` query allows Prolog predicates to be evaluated against the underlying programs.

For example, to check if a transfer of ownership operation can be performed:

```
okp4d query wasm contract-state smart $CONTRACT_ADDR \
    "{\"ask\": {\"query\": \"can('transfer_ownership', 'did:key:okp41u6vp630kpjpxqp2p6xwagtlkzq58tw3zadwrgu')\"}}"
```

## Break

Only the smart contract admin can break the stone, if any.

```
okp4d tx wasm execute $CONTRACT_ADDR \
    --from $ADDR \
    --gas 10000000 \
    --gas-prices 0.025uknow \
    '"break_stone'
```

By breaking the stone, the program stored in the `okp4-objectarium` smart contract will be removed, or at least un-pinned, and you will not be able to query it anymore.

Please note that this is a draft and can be customized to suit your needs or preferences.
