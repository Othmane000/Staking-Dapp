import { useState } from "react";
import { ethers} from 'ethers';
import staking721 from './Staking721ABI.json';


const staking721address = "0x3966791501F31f99c9EB26111ec17d5D5D6c01F5" ;
const Staking = ({ accounts, setAccounts }) => {
    const [stakeAmount, setStakeAmount] = useState(1);
    

    async function handleStaking() {
        if (window.ethereum) {
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            signer.getAddress()
            const contract = new ethers.Contract(
                staking721address,
                staking721.abi,
                signer
            );
            const tokenID = document.getElementById("staking-token-id").value ;
            try {
                const response = contract.stake(tokenID);
                console.log('response: ', response);
            } catch (err) {
                console.log("error: ", err)
            }
        }
    }

    async function handleUnstaking() {
        if (window.ethereum) {
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            signer.getAddress()
            const contract = new ethers.Contract(
                staking721address,
                staking721.abi,
                signer
            );
            const tokenID = document.getElementById("staking-token-id").value;
            try {
                const response = contract.unstake(tokenID);
                console.log('response: ', response);
            } catch (err) {
                console.log("error: ", err)
            }
        }
    }

    async function handleClaiming() {
        if (window.ethereum) {
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            signer.getAddress()
            const contract = new ethers.Contract(
                staking721address,
                staking721.abi,
                signer
            );
            const tokenID = document.getElementById("staking-token-id").value;
            try {
                const response = contract.getReward(tokenID);
                console.log('response: ', response);
            } catch (err) {
                console.log("error: ", err)
            }
        }
    }

    
    return (
        <div className="staking-canvas">
            <h1>STAKING FORM</h1>
            <p>
                Stake your NFT for a reward of 3 tokens per 10 seconds
            </p>
            <div>
                <input id="staking-token-id" type="number"/>
            </div>
            <div>

            </div>
            <div className="staking-button">
                <div>
                    <button onClick={handleClaiming}>Claim Rewards</button>
                    
                </div>
                <div>
                <button  onClick={handleStaking}>Stake</button>
                <button  onClick={handleUnstaking}>Unstake</button>
                </div>
            </div>
        </div>
    )
}

export default Staking;