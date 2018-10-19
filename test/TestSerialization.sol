pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Core/ZB/ZBGameMode.sol";
import "../contracts/Core/ZBGameModeSerialization.sol";
import "../contracts/3rdParty/Seriality/BytesToTypes.sol";
import "../contracts/3rdParty/Seriality/SizeOf.sol";
import "../contracts/3rdParty/Seriality/TypesToBytes.sol";

contract TestSerialization {
    using ZBGameModeSerialization for ZBGameModeSerialization.SerializedGameStateChanges;
    using ZBGameModeSerialization for ZBGameMode.GameState;

    function testDeserializeInts() public {
        bytes memory buffer = hex'00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000003000201';
        uint offset = buffer.length;
        Assert.equal(int(BytesToTypes.bytesToInt8(offset, buffer)), int(1), "");
        offset -= SizeOf.sizeOfInt(8);
        Assert.equal(int(BytesToTypes.bytesToInt16(offset, buffer)), int(2), "");
        offset -= SizeOf.sizeOfInt(16);
        Assert.equal(int(BytesToTypes.bytesToInt32(offset, buffer)), int(3), "");
        offset -= SizeOf.sizeOfInt(32);
        Assert.equal(int(BytesToTypes.bytesToInt64(offset, buffer)), int(4), "");
        offset -= SizeOf.sizeOfInt(64);
    }

    function testDeserializeStrings() public {
        bytes memory buffer = hex'436f6f6c20427574746f6e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b';
        uint offset = buffer.length;
        uint size = BytesToTypes.getStringSize(offset, buffer);
        string memory str = new string(size);
        BytesToTypes.bytesToString(offset, buffer, bytes(str));
        Assert.equal(str, "Cool Button", "");

        buffer = hex'000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f6c20427574746f6e20300000000000000000000000000000000000000000003720436f6f6c20427574746f6e203820436f6f6c20427574746f6e203920436f746f6e203520436f6f6c20427574746f6e203620436f6f6c20427574746f6e2020427574746f6e203320436f6f6c20427574746f6e203420436f6f6c20427574436f6f6c20427574746f6e203120436f6f6c20427574746f6e203220436f6f6c000000000000000000000000000000000000000000000000000000000000008b';
        offset = buffer.length;
        size = BytesToTypes.getStringSize(offset, buffer);
        str = new string(size);
        BytesToTypes.bytesToString(offset, buffer, bytes(str));
        Assert.equal(str, "Cool Button 1 Cool Button 2 Cool Button 3 Cool Button 4 Cool Button 5 Cool Button 6 Cool Button 7 Cool Button 8 Cool Button 9 Cool Button 0", "");
    }

    function testDeserializeGameState() public {
        bytes memory buffer = hex'0a0a0603000014706c617965722d320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000010000000100536f6f7468736179657200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000f706c617965722d320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000010000000100536f6f7468736179657200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000010706c617965722d320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000020000000300426f756e63657200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000014706c617965722d3200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000300000003005075736868680000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000015706c617965722d320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000010000000100417a7572617a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000b00000005706c617965722d320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000010000000100417a7572617a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000c706c617965722d320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000010000000200576865657a790000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000012706c617965722d320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000010000000200576865657a79000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000001100000003000000000000000244656661756c740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000000000000706c617965722d3200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080a0a0603000014706c617965722d310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000010000000100536f6f7468736179657200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000004706c617965722d310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000010000000100536f6f7468736179657200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000005706c617965722d310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000020000000300426f756e63657200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000009706c617965722d310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000030000000300507573686868000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000a706c617965722d310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000010000000100417a7572617a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000005706c617965722d310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000010000000100417a7572617a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000001706c617965722d310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000010000000200576865657a790000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000007706c617965722d310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000010000000200576865657a79000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000600000003000000000000000244656661756c740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000000000000706c617965722d310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000005';
        ZBGameMode.GameState memory gameState;
        gameState.initWithSerializedData(buffer);

        Assert.equal(gameState.id, int64(5), "");
        Assert.equal(int(gameState.currentPlayerIndex), uint8(0), "");
        Assert.equal(int(gameState.playerStates[0].defense), int(20), "");
        Assert.equal(int(gameState.playerStates[0].currentGoo), int(0), "");
        Assert.equal(int(gameState.playerStates[0].gooVials), int(0), "");
        Assert.equal(int(gameState.playerStates[0].initialCardsInHandCount), int(3), "");
        Assert.equal(int(gameState.playerStates[0].maxCardsInPlay), int(6), "");
        Assert.equal(int(gameState.playerStates[0].maxCardsInHand), int(10), "");
        Assert.equal(int(gameState.playerStates[0].maxGooVials), int(10), "");
        Assert.equal(int(gameState.playerStates[0].deck.id), int(0), "");
        Assert.equal(int(gameState.playerStates[0].deck.heroId), int(2), "");
        Assert.equal(int(gameState.playerStates[0].cardsInDeck.length), int(5), "");
        Assert.equal(int(gameState.playerStates[0].cardsInHand.length), int(3), "");

        Assert.equal(int(gameState.playerStates[1].defense), int(20), "");
        Assert.equal(int(gameState.playerStates[1].currentGoo), int(0), "");
        Assert.equal(int(gameState.playerStates[1].gooVials), int(0), "");
        Assert.equal(int(gameState.playerStates[1].initialCardsInHandCount), int(3), "");
        Assert.equal(int(gameState.playerStates[1].maxCardsInPlay), int(6), "");
        Assert.equal(int(gameState.playerStates[1].maxCardsInHand), int(10), "");
        Assert.equal(int(gameState.playerStates[1].maxGooVials), int(10), "");
        Assert.equal(int(gameState.playerStates[1].deck.id), int(0), "");
        Assert.equal(int(gameState.playerStates[1].deck.heroId), int(2), "");
        Assert.equal(int(gameState.playerStates[1].cardsInDeck.length), int(5), "");
        Assert.equal(int(gameState.playerStates[1].cardsInHand.length), int(3), "");
    }
}