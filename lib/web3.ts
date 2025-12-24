// Web3 utility functions
import Web3 from 'web3';
import { ethers } from 'ethers';

let web3: Web3;
let provider: ethers.BrowserProvider;
let signer: ethers.JsonRpcSigner;

// Initialize Web3
export const initializeWeb3 = async () => {
  if (typeof window !== 'undefined' && (window as any).ethereum) {
    web3 = new Web3((window as any).ethereum);
    provider = new ethers.BrowserProvider((window as any).ethereum);
    signer = await provider.getSigner();
    return true;
  }
  return false;
};

// Connect wallet
export const connectWallet = async () => {
  try {
    const accounts = await (window as any).ethereum.request({
      method: 'eth_requestAccounts',
    });
    return accounts[0];
  } catch (error) {
    console.error('Wallet connection failed:', error);
    throw error;
  }
};

// Get current account
export const getCurrentAccount = async () => {
  const accounts = await web3.eth.getAccounts();
  return accounts[0];
};

// Get network ID
export const getNetworkId = async () => {
  return await web3.eth.net.getId();
};

// Get balance
export const getBalance = async (address: string) => {
  const balance = await web3.eth.getBalance(address);
  return web3.utils.fromWei(balance, 'ether');
};

// Send transaction
export const sendTransaction = async (to: string, value: string) => {
  try {
    const tx = await signer.sendTransaction({
      to,
      value: ethers.parseEther(value),
    });
    return await tx.wait();
  } catch (error) {
    console.error('Transaction failed:', error);
    throw error;
  }
};

// Get signer
export const getSigner = () => signer;

// Get provider
export const getProvider = () => provider;

export { web3, provider };
