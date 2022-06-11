import React from "react";

const NavBar = ({accounts, setAccounts}) => {
    const Connected = Boolean(accounts[0]);

    async function connectAccount() {
        if (window.ethereum){
            const accounts = await window.ethereum.request({
                method: "eth_requestAccounts"
            });
            setAccounts(accounts);
        }
    }

    return (
        <div>

            {/*left side fo the NavBar where there will be external links */}
            <div>Twitter</div>
            <div>Github</div>
            <div>Discord</div>


            {/*right side of the NavBar where you will be able to connect your account, wallet address will be displayed*/}  
            {Connected ? (
                <p>CONNECTED</p>
            ) : (
                <button onClick={connectAccount}>Connect Wallet</button>
            )}
        </div>
    )
}

export default NavBar;