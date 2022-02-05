import './styles/App.css';
import twitterLogo from './assets/twitter-logo.svg';
import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import myEpicNft from './utils/MyEpicNFT.json';

// Constants
const TWITTER_HANDLE = '_buildspace';
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;
const OPENSEA_LINK = '';
const TOTAL_MINT_COUNT = 50;

const App = () => {

  const [currentAccount, setCurrentAccount] = useState("");

  const checkIfWalletIsConnect = async () => {
    const { ethereum } = window;

    if (!ethereum) {
      console.log("You need to get meta mask pls dawg!");
      return;
    } else {
      console.log("We have an ethereum object", ethereum);
    }
  
    // check if we're authorised to access a user's wallet
    const accounts = await ethereum.request({ method: 'eth_accounts' });
    
    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account:", account);
      setCurrentAccount(account);
    } else {
      console.log("No authorized account found :( !!");
    }
  };
  
  const connectWallet = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum) {
        alert('Get meta mask dawg !!');
        return;
      }

      // request access to eth account
      const accounts = await ethereum.request({ method: "eth_requestAccounts" })

      // log public address of connected account
      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]);
    } catch (error) {
      console.log(error);
    }
  };

  const askContractToMintNFT = async () => {
    const CONTRACT_ADDRESS = "0x011f8a8d4E90b3897d89d22B76a5eC13AC0f804E";

    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, myEpicNft.abi, signer);

        console.log('asking to mint NFT on contract');
        let nftTxn = await connectedContract.makeAnEpicNFT();

        console.log("Mining.. please wait..");
        await nftTxn.wait();

        console.log(`Mined, see transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`);
      } else {
        console.log('Ethereum object does not exist!');
      }
    } catch (error) {
      console.log(error);
    }
  }

  // Render Methods
  const renderNotConnectedContainer = () => (
    <button onClick={connectWallet} className="cta-button connect-wallet-button">
      Connect to Wallet
    </button>
  );

  useEffect(() => {
    checkIfWalletIsConnect();
  }, []);

  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">My NFT Collection</p>
          <p className="sub-text">
            Each unique. Each beautiful. Discover your NFT today.
          </p>
          { currentAccount === "" ? ( 
              renderNotConnectedContainer() 
            ) : (  
              <button onClick={askContractToMintNFT} className="cta-button connect-wallet-button">
                Mint NFT
              </button>
            ) 
          }
        </div>
        <div className="footer-container">
          <img alt="Twitter Logo" className="twitter-logo" src={twitterLogo} />
          <a
            className="footer-text"
            href={TWITTER_LINK}
            target="_blank"
            rel="noreferrer"
          >{`built on @${TWITTER_HANDLE}`}</a>
        </div>
      </div>
    </div>
  );
};

export default App;
