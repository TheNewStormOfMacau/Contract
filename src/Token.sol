// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract Game is ERC20, ERC20Burnable, VRFConsumerBaseV2Plus {
    /* State variables */
    //Chainlink VRF Variables
    uint256 private immutable i_subscriptionId;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 30;
    mapping(uint256 => address) private s_requestIdToUsers;
    mapping(address => uint256) private s_userToAmount;
    mapping(address => uint256[]) private s_userToChoice;
    mapping(address => uint256) private s_userToTotal;

    event GameStarted(address indexed user, uint256 indexed requestId, uint256 indexed amount);
    event GameEnded(address indexed user, uint256 indexed amount);

    /* Constructor */
    constructor(
        uint256 subscriptionId,
        bytes32 gasLane,
        uint32 callbackGasLimit,
        address vrfCoordinatorV2) ERC20("MacauStorm", "MS") VRFConsumerBaseV2Plus(vrfCoordinatorV2) {
            i_gasLane = gasLane;
            i_callbackGasLimit = callbackGasLimit;
            i_subscriptionId = subscriptionId;
        }

    function burn(address from, uint256 amount) public onlyOwner{
        _burn(from, amount);
    }

    function burn(uint256 amount) override public {
        _burn(_msgSender(), amount);
    }

    function exchangeToken() public payable {
        s_userToTotal[_msgSender()] += msg.value;
        _mint(_msgSender(), msg.value);
    }

    function TotalOf(address user) public view returns (uint256) {
        return s_userToTotal[user];
    }

    function startGame(uint256 amount, uint256[] calldata words) public {
        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: i_gasLane,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );
        s_requestIdToUsers[requestId] = _msgSender();
        s_userToAmount[_msgSender()] = amount;
        s_userToChoice[_msgSender()] = words;

        emit GameStarted(_msgSender(), requestId, amount);
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] calldata randomWords
    ) internal override {
        address user = s_requestIdToUsers[requestId];
        uint256 amount = s_userToAmount[user];
        uint256[] memory words = s_userToChoice[user];
        uint8 count = 0;
        for (uint256 i = 0; i < randomWords.length; i++) {
            for(uint256 j = 0; j < words.length; j++) {
                if(count == 15)
                    break;
                if(randomWords[i] % 120 == words[j]) {
                    count++;
                }
            }
        }
        
        uint256 index = 0;
        if(count < 5){
            index = 0;
        }
        else if (count < 10){
            index = 1;
        }
        else if (count < 15){
            index = 3;
        }else {
            index = 9;
        }
        if(index != 0)
            _mint(user, index * amount);
        emit GameEnded(user, index * amount);
    }
}
