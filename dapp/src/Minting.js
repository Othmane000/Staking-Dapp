import { useState } from "react";
import {ethers, BigNumber} from 'ethers' ;
import nft721 from './NFT721ABI.json';


const nft721Address = "0x9541a34fDa8294ad456bA118d06FaB2Dfec9ee83";
const Minting= ({accounts, setAccounts}) => {
    const [mintAmount, setMintAmount] = useState(1);
    const Connected = Boolean(accounts[0]);

    async function handleMint() {
        if (window.ethereum){
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner() ;
            signer.getAddress()
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

    const handleDecrement = () => {
        if (mintAmount <=1){
            return mintAmount ;
        } else {
            setMintAmount(mintAmount -1) ;
        }
    }

    const handleIncrement = () => {
        if (mintAmount >=3){
            return mintAmount ;
        } else {
            setMintAmount(mintAmount+ 1) ; 
        }
    }


    return(
        <div className="title-mintnow">
            <h1>Generative PyArt NFT</h1>
            <p>In 2081, humans come accross extraterrestrial messages that they need to de-cipher,<br/>
             mint an NFT to help humanity discover the galaxy's secrets </p>
            {Connected ? (
                <div>
                    <div>
                        <button id="plus-minus"onClick={handleDecrement}>-</button>
                        <input type="number" value={mintAmount}/>
                        <button id="plus-minus" onClick={handleIncrement}>+</button>
                    </div>
                    <button onClick={handleMint}>Mint Now</button>
                </div>
            ): (
                <p>No Wallet address connected to this Website</p>
            )}
        </div>
    )
}

export default Minting ;