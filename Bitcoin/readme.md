# Bitcoin

A blockchain is a growing list of records, called blocks, which are linked together by cryptography.  
Each block contains a cryptographic hash of the previous block, a timestamp, and a list of transactions.  
A block is simply a public distributed ledger, and bitcoin is a blockchain.

## Table of content

- [Bitcoin address and wallet](#bitcoin-address-and-wallet)
  - [Address](#address)
  - [Wallet](#wallet)
- [Transaction inputs and outputs](#transaction-inputs-and-outputs)
- [Longest chain](#longest-chain)
- [Double Spending](#double-spending)
- [Where do bitcoins come from?](#where-do-bitcoins-come-from)
- [Key-pairs](#key-pairs)
- [References](#references)
- [My bitcoin Address](#my-bitcoin-address)

## Bitcoin address and wallet

There is no such thing as a Wallet in the Bitcoin network. It is abstract.  

### Address

An address is a hash of a bitcoin public-key wallet.  
You can use an address as many as you want to send and receive bitcoin.

### Wallet

A wallet contains key-pairs, created addresses, and ...  

## Transaction Inputs and outputs

- Inputs. This contains information about the bitcoin previously sent to Mark's address. For example, imagine Mark previously received 0.6 BTC from Alice and 0.6 BTC from Bob. Now, in order to send 1 BTC to Jessica, there might be two inputs: one input of 0.6 BTC previously from Alice and one input of 0.6 BTC previously from Bob.
- Amount. In this case, the amount Mark wants to send is 1 BTC.
- Outputs. There are outputs. The first is 1.2 BTC (0.6 BTC + 0.6 BTC) to Jessica’s public address. The second is 0.2 BTC returned as 'change' to Mark.

## Longest chain

A chain of blocks that nodes adopt as their blockchain.  
The **longest chain** is not the chain with the most blocks, but the chain that has taken the most energy to build.

## Double Spending

Double spending is when someone (A) tries spending the same bitcoin twice. Bitcoin network prevents this.  
When A broadcast the two transactions, they will go in unconfirmed transactions' pools. From there when a miner (X) validates the first transaction, the bitcoin will be sent to the new owner. so X will invalidate the second transaction because A is not the owner of the bitcoin anymore. But if the two transactions gets validated and mined by two different miners and gets added to the next block. it means there are two different blockchains now. (one with the first transaction and one with the second transaction). Now longest chain algorithm comes into play. miners will always accept the longest chain.  

## Where do bitcoins come from?

As an incentive to use processing power to try and add new blocks of transactions on to the blockchain, each new block makes available a fixed amount of bitcoins that did not previously exist. Therefore, if you are able to successfully mine a block, you are able to “send” yourself these new bitcoins as a reward for your effort.

## Key-pairs

- a public key of an address to which some amount bitcoin was previously sent
- the corresponding unique private key, which authorizes the bitcoin previously sent to the above public key (address) to be sent elsewhere.

## References

- <https://www.bitcoin.com/get-started/>
- <https://academy.binance.com/en/articles/double-spending-explained>
- <https://www.youtube.com/watch?v=phLSjZdDc5A>
- <https://learnmeabitcoin.com/technical/longest-chain>

## My bitcoin Address

> bc1qgwu903shgs4fse3s8u2vsufrsaxhnz26skqmzu
