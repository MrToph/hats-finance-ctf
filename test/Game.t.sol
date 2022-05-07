// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import {Game} from "../src/Game.sol";
import {Solution} from "../src/Solution.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract GameTest is Test {
    Game internal game;

    function setUp() public {
        game = new Game();
    }

    function testSolve() public {
        assertEq(game.flagHolder(), address(this));
        
        Solution solution = new Solution(game);
        solution.solve();

        assertEq(game.flagHolder(), address(solution));
    }


    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        // we assume that the flagHolder (this contract) is an EOA or a contract that accepts the ERC20
        return IERC721Receiver.onERC721Received.selector;
    }
}
