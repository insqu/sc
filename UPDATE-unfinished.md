# Deploying Smart Contracts on the Ethereum testnet Goerli (Update)

## Introduction
This instruction set follows on, and updates the istructions from README.md. Therefore we assume you will have set up an AWS instance or Ubuntu / linux instance, and are in that environment.

# Setting up our environment

The first thing we will do is make sure our instance is up to date, run:
```sh
sudo apt-get update
```
Then
```sh
sudo apt-get upgrade
```


First, lets make a new smart contract directory, lets call it `sc2`

```sh
mkdir sc2
```
then:
```sh
cd sc2
```

Next we will install `node.js` using our package manager

First we run:
```sh
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash
```
then:
```sh
sudo apt-get install -y nodejs
```

Now when we run
```sh
node --version
```
We should get `v18.XX.X`, for some value of X, just ensure that it starts with `v18`. 


# Running Hardhat

## Setting up Hardhat

First we will initialise npm (npm is the default package manager for Node.js)
```sh
npm init -y
```
We should see an initialisation file

If we rerun the `ls` command, we should see that the directory contains the file `package.json`

We are going to the use Hardhat environment to build our smart contract. This time we will use a more up to date version of hardhat.


In our terminal in the `sc2` directory we can run:
```sh
npm install --save-dev hardhat
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
- select n to the feedback message (if you see this message)
- select y to install the depencies message


The final selection of yes will install dependencies required to run the pre-built Hardhat contract `Lock.sol`, but for the most part we will not worry about that.

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


## Task 1
Try running `npx hardhat test` with this new hardhat environment, and take a look at what you get



# Building our own ERC20 token contract

Last time we built bbox.sol and compiled our Greeter.sol contract.

This time we are going to do things a bit differently. We are going to deploy a token smart contract, using openzeppelin.

The contract we are going to deploy will look like this:

```js
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.8.2/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@4.8.2/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Exeter_SC_token is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("<TOKEN-NAME>", "<TOKEN-CODE>") {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }

    event LogString(string message);

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) public virtual override {
    //    turns off burn function, can only use burnWithMessage function
    }

    function burnWithMessage(uint256 amount) public virtual returns (string memory) {
        // Your custom logic here
        // For example, restrict burning to a specific address:
        require(msg.sender == owner(), "MyCustomToken: Only the owner can burn tokens");

        // Burn the tokens
        _burn(msg.sender, amount);

        // Return a string value
        return string(abi.encodePacked("Burning ", Strings.toString(amount), " of EXSC"));
        
    }
}
```

## Task 2
Importing this token into REMIX to see how it works. You can play around with the function calls on the left side of the screen.


# Setting up MetaMask

We are now going to set up metamask in a web broswer.

Important, if you already have metamask, it is reccomended that you set up a separate MetaMask account in another web broswer.
For now, we are going to assume you do not have MetaMask installed on the Brave or Firefox web browser. 

First download and install the web browser:
- Firefox https://www.mozilla.org/en-GB/firefox/
- Brave https://brave.com/

After installing either new broswer, we can select and follow the install instructions for MetaMask here
- Install metamask: https://metamask.io/

Follow the install instructions, and create a new account. Call this account something memorable, it can be whatever you like!

Later we are going to fund this metamask account with some Goerli testnetwork eth. In order to see the Goerli eth, we need to open metamask, go into advanced settings and select to show the test networks. We can do this by:
- Click on the MetaMask icon
- Click on the picture of your new test account
- Click settings
- Click advanced
- Scroll down and toggle 'show test networks' to on




# Deploying to a public network 
Having written our test code and tried them out locally, we are now going to deploy to a real world network
Connecting to a public network is a bit more involved that using our own built in network
To do this, we will make use of a service that simplifies the process of interacting with a blockchain network


## Creating an alchemy account

Last time we should have our alchemy account, if not, you can set up your free account

We are going to use [alchemy.com](https://alchemy.com/?r=DM2MzkzNzUxODAyM) to manage our network
First head over to Alchemy and create a free account\
For those who want to know what alchemy is and why we might use it, the alchemy website has a page devoted to this: https://docs.alchemy.com/alchemy/introduction/why-use-alchemy

> Note: we could use another service, such as Infura, but for our tutorial, Alchemy will suffice

### Setting up a Goerli test network account 

We are going to deploy on the Goerli test network, as this way we wont risk losing actually valuable ether.
When we setup our alchemy app ensure we select `name:  exeter.sc`,  `chain: Ethereum` and `network: Goerli`

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
  "alchemyApiKey": "YOUR_APIKEY",
  "privKey": "YOUR_METAMASK_PRIVATE_KEY"
}
```
Here `[YOUR_APIKEY]` refers to the API KEY we created from Alchemy earlier and `[YOUR_MNEMONICS]` is the list of mnemonics we stored in `sec.mnemonics`. "YOUR_METAMASK_PRIVATE_KEY" is the private key for the metamask account you will use for this example. ALERT: use a fresh account, and do not use an account you have used before.

We also need to alter the hardhat config file to include
```js
const { alchemyApiKey, mnemonic, privKey } = require('./sec.json');
```
and under module exports:
```js
  module.exports = {
    networks: {
     goerli: {
         url: `https://eth-goerli.alchemyapi.io/v2/${YOUR_API_KEY}`,
        accounts: { mnemonic: mnemonic },
        %%%THIS NEEDS TO CHANGE BASED ON FILE
        },
       },
};
```

In all your hardhat config file should look something like this:
```js 
require("@nomiclabs/hardhat-toolbox");
const { alchemyApiKey, mnemonic, privKey } = require('./sec.json');
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
//> note: you must replace `{YOUR_API_KEY}` with your _alchemy API_KEY_ 

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


NOTE! THings we need to do:
We need to install the openzepplin stuff, which may also mean we have to make sure we link to openzepplin properly, i.e. get rid of @4.8.2 in the preamble for the imports. We have to npx install openzepplin.

Also, we have set the gas price to be quite low, as otheriwse it won't appear.

We also need to import our token code from the contract address.

We also need to create a deploy file, and don't forget we have to call it from the name of the contract itself.

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

