// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {

    uint256 number;
    bytes32 SOLUTION = 0xf334c379ee6e505418b35854e9e9ecbb303f32bf28440452255b6f3ffc6471ce;
    bytes32 SLOG = 0x0000000000000000000000000000000000000000000000000000000000000000;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public returns(uint256) {
        number = num;
        return (number);
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return (number);

    }


    function display(string memory _string) public pure returns(string memory) {
        return (_string);
    }

    function hash(string memory _string) public view returns(bytes32){ 

        if    (keccak256(abi.encodePacked(_string)) == SOLUTION) {
            return (SLOG);
        }
        return keccak256(abi.encodePacked(_string));
        
    }

    function check_puzzle(string memory _string) public view returns(string memory){ 

        // THIS IS THE PUZZLE FUNCTION!
        if (hash(_string) == SLOG) {
            return("puzzle solved");
        } else {
            return("wrong!");
        }

    }


}
