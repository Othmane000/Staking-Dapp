import './App.css';
import {useState} from 'react' ;
import Minting from './Minting' ;
import NavBar from './NavBar';
import Staking from './Staking' ;
import WalletContent from './WalletContent';

/*
  We are going to have three parts on the app :
    I- NavBar where users will be sble to connect their wallets and access external links.
    II- The mint section where users will be able to mint one of the python generated NFTs (small)
    III- The staking section where users will be able to stake their NFTs for the native ERC20 token HCD2. (big)
*/

function App() {
  const [accounts, setAccounts] = useState([]) ;
  return (
    <div className ="overlay">
      <div className="App">
        <NavBar accounts={accounts} setAccounts={setAccounts}/>
        <Minting accounts={accounts} setAccounts={setAccounts} />
        <Staking accounts={accounts} setAccounts={setAccounts} />
        <WalletContent/>
      </div>
      <div className="moving-background"></div>
    </div>
  );
}

export default App;
