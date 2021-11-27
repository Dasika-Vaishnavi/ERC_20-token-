# Ethereum

Ethereum is a decentralized blockchain. A platform for smart contracts.

## Table of content

- [Accounts vs UTXOs](#accounts-vs-utxos)
  - [Merkle Patricia Trees](#merkle-patricia-trees)
- [Geth](#geth)
  - [Installation](#installation)
  - [Features](#features)
  - [Starting](#starting)
  - [Importing accounts](#importing-accounts)
  - [Interacting with Ethereum](#interacting-with-ethereum)
- [MetaMask](#metamask)
- [Infura](#infura)
- [Ethereum Explorer](#ethereum-explorer)
- [References](#references)
- [My ETH Address](#my-eth-address)

- [Smart Contracts](<Smart Contracts/>)
- [ERC-20](./ERC20/)
- [ERC-721](./ERC721/)
- [ERC-1155](./ERC1155/)
- [Truffle](./Truffle/)
- [Build a DEX from scratch](<Build a DEX from scratch/>)

## Accounts vs UTXOs

Bitcoin, along with many of its derivatives, stores data about users’ balances in a structure based on unspent transaction outputs (UTXOs): the entire state of the system consists of a set of “unspent outputs” (think, “coins”), such that each coin has an owner and a value, and a transaction spends one or more coins and creates one or more new coins, subject to the validity constraints:

1. Every referenced input must be valid and not yet spent
2. The transaction must have a signature matching the owner of the input for every input
3. The total value of the inputs must equal or exceed the total value of the outputs

A user’s “balance” in the system is thus the total value of the set of coins for which the user has a private key capable of producing a valid signature.

Triple-entry bookkeeping example
(Image from <https://bitcoin.org/en/developer-guide>)

Ethereum jettisons this scheme in favor of a simpler approach: the state stores a list of accounts where each account has a balance, as well as Ethereum-specific data (code and internal storage), and a transaction is valid if the sending account has enough balance to pay for it, in which case the sending account is debited and the receiving account is credited with the value. If the receiving account has code, the code runs, and internal storage may also be changed, or the code may even create additional messages to other accounts which lead to further debits and credits.

The benefits of UTXOs are:

1. Higher degree of privacy: if a user uses a new address for each transaction that they receive then it will often be difficult to link accounts to each other. This applies greatly to currency, but less to arbitrary dapps, as arbitrary dapps often necessarily involve keeping track of complex bundled state of users and there may not exist such an easy user state partitioning scheme as in currency.
2. Potential scalability paradigms: UTXOs are more theoretically compatible with certain kinds of scalability paradigms, as we can rely on only the owner of some coins maintaining a Merkle proof of ownership, and even if everyone including the owner decides to forget that data then only the owner is harmed. In an account paradigm, everyone losing the portion of a Merkle tree corresponding to an account would make it impossible to process messages that affect that account at all in any way, including sending to it. However, non-UTXO-dependent scalability paradigms do exist.

The benefits of accounts are:

1. Large space savings: for example, if an account has 5 UTXO, then switching from a UTXO model to an account model would reduce the space requirements from (20 + 32 + 8) * 5 = 300 bytes (20 for the address, 32 for the txid and 8 for the value) to 20 + 8 + 2 = 30 bytes (20 for the address, 8 for the value, 2 for a nonce(see below)). In reality savings are not nearly this massive because accounts need to be stored in a Patricia tree (see below) but they are nevertheless large. Additionally, transactions can be smaller (eg. 100 bytes in Ethereum vs. 200-250 bytes in Bitcoin) because every transaction need only make one reference and one signature and produces one output.
2. Greater fungibility: because there is no blockchain-level concept of the source of a specific set of coins, it becomes less practical, both technically and legally, to institute a redlist/blacklisting scheme and to draw a distinction between coins depending on where they come from.
3. Simplicity: easier to code and understand, especially once more complex scripts become involved. Although it is possible to shoehorn arbitrary decentralized applications into a UTXO paradigm, essentially by giving scripts the ability to restrict what kinds of UTXO a given UTXO can be spent to, and requiring spends to include Merkle tree proofs of change-of-application-state-root that scripts evaluate, such a paradigm is much more complicated and ugly than just using accounts.
4. Constant light client reference: light clients can at any point access all data related to an account by scanning down the state tree in a specific direction. In a UTXO paradigm, the references change with each transaction, a particularly burdensome problem for long-running dapps that try to use the above mentioned state-root-in-UTXO propagation mechanism.

We have decided that, particularly because we are dealing with dapps containing arbitrary state and code, the benefits of accounts massively outweigh the alternatives. Additionally, in the spirit of the We Have No Features principle, we note that if people really do care about privacy then mixers and coinjoin can be built via signed-data-packet protocols inside of contracts.

One weakness of the account paradigm is that in order to prevent replay attacks, every transaction must have a “nonce”, such that the account keeps track of the nonces used and only accepts a transaction if its nonce is 1 after the last nonce used. This means that even no-longer-used accounts can never be pruned from the account state. A simple solution to this problem is to require transactions to contain a block number, making them un-repayable after some period of time, and reset nonces once every period. Miners or other users will need to “ping” unused accounts in order to delete them from the state, as it would be too expensive to do a full sweep as part of the blockchain protocol itself. We did not go with this mechanism only to speed up development for 1.0; 1.1 and beyond will likely use such a system.

### Merkle Patricia Trees

The Merkle Patricia tree/trie, previously envisioned by Alan Reiner and implemented in the Ripple protocol, is the primary data structure of Ethereum, and is used to store all account state, as well as transactions and receipts in each block.

## Geth

> Official implementation of the Ethereum protocol in [Go](https://geth.ethereum.org/)

`Geth` is a command-line interface for the Ethereum blockchain. It is a full node, meaning that it is capable of maintaining the entire blockchain, including all transactions and state. It is also capable of running a light client, which is a subset of the full node that only contains the state of the chain and the current block.  

### Installation

```bash
sudo pacman -Syyuu geth nodejs
sudo npm install -g solc@latest
```

### Features

1. Running an Ethereum node
2. Communicating with Ethereum network
3. Sending transactions
4. Interacting with Smart Contracts
5. Creating accounts
6. Wallet Functionality
7. Mining and ...

### Starting

```bash
geth --goerli --ws --http --syncmode=light --http.api="eth,net,web3,personal,txpool" --allow-insecure-unlock  --http.corsdomain "*"
```

Data folder is `~/.ethereum/`.  
Accounts and Private Keys are stored in `~/.ethereum/keystore/`.  
For Testnet it is `~/.ethereum/testnet/`.

```bash
cd ~/.ethereum/rinkeby/
rm PRIVATE_KEYS, Account
```

### Importing accounts

```bash
geth account import ~/Data/myself/cryptocurrency-info-recovery/metamask/mforgood/D8_private_key
```

### Interacting with Ethereum

```bash
geth attach http://127.0.0.1:8545
web3.personal.importRawKey("11111111111111111111111111", "password")
personal.unlockAccount("0x540783999f4926a35fa30c804e13dd779072d204")
personal.listAccounts
eth.getBalance("0x540783999f4926a35fa30c804e13dd779072d204")
eth.getBalance(eth.accounts[1])
net.peerCount
eth.getCode("0xE683007C5BfB5BEBA5481C3e938dD4DC47cddbFC")
var voter = eth.contract([{"inputs":[{"internalType":"string","name":"option","type":"string"}],"name":"addOption","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getOptions","outputs":[{"internalType":"string[]","name":"","type":"string[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getVotes","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"options","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"remove","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"startVoting","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"option","type":"uint256"}],"name":"vote","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"optionName","type":"string"}],"name":"vote","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"votes","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]).at("0xE683007C5BfB5BEBA5481C3e938dD4DC47cddbFC");
voter
voter.addOption("mlibre" , {from: "0xD8f24D419153E5D03d614C5155f900f4B5C8A65C"})
```

## MetaMask

There are several ways to interact with the Ethereum blockchain.

- Running a local node with `Geth` for example
- Calling web APIs. for example [blockcypher](https://www.blockcypher.com/)
- ...

> **Metamask** is a client-side browser extension that provides a high-level javascript library to interact with the Ethereum network. [metamask.io](https://metamask.io/)

It is also a crypto wallet.  
On the backend side, it uses **infura** or other API providers to comminute with Ethereum blockchain.  
So basically you as a **developer** don't have to worry about making/signing/sending transactions, ...  
And as a **user**, it makes things much easier. for example, you don't have to sign a proof message to prove you are the owner of an address  
`MetaMask` is also offering other features custom network, ...

## Infura

> Ethereum & IPFS APIs [infura.io](https://infura.io/)

As it says they are providing APIs, so we can easily communicate with the Ethereum network. in the background, they probably have `geth` nodes or other kinds of nodes running.

## Ethereum Explorer

- <https://etherscan.io/>

- <https://rinkeby.etherscan.io/address/CONTRACT_ADDRESS>

## References

- <https://eth.wiki/en/fundamentals/design-rationale>

## My ETH Address

> 0xc9b64496986E7b6D4A68fDF69eF132A35e91838e