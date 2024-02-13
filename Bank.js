const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Bank Contract", function () {
    let Bank;
    let bank;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async function () {
        // Get the ContractFactory and Signers here.
        Bank = await ethers.getContractFactory("Bank");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        try {
        // Deploy a new Bank contract for each test
        bank = await Bank.deploy(owner.address,{ value: ethers.parseEther("1.0") });
            } catch (error) {
                console.error("Error deploying the contract:", error);
            }
    });

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            expect(await bank.owner()).to.equal(owner.address);
        });

        // it("Should receive and store the deployment funds", async function () {
        //     expect(await bank.balanceOf(owner.address)).to.equal(ethers.parseEther("1.0"));
        // });
    });

    describe("Transactions", function () {
        it("Should allow deposits and update balances", async function () {
            const depositAmount = ethers.parseEther("1.0");
            await bank.connect(addr1).deposit({ value: depositAmount });

            expect(await bank.balanceOf(addr1.address)).to.equal(depositAmount);
        });

        it("Should allow withdrawals and update balances", async function () {
            const depositAmount = ethers.parseEther("1.0");
            await bank.connect(addr1).deposit({ value: depositAmount });
            await bank.connect(addr1).withdraw(depositAmount);

            expect(await bank.balanceOf(addr1.address)).to.equal(0);
        });

        it("Should allow transfers and update balances", async function () {
            const depositAmount = ethers.parseEther("0.5");
            await bank.connect(addr1).deposit({ value: depositAmount });
            await bank.connect(addr1).transfer(addr2.address, depositAmount);

            expect(await bank.balanceOf(addr1.address)).to.equal(0);
            expect(await bank.balanceOf(addr2.address)).to.equal(depositAmount);
        });
    });

    describe("Permissions", function () {
        it("Should revert if non-owner tries to check contract balance", async function () {
            await expect(bank.connect(addr1).contractBalance())
                .to.be.revertedWithCustomError(bank, 'NotContractOwnerCall');
        });
    });
});