// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
contract DocumentVersioning {
    struct DocumentVersion {
        uint256 versionId;
        uint256 documentId;
        string ipfsHash;
        uint256 createdAt;
        address creator;
    }
    mapping(uint256 => DocumentVersion[]) public versions;
    uint256 public versionCounter = 0;
    event VersionCreated(uint256 indexed documentId, uint256 indexed versionId);
    function createVersion(uint256 _documentId, string memory _ipfsHash) public {
        versionCounter++;
        versions[_documentId].push(DocumentVersion(versionCounter, _documentId, _ipfsHash, block.timestamp, msg.sender));
        emit VersionCreated(_documentId, versionCounter);
    }
    function getVersions(uint256 _documentId) public view returns (DocumentVersion[] memory) {
        return versions[_documentId];
    }
}
