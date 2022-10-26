// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {

    uint256 number;
    bytes32 SOLUTION = 0xdc8051ffd210f581baa3117339b87469780fe32f1cbf08a1cccc7cc3676c1e11;
    bytes32 NOG = 0x008051ffd210f581baa3117339b87469780fe32f1cbf08a1cccc7cc3676c1e11;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return (number * 10);

    }
    function hash(string memory _string) public view returns(bytes32){ 

        if    (keccak256(abi.encodePacked(_string)) == SOLUTION) {
            return (NOG);
        }
        return keccak256(abi.encodePacked(_string));
        
    }


}
