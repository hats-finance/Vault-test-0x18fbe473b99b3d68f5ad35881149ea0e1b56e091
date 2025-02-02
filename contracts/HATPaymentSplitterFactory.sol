// SPDX-License-Identifier: MIT
// Disclaimer https://github.com/hats-finance/hats-contracts/blob/main/DISCLAIMER.md

pragma solidity 0.8.16;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./HATPaymentSplitter.sol";

contract HATPaymentSplitterFactory {
    address public immutable implementation;
    event HATPaymentSplitterCreated(address indexed _hatPaymentSplitter);

    constructor (address _implementation) {
        implementation = _implementation;
    }

    function createHATPaymentSplitter(address[] memory _payees, uint256[] memory _shares) external returns (address result) {
        result = Clones.cloneDeterministic(implementation, keccak256(abi.encodePacked(_payees, _shares)));
        HATPaymentSplitter(payable(result)).initialize(_payees, _shares);
        emit HATPaymentSplitterCreated(result);
    }

    function predictSplitterAddress(address[] memory _payees, uint256[] memory _shares) public view returns (address) {
        return Clones.predictDeterministicAddress(implementation, keccak256(abi.encodePacked(_payees, _shares)));
    }
}
