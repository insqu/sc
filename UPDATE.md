# Deploying Smart Contracts on the Ethereum testnet Goerli (Update)

## Introduction
This instruction set follows on from, and updates, the instructions from README.md. Therefore we assume you will have set up an AWS instance or Ubuntu / linux instance, and are working within that environment.

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
- select y to install the dependencies message


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

This time we are going to do things a bit differently. We are going to deploy a token smart contract, using OpenZeppelin.

The contract we are going to deploy will look like this.


## Task 2
Copy the following code and save it as a `token_name.sol` file in your `contracts` directory. Hint you can find what directory you are in using: `pwd`, you can list the files and directories using `ls`, you can change directory using `cd name_of_directory` where name_of_directory is a directory name. You can create a file using `vim filename`, where filename is the name of the file you want to create.  

Once the contract is imported, there are two variables for you to change: `<TOKEN-NAME>` and  `<TOKEN-CODE>`. The token name is the long name, like Bitcoin or Ether, and the token code is usually the shorthand code for it, such as BTC or ETH. You can pick whatever you like, but do try to make it unique and do not use and spaces.

```js
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
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


# Compiling the contract and setting up OpenZeppelin

Before we can launch this contract, we first need to compile it. We can do this from our parent directory `sc2`. 
If we are in our contracts directory, use `cd ../` to change to the `sc2` directory.

To compile, we run:
```sh 
npx hardhat compile
```
Unless we have already installed openzeppelin, this will most likely give us an error.

We need to install the openzeppelin libraries to compile this contract.
We can do that with the command:

```sh
npm install @openzeppelin/contracts
```

Now we can run our command again: 
```sh 
npx hardhat compile
```
And this time we should see a different outcome!

## Task 3
Import this token contract into REMIX to see how it works. You can play around with the function calls on the left side of the screen.


# Setting up MetaMask

We are now going to set up MetaMask in a web browser.

> Important, if you already have MetaMask, it is recommended that you set up a separate MetaMask account in another web browser.
> Whatever you do, **DO NOT** use a pre-existing account for this tutorial.

For now, we are going to assume you do not have MetaMask installed on the Brave or Firefox web browser. 

First download and install the web browser:
- Firefox https://www.mozilla.org/en-GB/firefox/
- Brave https://brave.com/

After installing either new browser, we can select and follow the install instructions for MetaMask here
- Install metamask: https://metamask.io/

Follow the install instructions, and create a new account. Call this account something memorable, it can be whatever you like!

Later we are going to fund this MetaMask account with some Goerli test network eth. In order to see the Goerli eth, we need to open MetaMask, go into advanced settings and select to show the test networks. We can do this by:
- Click on the MetaMask icon
- Click on the picture of your new test account
- Click settings
- Click advanced
- Scroll down and toggle 'show test networks' to on

We can now, at the top of our MetaMask select the Network drop down and change it to Goerli. Do this now. 


# Deploying to a public network 
We are now going to deploy to a real world network.
Connecting to a public network is a bit more involved that using the Hardhat built in network.
To do this, we will make use of a service that simplifies the process of interacting with a blockchain network.


## Creating an alchemy account

Last time we should have our alchemy account, if not, you can set up your free account.

We are going to use [alchemy.com](https://alchemy.com/?r=DM2MzkzNzUxODAyM) to manage our network.
For those who want to know what alchemy is and why we might use it, the alchemy website has a page devoted to this: https://docs.alchemy.com/alchemy/introduction/why-use-alchemy

> Note: we could use another service, such as Infura, but for our tutorial, Alchemy will suffice.

## Setting up a Goerli test network account 

We are going to deploy on the Goerli test network, as this way we wont risk losing actually valuable ether.
In Alchemy, select to set up a new app. When we setup our alchemy app ensure we select `name:  exeter.sc`,  `chain: Ethereum` and `network: Goerli`

After setup on the main dashboard we should see our Goerli network and a column called `API KEY`.
Select this to view your API KEY.
Make a note of your API KEY and our HTTP connection information.


We will create a new file called `sec.json` to store our secure information in, such as our API.
Create this file now, and populate the file with the following lines:
```vi
{
  "alchemyApiKey": "YOUR_APIKEY",
  "privKey": "YOUR_METAMASK_PRIVATE_KEY"
}
```
Here `YOUR_APIKEY` refers to the API KEY we created from Alchemy earlier and `YOUR_METAMASK_PRIVATE_KEY` is the private key for the MetaMask account you will use for this example. 

## Task 4
Export your MetaMask private key from your newly created MetaMask wallet. Copy that private key and store it in your `sec.json` file. Why should you keep this a secret? What could happen if you shared this private key with someone?


We also need to alter the hardhat config file to include
```js
const { alchemyApiKey, privKey } = require('./sec.json');
```
and under module exports:
```js
  module.exports = {
    solidity: "0.8.18",
        networks: {
            goerli: {
                url: `https://eth-goerli.alchemyapi.io/v2/${alchemyApiKey}`,
                accounts: [privKey],
        },
       },
};
```

In all your hardhat config file should look something like this:
```js 
require("@nomiclabs/hardhat-toolbox");
const { alchemyApiKey, privKey } = require('./sec.json');

module.exports = {
  solidity: "0.8.18",
      networks: {
          goerli: {
            url: `https://eth-goerli.alchemyapi.io/v2/${YOUR_API_KEY}`,
            accounts: [privKey],
        },
       },
};
```

Now we are ready to interact with the public Goerli test network using Hardhat

## The Hardhat Goerli console
We in the `sc2` directory we can run:
```sh 
npx hardhat console --network goerli
```
If our configuration file is correct we should some text and enter console mode with a `>` presented on screen.

First lets list our accounts with the command 
```js
accounts = await ethers.provider.listAccounts()
```
This should list our MetaMask account public key, for the account with the private key that we imported earlier.

We can then check the balance of any of our accounts with the command  
```js
(await ethers.provider.getBalance(accounts[0]))
```

Another thing before we can deploy our contract: we need some ether in our Goerli test network account.

## Getting some Goerli eth
The best way to do this is to simply search for a _goerli faucet_ using a web browser, and provide the faucet with your MetaMask account number (the public one, not the private key). Once you have received some test network eth, you should be able to run `(await ethers.provider.getBalance(accounts[0])).toString()` and see a positive number! 

You can try the website: https://goerlifaucet.com/ if you have a working Alchemy account.

# Creating a deployment script for our contract

Recall from last time that we have a scripts directory containing our JavaScript code to deploy our contract.

From our main `sc2` directory, we can change to our `scripts` directory with `cd scripts`.

Then we will create the file: `vim sc_deploy.js`, and copy in the following code.

```js
const hre = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contract with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Token = await ethers.getContractFactory("<TOKEN-NAME>");
  const token = await Token.deploy();

  console.log("EXSC address:", token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

Note again that `<TOKEN-NAME>` needs to be defined. You must change this name to the name that you gave your smart contract.  


## Deploying our contract on the Goerli network

We should now be in a position to deploy our contract.
Try running the following code:

```sh
npx hardhat run scripts/sc_deploy.js --network goerli
```
> note: we may have to wait while a block is created

For some of you, this may work, for others, this may claim there is an error to do with gas fee.

In the case that there is an error due to the gas fee, we may need to change the gas price, to do this we can add the following line of code to our hardhat config file: `gasPrice: 100000000,`.

## Task 5
Add the gas price to your hardhat config file, so that the module.exports section looks like this:
```js
module.exports = {
  solidity: "0.8.18",
      networks: {
          goerli: {
            url: `https://eth-goerli.alchemyapi.io/v2/${alchemyApiKey}`,
            accounts: [privKey],
            gasPrice: 100000000,
        },
       },
};
```

This will reduce the gas price we pay for each unit of gas used. This is good is we don't have much test eth to use.

For those who did not manage to deploy their contract the first time, run the following code again:

```sh
npx hardhat run scripts/sc_deploy.js --network goerli
```

Now we should see our ERC20 contract, the final line will be our contract address.

**Huzzah! We have just deployed our smart contract on a working testnet environment!**


Once this is complete, we can return to our Alchemy tab in our browser and look up the contract that was created.
If we take a look at the trace in Etherscan we can find the contract we created and decode the raw data using their inbuilt functions, here is an example: https://goerli.etherscan.io/address/0xa3cec46acde90952a83e7992196631626c626076

We have successfully created a smart contract and deployed it on an Ethereum Goerli network!

## Task 6
Import your token to MetaMask. Open MetaMask, select your account, and under the assets tab scroll down to `import token`. 
In the token contract address box, paste in the contract address you created. MetaMask should auto-fill the rest of the data. Remember that the contract address is different from the address you used to fund the creation of the contract.

You should now see you have 1000 of the token you created in your MetaMask wallet!
We can now send this to others on our module. Be careful to only share this with accounts used for testing, and do not use an account with any value attached.

## Task 7
Interact with your token on Remix. Here is a breif guide on how to do it. 

- We will interact with our new contract using Remix and MetaMask
- First we need to open our contract file in the contracts directory and copy the code in that file
- Open Remix in our new web browser, that contains the newly installed MetaMask that we setup
- In Remix, create a new Workspace, and create a new file. Call it the same as your contract file on your AWS instance
- Paste in your contract code that you copied in the second step
- Compile the code in Remix
- Now select the Deploy and Run Transactions tab on the left sidebar
- Select environment and change that to Injected Provider - MetaMask
- Then fill in the At Address tab with the smart contract address
- When that is filled in you can click the At Adress button and you should see your contract call functions on the left of the screen
- You can now interact with your contract like we have done before, but now it alters the actual contract state!

