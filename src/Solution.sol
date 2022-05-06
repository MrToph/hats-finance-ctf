// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import {Game} from "./Game.sol";

contract Solution {
    Game private immutable g;

    constructor(Game game) {
        g = game;
    }

    function solve() external {
    }
}
