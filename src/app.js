var express = require("express");
var fs = require("fs")
var app = express();
const Web3 = require("web3");
const contractNFT = require("../build/contracts/RocketElevator.json");
const port = 3000;
//const abi = JSON.parse(fs.readFileSync(contractNFT));
//console.log(abi.abi);
const address = 0x230189cbd17c815d75455bf6e3c1cbabb39c1a15;
const HDWalletProvider = require("@truffle/hdwallet-provider");
const mnemonic =
  "behave run hello devote that celery garment beef run equip bless sphere";
const provider = new Web3(
  new HDWalletProvider({
    mnemonic: {
      phrase:
        mnemonic,
    },
    providerOrUrl: "https://blockchain.codeboxxtest.xyz",
  })
);


const secondapi = async (address, res) => {
  var web3 = new Web3(provider);
  var id = await web3.eth.net.getId();
  var deployedNetwork = contractNFT.networks[id];
  var contract = new web3.eth.Contract(
    contractNFT.abi,
    deployedNetwork.address
  );
  contract.methods
    .balanceOf(address)
    .call()
    .then((result) => res.send(result));
};

const firstApi = async(address, res)=>{
   var web3 = new Web3("HTTP://127.0.0.1:7545");
   var id = await web3.eth.net.getId();
   var deployedNetwork = contractNFT.networks[id];
   var contract = new web3.eth.Contract(
     contractNFT.abi,
     deployedNetwork.address
   );
   contract.methods
     .eligibility(address)
     .call()
     .then((result) => res.send(result));
};

const thridapi = async (token, res) => {
  var web3 = new Web3("HTTP://127.0.0.1:7545");
  var id = await web3.eth.net.getId();
  var deployedNetwork = contractNFT.networks[id];
  var contract = new web3.eth.Contract(
    contractNFT.abi,
    deployedNetwork.address
  );
  contract.methods
    .tokenURI(token)
    .call()
    .then((result) => res.send(result));
};

const forthapi = async (address, res) => {
  var web3 = new Web3("HTTP://127.0.0.1:7545");
  var id = await web3.eth.net.getId();
  var deployedNetwork = contractNFT.networks[id];
  var contract = new web3.eth.Contract(
    contractNFT.abi,
    deployedNetwork.address
  );
  contract.methods
    .transferOwnership(address)
    .call()
    .then((result) => res.send(result));
};

app.get("/balanceof/:address", async (req, res) => {
  secondapi(req.params.address, res);
});

app.get("/eligibility/:address", async(req, res) => {
  firstApi(req.params.address, res);
});

app.get("/metadata/:token", async (req, res) => {
  thridapi(req.params.token, res);
});

app.get("/gift/:address", async(req, res) =>{
  forthapi(req.params.address, res);
});


app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
