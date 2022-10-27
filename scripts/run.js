const main = async () => {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const nftContractFactory = await ethers.getContractFactory('HodlBeerNFT');
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // make a nft
  // Call the function.
  let txn = await nftContract.makeNFT(11,{value: ethers.utils.parseEther("0.02")})
  // Wait for it to be mined.
  await txn.wait()
  console.log("Minted NFT #1")

  // make a nft
  txn = await nftContract.makeNFT('test',{value: ethers.utils.parseEther("0.02")})
  // Wait for it to be mined.
  await txn.wait()
  console.log("Minted NFT #2")

  // make reserveNFT 
  txn = await nftContract.reserveNFT(150)
  // Wait for it to be mined.
  await txn.wait()
  console.log("Minted reserve 150 NFT")

  // show CURRENT_PRICE_1
  let price1 = await nftContract.CURRENT_PRICE_1()
  console.log("price1:", ethers.utils.formatEther(price1))

  // set/show CURRENT_PRICE_2
  tnx = await nftContract.setCurrentPrice2(0)
  let price2 = await nftContract.CURRENT_PRICE_2()
  console.log("price2:", ethers.utils.formatEther(price2))

  // change BASE_URI
  let nft1 = await nftContract.tokenURI(0)
  console.log("uri nft1:", nft1)

  txn = await nftContract.setBaseURI("https://test.com/api/")
  // Wait for it to be mined.
  await txn.wait()
  console.log("BaseURI changed")

  nft1 = await nftContract.tokenURI(0)
  console.log("new uri nft1:", nft1)

  let message = '0x00'
  let hash = ethers.utils.id(message)
  console.log("hash", hash)

  let bytes = ethers.utils.arrayify(hash)
  let signature = await deployer.signMessage(bytes)
  console.log("signature", signature)

  let recover = await nftContract.recoverSigner(hash, signature)
  console.log("signed by", recover.toString())

  let signer = await nftContract.SIGNER()
  console.log("signer", signer);

  txn = await nftContract.signNFT(hash, signature, {value: 0});
  await txn.wait()
  console.log("Minted NFT #153 with sign")

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
