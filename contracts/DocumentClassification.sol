// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
contract DocumentClassification {
    mapping(uint256 => string[]) public classifications;
    function addClassification(uint256 _documentId, string memory _tag) public {
        classifications[_documentId].push(_tag);
    }
    function getClassifications(uint256 _documentId) public view returns (string[] memory) {
        return classifications[_documentId];
    }
}
