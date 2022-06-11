import { useState } from "react";
import {ethers, BigNumber} from 'ethers' ;
import nft721 from './NFT721ABI.json';


const nft721Address = "0x747e1F8212b7dD7033Ec84Be75C012f0dB94B63F";

const Minting= ({accounts, setAccounts}) => {
    const [mintAmount, setMintAmount] = useState(1);
    const Connected = Boolean(accounts[0]);

    async function handleMint() {
        if (window.ethereum){
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner() ;
            const contract = new ethers.Contract(
                nft721Address,
                nft721.abi,
                signer
            );
            try {
                const response = await contract.mint(BigNumber.from(mintAmount), {
                    value : ethers.utils.parseEther((0.01 * mintAmount).toString())
                });
                console.log('response: ',response);
            } catch (err) {
                console.log("error: ", err)
            }
        }
    }


    return(
        <div>
            <h1>Generative PyArt NFT</h1>
            {Connected ? (
                <div>
                    <button onClick={handleMint}>Mint Now</button>
                </div>
            ): (
                <p>No Wallet address connected to this Website</p>
            )}
        </div>
    )
}

export default Minting ;