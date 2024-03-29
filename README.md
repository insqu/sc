# Deploying Smart Contracts on the Ethereum network

## Introduction
This repo is intended to give you the basic of developing and deploying a smart contract to an Ethereum network.

The focus is to learn some of the tools you can use to create and deploy smart contracts on the public Ethereum Goerli test network.  

The document can be followed as is, and is self--contained, but there are plenty of points where you can diverge from this tutorial to develop your own knowledge.

## Who is this guide for
This guide has been designed with Exeter University masters level students in mind, however it will be useful to anyone looking to deploy a smart contract on a working network.

Part of this guide is used for the tutorial section of the module titled Smart Contracts, with code: BEEM161.
An assumption has been made of little coding / scripting experience, though students are expected to be able to learn these concepts quickly.
This is designed to be completed in a tutorial and in your own time. 

Try to complete the tasks and questions that appear throughout.

## Setup
We will start by setting up a development environment for our contracts on an AWS EC2 instance, and using Solidity to create our smart contract. We will be using tools and services such as _Node.js, Hardhat, OpenZeppelin, Alchemy_.

Everything here is self contained, though the following guides (where a lot of this guide is derived from) will come in very handy: https://hardhat.org/getting-started/ and https://docs.openzeppelin.com/learn/deploying-and-interacting

Another good tool to create and test smart contracts is the Remix IDE: https://remix-project.org/ though we stress we **will not** be developing in remix for this tutorial.

# Setting up an AWS (Amazon Web Services) EC2 instance
This process should take around 20 minutes or so, but can be skipped if you want to run on your local computer.
> Note: we advise you to use AWS EC2 instance for a cleaner setup: again we cannot provide support for issues encountered by using your local machine. 
> Please remember to terminate any running instances after completeing this tutorial. 

First sign up to a free-tier account here: https://aws.amazon.com/ (note, you may have to use a credit / debit card to sign-up, please ensure that you cancel as soon as you have completed the tutorial and close your instances to avoid any charges).


Then:

## If you are using a Windows / MacOS / Linux follow these instructions

- Select Services -> EC2 -> Launch an instance
- Select an Ubuntu Server
- Under Architecture ensure 64-bit is selected
- Leave the remaining settings as their defaults 
- You can name the instance whatever you like, even _super-fun-smart-contracts-time_

Under the section: For Key Pair (login), select Create New Key Pair:
Select `ED25519` key pair type, and select the `.ppk` file type
**For MAC and Linux users**, it is recommended to use OpenSSH and the `.pem` file type. 


Name your key pair: `aws-sc-key` and click to launch our instance.
Once launched, we can go to our instances page on AWS, there will be a Status Check and we can see it will be initialising.
Once the initialisation process has completed we can click `connect`.

Before we connect to our instance, we recommend to create a new directory / folder on our local machine to store our files in.
Create that directory / folder now and call it `sc-deploy`, then relocate your `aws-sc-key` key to this location.

### For MAC users

If we are uisng MacOS, we will most likely need to ensure our key is not viewable before we can use it to SSH to our instance.
First, open a terminal window and navigate to the directory where our `.pem` key file is stored. 
For those who are unfamiliar with using and navigating terminal on MAC, apple provides a useful guide: https://support.apple.com/en-gb/guide/terminal/apd5265185d-f365-44cb-8b09-71a064a42125/mac

Once we have navigated to our directory in terminal, hopefully called `sc-deploy`, run this command: 
```sh
chmod 400 aws-sc-key.pem
```

Now, return to you AWS instance on the web, and take a look under the `SSH client` tab and follow the instructions for your machine.


The client will suggest you run something like: `ssh -i "aws-sc-key.pem" ubuntu@ec2-99-99-99-99.compute-1.amazonaws.com` in the terminal window, do this now.
When we try to connect for the first time we will be asked to add the key fingerprint, type or select `yes / OK`.

We should now be connected to our personal AWS EC2 instance, hurrah!

### If you are using Windows follow these instructions 

- Select Services -> EC2 -> Launch an instance
- Select an Ubuntu Server
- Under Architecture ensure 64-bit is selected
- Leave the remaining settings defaults 
- You can name the instance whatever you like, even _super-fun-smart-contracts-time_

Under the section: For Key Pair (login), select Create New Key Pair:\
Select ED25519 key pair type, and select the `.ppk` private key file format as we will be connecting using PuTTY
**For Windows users**, PuTTY is a freely available, easy to use, tool which can be aquired here: https://www.chiark.greenend.org.uk/~sgtatham/putty/

### First download and install PuTTY
Putty can be found on the link above, and is also available via the microsoft web store for free

Name your key pair: `aws-sc-key` and click to launch our instance\
Once launched, we can go to our instances page on AWS, there will be a Status Check and we can see it will be initialising\
Once the initialisation process has completed we can click connect

Before connecting to our instance, we recommend to create a new directory / folder on our local machine to store our files from today in\
Create that directory / folder now and call it `sc-deploy`, then relocate your `aws-sc-key` key to this location\

Click on Connect to Instance, and select the `SSH client` tab and follow the instructions for your machine\
On Windows you will need to run your version of PuTTY within folder we have just created called `sc-deploy`

The client will suggest you connect to your instance using its public DNS (Domain Name System),  something like: `ec2-99-99-99-99.compute-1.amazonaws.com`\
Copy the Public DNS, we are going to use it with PuTTY to connect to our server\
Now open PuTTY, and where you see a blank section called Host Name (or IP address) paste in the DNS we copied above, then prepend `ubuntu@` in front on the DNS name so that under host name we get something that looks like: `ubuntu@ec2-99-99-99-99.compute-1.amazonaws.com`\
In the white box below, called Saved Sessions, we can write `sc_tutorial` then click save on the right\
Now on the drop down column on the left, under Connection, select SSH to expand it then select Auth (for authentication), then under the Private key file for authentication section select Browse and select your private key `aws-sc-key.ppk`\
Now select Session in the left hand drop down column, and press save\
Press open to be connected to the AWS server we have set up\

When we try to connect for the first time we will be asked to add the key fingerprint, type or select `yes / OK / agree`

We should now be connected to our personal AWS EC2 instance, hurrah!


## Question 1 
Why are we using an AWS instance? What is the advantage of renting server space in this way? What is the advantage to a developer in using tools such as this?


# Setting up our environment

The first thing we will do is make sure our instance is up to date, run:
```sh
sudo apt-get update
```
Then
```sh
sudo apt-get upgrade
```
Next we will install `node.js` using our package manager

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
We should get `v16.XX.X`, for some value of X, just ensure that it starts with `v16`. 
The next step is to clone the Github repository (repo).

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
For now this is all we will do with git.
From now on we are going to do all our work in this `sc` directory


# Running Hardhat

## Setting up Hardhat

First we will initialise npm (npm is the default package manager for Node.js)
```sh
npm init -y
```
We should see an initialisation file\
If we rerun the `ls` command, we should see that the directory contains the file `package.json`\

We are going to the use Hardhat environment to build our smart contract. We are going to use a slightly older version of hardhat, version 2.0.11.


In our terminal in the `sc` directory we can run:
```sh
npm install --save-dev hardhat@2.0.11
```

Wait for Hardhat to install, then run
```sh
npx hardhat
```
You will be prompted with questions
Select the following responses in order 
- select the first option
- select to accept the suggested project root
- select n to the gitignore message
- select n to the feedback message
- select y to the depencies message


The final selection of yes will install dependencies required to run the pre-built Hardhat contract `Greeter.sol`, which we will look at later

Wait for the setup to complete.

You should see something like:
```
Project created
See the README.md file for some example tasks you can run
```
You can read the `README.md` file in any way you like, one suggestion is to use vim:
```sh
vim README.md
```
For those unfamiliar with Vim (or Vi), it can be a little confusing at first. 


You may want to look up Vim on a search engine to find commands, but for now it is sufficient to simply read the file _with your eyes_, and when you have absorbed it enter `:q` to exit out of the vim environment. You may need to use `:q!` then `enter` to quit vim. Ask if you get stuck!

It is a good opportunity to try the commands in the the `README.md` file, and take a look at the outputs you get. In fact, that is exactly what we are going to do now

## Task 1
Run `npx hardhat test`

Then take a look in the test directory, what can we change in here?
Take a look at, and run the rest of the commands in the `README.md` file. What outputs do you get?


# Building our own contract
We are now in a position to build our own contract
Lets now run our list command `ls` to view the files in the directory
We should now see directories, `.json` files `.js` files and `.md` files
One of the directories will be called `contracts`
Lets move into the the contracts directory
```sh
cd contracts
```
We are going to create `solidity` contracts within the `contracts` directory
First we will create a file bbox.sol
```sh
touch bbox.sol
```
This directory should now contain two `.sol` files: `Lock.sol` and `bbox.sol`. 

We are going to import our `Greeter.sol` contract from the Github directory that we copied earlier.
Run the command

```sh 
cp ../examples/contracts/Greeter.sol 
```

We are now going to open the `bbox.sol` file and write in the contract code below:
> We can do this quickly by copy-pasting the code below using the vim editor


First we run `vim bbox.sol` which will present us with an empty file

We then copy the `contracts/bbox.sol` code below:
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
> Note: our contract `bbox.sol` uses solidity version `0.8.0`
We need specify this in our hardhat configuration file

First we will navigate out of the `contracts` directory to our parent `sc` directory
```sc
cd .. 
```
We can check we are in the correct directory by using the command `pwd`. If we are in the correct directory, we should see `/home/ubuntu/sc` returned\
We can now open the file `hardhat.config.js` using vim
```sc
vim hardhat.config.js
```
We should be able to see a line that specifies the solidity version `solidity: "0.8.4"`, if we don't, we can change it to 0.8.4 using the insert command `i` as we did above, and writing to the file using `esc` then `:w`.
Close vim using the command `:q!`\
We are now ready to compile our contract\
From the `sc` directory run:
```sc
npx hardhat compile
```
We should get the message `Compiled 1 Solidity file successfully`
> note: it may say 1 or 3 depending on whether you previously compiled the contracts

The compile command will try to compile all contracts in the contracts and examples directory automatically\
We should now see that the `artifacts` directory has been populated

We will come back to `bbox.sol` later on, in Task 3

## Interacting with our contract
Smart contracts exist on the blockchain, but as of yet, we do not have a blockchain to deploy our contract to\
Therefore, for this next part we are going to _spin-up_ a local (_local to your own machine_) blockchain to deploy our contracts on\
Fortunately for us Hardhat provides simple functionality that allows us to do this\

Open a new terminal window and connect to our AWS instance as before, then navigate to our `sc` directory\
In this new terminal window, run:
```sc
npx hardhat node
```
Hardhat should output a list of 20 accounts, each with their account number, 10,000 ETH and their corresponding private key
> **Note: these are default values, do not use these accounts and their private keys for anything other than this demonstration**
We will leave this terminal window open for now, as it is running a simulated Hardhat blockchain for our development purposes

Now lets deploy our Hardhat created `Greeter.sol` contract onto this chain for fun!
In our other terminal window (not the one running the hardhat node), we can run
```sh
npx hardhat test --network localhost
```
This tells hardhat to run the scripts located in the `test` directory, to the network specified as `localhost` (i.e. your machine)

After running this successfully, we should get a return something like: 
```sc
Greeter
Should return the new greeting once it's changed 
```
This is pretty boring, but if we take a look in our other terminal window, we should have seen some interesting stuff happening!

We should be able to see that two blocks have been created and that in the first block a contract called Greeter has been deployed with the greeting _Hello, World!_, and that in the second block a block the set greeting function has been called that changes _Hello, world!_ to _Hola, mundo!_. We should also see the contract address that has been created and the transaction addresses.

Fantastic, we have actually deployed a real life EVM contract (even if it isn't on a public chain, and it is a very simple contract)

## Task 2
Take a look at the `Greeter.sol` contract an in the `contracts` directory, and take a look at the scripts used to deploy it in the `test/sample-test.js` file\
Try to understand how the script interacts with the code. What could you change in the scripts or the contracts code to make the contract perform differently? Change the contract script so that instead of changing to _Hola, mundo!_, it says: _Nobody expects the Spanish Inquisition!_

## Question 2
What does Greeter.sol do what does bbox.sol do? Take a look at the code, and try to work out what would happen if certain commands are called. 
> Hint: remix ide https://remix-project.org/ allows you to create and intereact with contracts, inclusing useful titorials and ways to deploy them

We could now create and deploy our contracts on this local blockchain provided by Hardhat, however, this is more of an environment for testing and is not publicly reachable. Moreover, when we quit the hardhat node process, all state is lost, meaning the contract we have deployed and interacted with no longer exists, and will have to be created again. Try it if you like!


# Deploying to a public network 
Having written our test code and tried them out locally, we are now going to deploy to a real world network\
Connecting to a public network is a bit more involved that using our own built in network\
To do this, we will make use of a service that simplifies the process of interacting with a blockchain network\


## Creating an alchemy account

We are going to use [alchemy.com](https://alchemy.com/?r=DM2MzkzNzUxODAyM) to manage our network\
First head over to Alchemy and create a free account\
For those who want to know what alchemy is and why we might use it, the alchemy website has a page devoted to this: https://docs.alchemy.com/alchemy/introduction/why-use-alchemy\
> Note: we could use another service, such as Infura, but for our tutorial, Alchemy will suffice

### Setting up a Goerli test network account 

We are going to deploy on the Goerli test network, as this way we wont risk losing actually valuable ether.
When we setup our alchemy app ensure we select `name:  exeter.sc`,  `chain: Ethereum` and `network: Goerli`\
After setup on the main dashboard we should see our Goerli network and a column called `API KEY`.
Make a note of your API KEY and our HTTP connection information.

Now we will run the command
```sh
npx mnemonics
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

We also need to alter the hardhat config file to include
```js
const { alchemyApiKey, mnemonic } = require('./sec.json');
```
and under module exports:
```js
  module.exports = {
    networks: {
     goerli: {
         url: `https://eth-goerli.alchemyapi.io/v2/{YOUR_API_KEY}`,
        accounts: { mnemonic: mnemonic },
        },
       },
};
```

In all your hardhat config file should look something like this:
```js 
require("@nomiclabs/hardhat-waffle");
const { alchemyApiKey, mnemonic } = require('./sec.json');
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.7.3",
        networks: {
                goerli: {
                url: `https://eth-goerli.alchemyapi.io/v2/{YOUR_API_KEY}`,
                accounts: { mnemonic: mnemonic },
     },
   },
};
```
> note: you must replace `{YOUR_API_KEY}` with your _alchemy API_KEY_ 

Now we are ready to interact with the public Goerli test network using Hardhat

## The Hardhat Goerli console
We in the `sc` directory we can run:
```sh 
npx hardhat console --network goerli
```
If our configuration file is correct we should some text and enter console mode with a `>` presented on screen\
First lets list our accounts with the command 
```js
accounts = await ethers.provider.listAccounts()
```
We can then check the balance of any of our accounts with the command  
```js
(await ethers.provider.getBalance(accounts[0])).toString()
```

One final thing before we can deploy our contract: we need some ether in our Goerli test network

## Getting some Goerli eth
The best way to do this is to simply search for a _goerli faucet_ using a web browser, and provide the faucet with one of the account numbers in the list you returned when you ran `accounts = await ethers.provider.listAccounts()`\
It is simplest to use the first account number returned, so we will do that. Once you have received some test network eth, you should be able to run `(await ethers.provider.getBalance(accounts[0])).toString()` and see a positive number! 

## Deploying our contract on the Goerli network
Now we are ready to deploy our contract on the Goerli test network. We can run: 
```
npx hardhat test --network goerli
```
> note: we may have to wait while a block is created
Once this is complete, we can return to our Alchemy tab in our browser and look up the contract that was created\
If we take a look at the trace in Etherscan we can find the contract we created and decode the raw data using their inbuilt functions, here is an example: https://rinkeby.etherscan.io/tx/0xa703de1f2770a08be1d24e95bb35acf88ce8840e0b8d2e04aa3f82399136f62c

That's it, we did it! We have successfully created a smart contract and deployed it on an Ethereum network!

## Task 3
Using the guide from here: https://docs.openzeppelin.com/learn/developing-smart-contracts complete the bbox.sol setup and deploy it locally to the Goerli test network\
> note: in the guide, they use Box.sol, not bbox.sol, so watch out for that


## Task 4
Now the interesting bit, take a look at the OpenZeppelin documents here: https://docs.openzeppelin.com/contracts/4.x/erc20
and create a more interesting contract.\
Your contract type will be an ERC20 contract, issuing a token.\
Create and deploy a new token to the Goerli network with an interesting name, then distribute that token to your colleagues!
- What is the name of your token? 
- What addresses did you send the token to? 
- and how was it achieved? 

