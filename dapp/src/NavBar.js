import React from "react";
import './App.css';
import { ethers, BigNumber } from 'ethers';
import Twitter from "C:\\Users\\Othmane\\Desktop\\Staking-Dapp\\dapp\\src\\assets\\twitter.webp";
import Discord from "C:\\Users\\Othmane\\Desktop\\Staking-Dapp\\dapp\\src\\assets\\discord.png";
import Opensea from "C:\\Users\\Othmane\\Desktop\\Staking-Dapp\\dapp\\src\\assets\\opensea.png";

const iconsize = 70 ;
let useraddress
const NavBar = ({accounts, setAccounts}) => {
    const Connected = Boolean(accounts[0]);

    async function connectAccount() {
        if (window.ethereum){
            const accounts = await window.ethereum.request({
                method: "eth_requestAccounts"
            });
            setAccounts(accounts);
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            useraddress = signer.getAddress();
            let balance = signer.getBalance();
            console.log(useraddress);
            console.log(balance);
        }
    }

    

    return (
        <div className="NavBar">
            <div className="NavBar-left">
                {/*left side fo the NavBar where there will be external links */}
                <a href="https://twitter.com"  >
                    <img src={Twitter} width={iconsize} height={iconsize}></img>
                </a>
                <a href="https://discord.com">
                    <img src={Discord} width={iconsize} height={iconsize}></img>
                </a>
                <a href="https://testnets.opensea.io/collection/othmane-hachads-pyart-collection">
                    <img src={Opensea} width={iconsize} height={iconsize} ></img>
                </a>
            </div>


            <div className="NavBar-right">
                {/*right side of the NavBar where you will be able to connect your account, wallet address will be displayed*/}  
                {Connected ? (
                    <p>Connected</p>
                ) : (
                    <button onClick={connectAccount}>Connect Wallet</button>
                )}
            </div>
        </div>
    )
}

export default NavBar;