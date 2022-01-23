const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SpecialNFT", function () {
  let specialNFT;
  const URI = "ipfs://QmTpaJRhRHjSpa2bqbCcwSWK5Aw9zcDr7bkRxC1pccAj7s"
  
  beforeEach(async () => {
    const SpecialNFT = await ethers.getContractFactory("SpecialNFT");
    specialNFT = await SpecialNFT.deploy();
    await specialNFT.deployed();
  });

  it("Should Mint an NFT", async () => {
    const [owner, minterOne] = await ethers.getSigners();
  
    await specialNFT.connect(minterOne).mintSpecialNFT(URI, { value: BigInt(5*10**17) })
  
    expect(await specialNFT.ownerOf(1)).to.equal(minterOne.address);
    expect(await specialNFT.tokenURI(1)).to.equal(URI);
  });

  it("Should revert if minter does not send the correct amount of eth", async () => {
    const [owner, minterOne] = await ethers.getSigners();
  
    await expect(specialNFT.connect(minterOne).mintSpecialNFT(URI, { value: 2000 })).to.be.revertedWith("Send the correct amount");
  });

  it("Should withdraw failed if owner is not call the function", async () => {
    const [owner, minterOne] = await ethers.getSigners();

    await expect(specialNFT.connect(minterOne).withdraw()).to.be.revertedWith("Ownable: caller is not the owner");
  });

});
