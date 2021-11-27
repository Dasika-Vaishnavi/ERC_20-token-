# Ethereum Smart Contracts

A **Smart Contract** is simply a program that runs on the Ethereum blockchain. It's a collection of code (its functions) and data (its state) that resides at a specific address on the Ethereum blockchain.

This folder has a **Voter**, a **multi signature wallet** and a **Crowd Funding With Deadline** smart contract.

## Table of content

* [Compiling SCs using solcjs](#compiling-scs-using-solcjs)
* [Examples](#examples)
  * [Voter](voter/readme.md)
  * [Multi signature wallet](multi-sig-wallet/readme.md)
  * [Crowd Funding With Deadline](crowd-funding-with-deadline/readme.md)
  * [Crowd-funding-using-library](crowd-funding-using-library/readme.md)
* [References](#references)

## Compiling SCs using solcjs

```bash
solcjs crowd-funding-with-deadline.sol -o ./bin/ --pretty-json --optimize  --abi --bin
```

## References

* <https://ethereum.org/en/developers/docs/smart-contracts/>
