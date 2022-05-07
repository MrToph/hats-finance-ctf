// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import {Game} from "../src/Game.sol";
import {Solution} from "../src/Solution.sol";

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
}
