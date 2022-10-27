const main = async () => {
  const CONTRACT = "0x779d37AcaD165C719583a010E1548d358f23373C";

  const nftContractFactory = await ethers.getContractFactory('HodlBeerNFT');
  const nftContract = await nftContractFactory.attach(CONTRACT);

/*
  // make a nft
  // Call the function.
  let txn = await nftContract.makeNFT({value: ethers.utils.parseEther("0.015")})
  // Wait for it to be mined.
  await txn.wait()
  console.log("Minted NFT #1", txn)
*/

  // Call the function.
  let txn = await nftContract.setBaseURI('ipfs://QmQSUH2Jd4HJ9GFAt28nvkwYvF3NwrJX6LoNGMj1DvLTvt/')
  await txn.wait()
  console.log("withdraw")

  // Call the function.
  txn = await nftContract.tokenURI(6);
  console.log(txn)

  // show total
  let all = await nftContract.totalSupply()
  console.log("total:", all.toNumber())
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
