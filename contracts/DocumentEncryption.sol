// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title DocumentEncryption
 * @dev Document encryption management using key-value pairs
 */
contract DocumentEncryption {
    
    struct EncryptedDocument {
        uint256 documentId;
        bytes32 encryptionKeyHash;
        bool isEncrypted;
        uint256 encryptedAt;
        address encryptedBy;
    }
    
    mapping(uint256 => EncryptedDocument) public encryptedDocs;
    mapping(uint256 => mapping(address => bool)) public authorizedDecryptors;
    
    event DocumentEncrypted(uint256 indexed documentId, address indexed encryptedBy);
    event DecryptionAuthorized(uint256 indexed documentId, address indexed decryptor);
    event DocumentDecrypted(uint256 indexed documentId, address indexed decryptedBy);
    
    /**
     * @dev Encrypt a document
     */
    function encryptDocument(uint256 _documentId, bytes32 _keyHash) public {
        require(_documentId > 0, "Invalid document ID");
        require(_keyHash != bytes32(0), "Invalid key hash");
        
        encryptedDocs[_documentId] = EncryptedDocument({
            documentId: _documentId,
            encryptionKeyHash: _keyHash,
            isEncrypted: true,
            encryptedAt: block.timestamp,
            encryptedBy: msg.sender
        });
        
        emit DocumentEncrypted(_documentId, msg.sender);
    }
    
    /**
     * @dev Authorize decryption for specific address
     */
    function authorizeDecryption(uint256 _documentId, address _decryptor) public {
        require(encryptedDocs[_documentId].encryptedBy == msg.sender, "Not authorized");
        require(_decryptor != address(0), "Invalid address");
        
        authorizedDecryptors[_documentId][_decryptor] = true;
        emit DecryptionAuthorized(_documentId, _decryptor);
    }
    
    /**
     * @dev Decrypt document
     */
    function decryptDocument(uint256 _documentId) public {
        require(encryptedDocs[_documentId].isEncrypted, "Document not encrypted");
        require(authorizedDecryptors[_documentId][msg.sender], "Not authorized to decrypt");
        
        emit DocumentDecrypted(_documentId, msg.sender);
    }
    
    /**
     * @dev Check if document is encrypted
     */
    function isEncrypted(uint256 _documentId) public view returns (bool) {
        return encryptedDocs[_documentId].isEncrypted;
    }
    
    /**
     * @dev Get encryption details
     */
    function getEncryptionDetails(uint256 _documentId) public view returns (EncryptedDocument memory) {
        return encryptedDocs[_documentId];
    }
}
