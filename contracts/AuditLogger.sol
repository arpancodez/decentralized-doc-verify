// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
contract AuditLogger {
    struct AuditLog {
        uint256 logId;
        address actor;
        string action;
        uint256 timestamp;
    }
    AuditLog[] public logs;
    event LogCreated(uint256 indexed logId, address indexed actor, string action);
    function log(string memory _action) public {
        logs.push(AuditLog(logs.length, msg.sender, _action, block.timestamp));
        emit LogCreated(logs.length - 1, msg.sender, _action);
    }
    function getLogs() public view returns (AuditLog[] memory) {
        return logs;
    }
}
