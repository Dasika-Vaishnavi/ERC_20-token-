# Cryptography
Study of secure communication techniques

# Simple Encryption & Decryption with Openssl

```bash
echo HelloWorld > message.txt
openssl enc -aes-256-cbc -in message.txt -out message.bin
openssl enc -d -aes-256-cbc -in message.bin -out message.dec
cat message.dec
HelloWorld
# Using base64
openssl enc -base64 -in message.bin -out message.b64
openssl enc -d -base64 -in message.b64 -out message.ptx
```

# Generate Key-Pairs with openssl - RSA

```bash
openssl genpkey -algorithm RSA -out privatekey.pem -pkeyopt rsa_keygen_bits:1024
openssl rsa -pubout -in privatekey.pem -out publickey.pem
```

# Encrypt and Decrypt using RSA Key-Pairs

```bash
openssl rsautl -encrypt -inkey publickey.pem -pubin -in message.txt -out message.rsa
openssl rsautl -decrypt -inkey privatekey.pem -in message.rsa -out message.dec
```