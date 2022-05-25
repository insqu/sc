# Deploying Smart Contracts on the Ethereum network

## Introduction
This `README` document is intended to give you the basic of developing and deploying a smart contract to an Ethereum network\
The focus is to learn some of the tools you can use to create and deploy smart contracts on the public Ethereum Rinkeby test network\
The document can be followed as is, and is slef-contained, but there are plenty of jumping off points for developing your own knowledge\

## Who is this guide for
This guide has been designed with masters level students in mind, specifically those studying at Exeter University\
An assumption has been made of little coding / scripting experience, though students are expected to be able to learn these conepts quickly\
This can be completed at home and in your own time, though unfortunately the authors of this document are unable to provide any support over email

## Setup
We will start by setting up a development enviroment for our contracts on an AWS EC2 instance, and using Solidity to create our smart contract. We will be using tools and services such as _Node.js, Hardhat, OpenZeppelin, Alchemy, Metamask_

Everything will be self contained, though the following guides will come in very handy: https://hardhat.org/getting-started/ and https://docs.openzeppelin.com/learn/deploying-and-interacting

Another good tool to create and test smart contracts is the Remix IDE: https://remix-project.org/ though we stress we **will not** be developing in remix for this tutorial

# Setting up an AWS (Amazon Web Services) EC2 instance
This process should take around 20 minutes or so, but can be skipped if you want to run on your local computer.
> Note: we advise you to use AWS EC2 instance for a cleaner setup: again we cannot provide support for issues encountered by using your local machine 

First sign up to a free-tier account here: https://aws.amazon.com/
Then:
- Select Services -> EC2 -> Launch an instance
- Select an Ubuntu Server, with a 64-bit architecture
- Leave the remaining settings as their defaults 
- You can name the instance whatever you like, even _super-fun-smart-contracts-time_

Under the section: For Key Pair (login), select Create New Key Pair:\
Select ED25519 key pair type, and select the `.pem` file if you will connect via OpenSSH or alternatively select `.ppk` if you will connect using PuTTY
**For MAC and Linux users**, it is reccomended to use the `.pem` type\
**For Windows users**, PuTTY is a freely available easy to use tool, so a `.ppk` extension may be the better option

Name your key pair: `aws-sc-key` and click to launch our instance\
Once launched, we can go to our instances page on AWS, there will be a Status Check and we can see it will be initialising\
Once the initialisation process has completed we can connect

Before we connect to our instance, we reccomend to create a new directory / folder on our local machine to store our files from today in\
Create that directory / folder now and call it `sc-deploy`, then relocate your `aws-sc-key` key to this location


Click on Connect to Instance, and select the `SSH client` tab and follow the instructions for your machine\
**On MAC and Linux** you will need to open a terminal window within the directory `sc-deploy` and connect\
**On Windows** you will need to run your version of PuTTY within folder `sc-deploy`

The client will suggest you run something like: `ssh -i "aws-sc-key.pem" ubuntu@ec2-99-99-99-99.compute-1.amazonaws.com` in the terminal window, do this now\
When we try to connect for the first time we will be asked to add the key fingerprint, type or select `yes / OK`

We should now be connected to our personal AWS EC2 instance, hurrah!

# Setting up our environment

The first thing we will do is make sure our instance is up to date, run:
```sh
sudo apt-get update
```
Then
```sh
sudo apt-get upgrade
```
Next we will instaall `node.js` using our package manager

> Note: https://nodejs.org/en/download/package-manager/ detailed instructions on setting up node.js for your distribution can be found here 
> Please ensure you do not install a version greater than v16.x as it is not supported by Hardhat

Since we are using an Ubuntu instance, we can follow the instructions given here: https://github.com/nodesource/distributions/blob/master/README.md\
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
node --version
```
We should get `v16.15.0`\
The next step is to clone the Github repository (repo) here

# Cloning our repo using Git

We can now clone our repo with the command:
```
git clone https://github.com/insqu/sc.git
```

We should now have a directory called `sc`\
Try the `ls` command and we should see the only directory is `sc`\
We should now change directory so that we are working in to `sc`
```sh
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

First we will initialise npm (npm is the default package manager for Node.js)
```sh
$ npm init -y
```
We should see an initialisation file\
If we rerun the `ls` command, we should see that the directory contains the file `package.json`\

We are going to the use Hardhat enviroment to build our smart contract\
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
You can read the `README.md` file in any way you like\ 
One suggestion is to use vim:
```sh
vim README.md
```
For those unfamiliar with Vim (or Vi), it can be a little confusing at first\ 
You may want to look up Vim on a search engine to find commands, but for now it is sufficent to simply read the file _with your eyes_, and when you have absorbed it enter `:q` to exit out of the vim environment

It is a good opportunity to try the commands in the the `README.md` file, and take a look at the outputs you get. In fact, that is exactly what we are going to do now

## Task 1
Run `npx hardhat test`\
Then take a look in the test directory, what can we change in here?\
Take a look at, and run the rest of the commands in the `README.md` file. What outputs do you get?


# Building our own contract
We are now in a position to build our own contract
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

Connecting to a public network is a bit more coplicated that using our own network\
To do this, we will make use of a service that simplifies the process of interacting with a blockchain network\


## Creating an alchemy account

We are going to use [alchemy.com](https://alchemy.com/?r=DM2MzkzNzUxODAyM) to manage our network\
First head over to Alchemy and create a free account\
For those who want to know what alchemy is and why we might use it, the alchemy website has a page devoted to this: https://docs.alchemy.com/alchemy/introduction/why-use-alchemy\
> Note: we could use another service, such as Infura, but for our experiment Alchemy will suffice

### Setting up a Rinkeby test network account 

When we setup our alchemy app ensure we select `name:  exeter.sc`,  `chain: Ethereum` and `network: Rinkeby`\
After setup on the main dashboard we should see our Rinkeby network and a column called `API KEY`\
Make a note of our API KEY and our HTTP connection information\


Now we will run the command
```sh
$ npx mnemonics
```
You may be prompted to install a package first, if so accept the prompt and install\
You will then be given 12 words which we will store in a secure file that we will call `sec.mnemonics`\
Copy and paste your mnemonics into this file (remember we can create a new file using vim)

After you have created this file, we will create a new file called `sec.json`\
Create this file now, and populate the file with the following lines:
```vi
{
  "mnemonic": "[YOUR_MNEMONICS]",
  "alchemyApiKey": "[YOUR_APIKEY]"
}
```
Here `[YOUR_APIKEY]` refers to the API KEY we created from Alchemy earlier and `[YOUR_MNEMONICS]` is the list of mnemonics we stored in `sec.mnemonics`






