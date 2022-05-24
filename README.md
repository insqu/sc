# sc
# Introduction to building Smart Contracts
## Introduction
We will start by setting up a development enviroment for contracts on an AWS platform and then 

## Setup
We will be using Solidity to create and deploy a smart contract

Everything will be self contained, though we will be using guides:
https://hardhat.org/getting-started/
https://docs.openzeppelin.com/learn/deploying-and-interacting

We will also use Remix IDE
https://remix-project.org/

# Setting up using AWS (Amazon Web Services)

This process should take around 20 minutes or so, and can be skipped if you want to run on your local computer.

We can go to AWS here: https://aws.amazon.com/

Select: Services -> EC2 -> Launch an instance
We will then select an Ubuntu Server, with a 64-bit architecture
Most settings we can leave as default

For Key Pair (login)
we can select Create New Key Pair:
Select ED25519 key pair type, and select .pem if you will connect via OpenSSH or .ppk if you will connect using PuTTY
For MAC and Linux users, it is reccomended to use the .pem type
For Windows users, PuTTY is a freely available easy to use tool, so a .ppk extension may be the better option

Call your key pair: aws-sc-key

Now we can launch our instance

After launching we can go to our instances page on AWS, there will be a Status Check and we can see it will be Initialisizing
We can connect 

Click on Connect to Instance, and then the tab SSH client and follow the instructions for your machine.
On MAC and Linux you will need to open a terminal window
On Windows you will need to run your version of PuTTY

When we try to connect for the first time we will be asked to add the key fingerprint, type or select yes / OK

We should now be connected to our personal AWS EC2 instance


# Setting up our environment

The first thing we will do is make sure our instance is up to date.
Run:
```sh
sudo apt-get update
```
Then
```sh
sudo apt-get upgrade
```
First we will install node.js using our package manager. 

> note: https://nodejs.org/en/download/package-manager/ detailed instructions on setting up node.js for your distribution can be found here. 
> Please ensure you do not install a version greater than v16.x as it is not supported by Hardhat

Since we are using an Ubuntu instance, we can follow the instructions given here: https://github.com/nodesource/distributions/blob/master/README.md
First we run:
```sh
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
```
then:
```sh
sudo apt-get install -y nodejs
```

Now when we run
```sh
$ node --version
16.15.0
```
We should get v16.15.0

We will now clone a git hub repository (repo)

# Cloning our repo using Git

We can now clone our repo with the command:
```
git clone https://github.com/insqu/sc.git
```

We should now have a directory called `sc`\
Try the `ls` command and we should see the only directory is `sc`\
We should now change directory so that we are working in `sc`
```sc
cd sc
```
We can run the `ls` command now to see that the directory contains a `README.md` file and an `examples` directory
```sh
ls
```
We can remove the `README.md` file:
```sh
rm README.md
```
For now this is all we will do with git\
From now on we are going to do all our work in this `sc` directory


# Running Hardhat

## Setting up Hardhat

First we will initialise npm
```sh
$ npm init -y
```
We should see an initialisation file\
If we rerun the `ls` command, we should see that the directory contains the file `package.json`\

We are going to the use Hardhat enviroment to build out smart contract\
In our terminal in the `sc` directory we can run:
```sh
npm install --save-dev hardhat
```
Wait for Hardhat to install, then run
```sh
npx hardhat
```
You will be prompted with questions
Select the following responses in order 
- 'Create a basic sample project'
- accept the suggested project root
- n
- y

Wait for the setup to complete\
You should see something like:
```
Project created
See the README.md file for some example tasks you can run
```
You can read the `README.md` file in any way you like\ One suggestion is to use vim:
```sh
vim README.md
```
For those unfamiliar with Vim (or Vi), it can be a little confusing at first\ You may want to look up Vim on a search engine to find commands, but for now it is sufficent to simply read the file _with your eyes_, and when you have absorbed it use `:q` to exit out of the vim environment

It is a good opportunity to try the commands in the the `README.md` file, and take a look at the outputs you get 

## Task 1
Run the command `npx hardhat test`\
Then take a look in the test directory, what can we change in here? 

# Building our own contract
Lets now run our list command `ls` to view the files in the directory
We should now see directories, `.json` files `.js` files and `.md` files
One of the directories will be called `contracts`
Lets move into the the contracts directory
```
cd contracts
```
We are going to create `solidity` contracts within the `contracts` directory
First we will create a file bbox.sol
```
$ touch bbox.sol
```
This directory should now contain two .`sol` files: `bbox.sol` and `Greeter.sol`

We are now going to open the bbox.sol file and write in the contract code below:
> We can do this quickly by copy-pasting the code below using the vim editor

First we run `vim bbox.sol` which will present us with an empty file\
We then copy the `contracts/bbox.sol` code below\
Then back in the terminal:
- Press `i`, which will put us in insert mode
- Paste in the code
- Press `escape` to exit from insert mode
- Type `:wq` to write and quit out of vim 


```js
// contracts/bbox.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract bbox {
    uint256 private _value;

    // Emitted when the stored value changes
    event ValueChanged(uint256 value);

    // Stores a new value in the contract
    function store(uint256 value) public {
        _value = value;
        emit ValueChanged(value);
    }

    // Reads the last stored value
    function retrieve() public view returns (uint256) {
        return _value;
    }
}
```

Now we will ensure that Hardhat is using the right solidity compiler `solc`\
> Note: our contract bbox.sol uses solidity version 0.8.0
We need specify this in our hardhat configuration file

First we will navigate out of the `contracts` directory to our parent `sc` directory
```sc
cd .. 
```
We can check we are in the correct directory by using the command `pwd`. If we are in the correct directory, we should see /home/ubuntu/sc returned\
We can now open the file `hardhat.config.js` using vim
```sc
vim hardhat.config.js
```
We should be able to see a line that specifies the solidity version `solidity: "0.8.4"`\
Close vim using the command `:q!`\
We are now ready to compile our contract\
From the `sc` directory run:
```sc
npx hardhat compile
```
We should get the message `Compiled 1 Solidity file successfully`
> note: it may say 1 or 2 depending on whether you previously compiled the contracts

The compile command will try to compile all contracts in the contracts directory automatically\
We should now see that the `artifacts` directory has been populated

## Interacting with our contract
Smart contracts live on the blockchain, but as of yet, we do not have a blockchain to deploy our contract to\
Therfore, for this next part we are going to _spin-up_ a local (_local to your own machine_) blockchain to deploy our contracts on\
Fortunately for us Hardhat provides simple functionality that allows us to do this\
In the terminal window we can run:
```sc
npx hardhat node
```
Hardhat should output a list of 20 accounts, each with their account number, 10,000 ETH and their corresponding private key
> **Note:** these are defualt values, do not use these accounts and their private keys for anything other than this demonstration


# Deploying to a public network 
Having written our test code and tried them out locally, we are now going to deploy to a real world network

Connecting to a public network is a bit more coplicated that using our own network

We are going to use https://infura.io/ to manage our network 
First head over to Infura and create a free account 

Now we will run the command
```sh
$ npx mnemonics
```
You may be prompted to install a package first, if so accept\
You will then be given 12 words which we will store in a secure file that we will call `sec.mnemonics`\
Copy and paste your mnemonics into this file\







