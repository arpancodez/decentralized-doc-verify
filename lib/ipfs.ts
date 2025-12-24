// IPFS Integration functions
import { create } from 'ipfs-http-client';

const IPFS_API_URL = process.env.IPFS_API_URL || 'http://localhost:5001';
const IPFS_GATEWAY = process.env.IPFS_GATEWAY_URL || 'https://ipfs.io/ipfs/';

let ipfsClient: any;

// Initialize IPFS client
export const initializeIPFS = async () => {
  try {
    ipfsClient = create({
      url: IPFS_API_URL,
    });
    return ipfsClient;
  } catch (error) {
    console.error('IPFS initialization failed:', error);
    throw error;
  }
};

// Upload file to IPFS
export const uploadToIPFS = async (file: File | Buffer) => {
  try {
    if (!ipfsClient) {
      await initializeIPFS();
    }

    const content = file instanceof File ? 
      await file.arrayBuffer() : file;

    const result = await ipfsClient.add(content, {
      progress: (prog) => console.log(`Added: ${prog}`),
    });

    return result.path;
  } catch (error) {
    console.error('Upload to IPFS failed:', error);
    throw error;
  }
};

// Get file from IPFS
export const getFromIPFS = async (hash: string) => {
  try {
    if (!ipfsClient) {
      await initializeIPFS();
    }

    let content = Buffer.alloc(0);
    for await (const chunk of ipfsClient.cat(hash)) {
      content = Buffer.concat([content, chunk]);
    }
    return content;
  } catch (error) {
    console.error('Failed to retrieve from IPFS:', error);
    throw error;
  }
};

// Get IPFS gateway URL
export const getIPFSGatewayURL = (hash: string) => {
  return `${IPFS_GATEWAY}${hash}`;
};

// Pin file to IPFS
export const pinToIPFS = async (hash: string) => {
  try {
    if (!ipfsClient) {
      await initializeIPFS();
    }
    await ipfsClient.pin.add(hash);
    return true;
  } catch (error) {
    console.error('Failed to pin to IPFS:', error);
    throw error;
  }
};

// Unpin file from IPFS
export const unpinFromIPFS = async (hash: string) => {
  try {
    if (!ipfsClient) {
      await initializeIPFS();
    }
    await ipfsClient.pin.rm(hash);
    return true;
  } catch (error) {
    console.error('Failed to unpin from IPFS:', error);
    throw error;
  }
};

// Get IPFS client
export const getIPFSClient = () => ipfsClient;
