const { ethers } = require("ethers");
const ABI = require("./abi.json");
require("dotenv").config();

async function main() {
  const contractAddress = process.env.CONTRACT_ADDRESS;
  const apiProvider = process.env.API_PROVIDER;
  const provider = new ethers.providers.WebSocketProvider(
    `wss://goerli.infura.io/ws/v3/${apiProvider}`
  );
  const contract = new ethers.Contract(contractAddress, ABI, provider);

  console.log("Start listener");

  contract.on("CreateFunding", (_from, _id, name, event) => {
    console.log("Event : CreateFunding");
    let createFundingEvent ={
        from: _from,
        id: _id,
        name : name,
        data: event
    }
    console.log(JSON.stringify(createFundingEvent, null, 4));
  });

  contract.on("DonateFunding", (_from, _to, value, event) => {
    console.log("Event : DonateFunding");
    let donateFundingEvent ={
        from: _from,
        to: _to,
        value : ethers.utils.formatEther(value._hex),
        data: event
    }
    console.log(JSON.stringify(donateFundingEvent, null, 4));
  });

  contract.on("WithdrawFunding", (_from, value, event) => {
    console.log("Event : WithdrawFunding");
    let withdrawFundingEvent ={
        from: _from,
        value : ethers.utils.formatEther(value._hex),
        data: event
    }
    console.log(JSON.stringify(withdrawFundingEvent, null, 4));

  });
}

main();
