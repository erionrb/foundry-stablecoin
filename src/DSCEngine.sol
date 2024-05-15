// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title DSCEngine
 * @author Erion Barasuol
 *
 * The system is designed to be as minimal as possible, and have the tokens maintain a 1
 * token == $1 peg.
 * This stable has the properties:
 * - Exogenous Collateral
 * - Dollar Pegged
 * - Algoritmically Stable
 *
 * It is similiar to DAI if DAI had no governance, no fees, ands was only backed by WETH and
 * WBTC.
 *
 * Our DSC system should always be "overcollateralized". At no point, should the valuye of
 * all collateral <= the $ backed of all the DSC.
 *
 * @notice This contract is the core of the DSC Sytem. It handles all the logic for mining
 * and redeeming DSCm as well as depositing & withdrawing collateral.
 * @notice This contract is VERY loosely based on the MakerDAO DSS (DAI) system.
 */
contract DSCEngine is ReentrancyGuard {
    //////////////////////////////
    // Errors                   //
    //////////////////////////////
    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenAddressAndPriceFeedAddressMustBeSameLength();
    error DSCEngine__NotAllowedToken();
    error DSCEngine__TransferFailed();

    //////////////////////////////
    // State Variables          //
    //////////////////////////////
    mapping(address token => address priceFeed) private s_priceFeeds; // tokenToPriceFeed
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;

    //////////////////////////////
    // Events          //
    //////////////////////////////
    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);

    DecentralizedStableCoin private immutable i_dsc;

    //////////////////////////////
    // Modifiers                //
    //////////////////////////////
    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine__NotAllowedToken();
        }
        _;
    }

    //////////////////////////////
    // Functions                //
    //////////////////////////////
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddress, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddress.length) {
            revert DSCEngine__TokenAddressAndPriceFeedAddressMustBeSameLength();
        }

        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddress[i];
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    //////////////////////////////
    // External Functions       //
    //////////////////////////////
    function depositCollateralAndMinDSC() external {}

    /**
     * Deposit collateral into the system. This will allow the user to mint DSC
     * @param tokenCollateralAddress The address of the token to deposit as collatreal
     * @param amountCollateral The amount of collateral to deposit
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    function redeemCollateralForDSC() external {}

    function redeemCollateral() external {}

    function mintDsc() external {}

    function burnDsc() external {}

    function liquidate() external {}

    function gethealthFactor() external view {}
}
