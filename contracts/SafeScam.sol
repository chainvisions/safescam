pragma solidity 0.5.16;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./interfaces/IUniswapRouter.sol";

/*
* Introducing SafeScam, another Safe token on Binance Smart Chain.
*
*
*
* == WHY? ==
*
* It's been a quiet, boring Saturday night so I have decided, "why not write some token contract for fun?".
*
*
*
* == SYSTEM EXPLANATION ==
*
* SafeScam is ponzinomics taken to a level of extremity. It is a useless token that anyone can mint and it 
* can be redeemed for BUSD held by the SafeScam contract. To mint SafeScam, you can call `claim()` on the contract.
* You will be minted SSCAM proportional to your BELUGA holdings, hold 1 BELUGA, get 1 SSCAM. A total of 1k SSCAM can
* be minted through claiming. Now you may be asking one question "Can't this be sybiled" and you are very correct. This
* is why you can only claim SSCAM once per address and you MUST be holding a minimum of 2 BELUGA or else your claim will
* not go through.
*
* You can also redeem your SSCAM tokens for BUSD. To do this, you can call the `redeem()` function. This will redeem your
* SSCAM tokens for BUSD based on this formula: `BUSD in contract / SSCAM Supply`. SSCAM also has a function called `swapHeld()` 
* which allows the owner of the contract (Chainvisions) to swap any airdrops sent to the contract into BUSD, giving rewards to 
* SSCAM holders.
* 
*/

contract SafeScam is Ownable, ERC20, ERC20Detailed {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address public beluga;
    IUniswapV2Router01 public constant router = IUniswapV2Router01(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
    address public rewardToken;
    uint256 public airdropReserves = 1000e18;
    event Claim(address indexed user, uint256 indexed balance);

    constructor() public ERC20Detailed("SafeScam", "SSCAM", 18) {
        _mint(address(this), airdropReserves);
    }

    // Allows for SSCAM to go brrr
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    // Claim free SSCAM
    function claim() public {
        uint256 belugaBalance = IERC20(beluga).balanceOf(msg.sender);
        require(belugaBalance >= 2e18, "SSCAM: Min balance is 2 BELUGA");
        require(belugaBalance <= airdropReserves, "SSCAM: Reserves exhausted");
        airdropReserves = airdropReserves.sub(belugaBalance);
        transfer(msg.sender, belugaBalance);
        emit Claim(msg.sender, belugaBalance);
    }

    // Redeem SSCAM for rewards
    function redeem(uint256 _amount) public {
        _burn(msg.sender, _amount);
        uint256 reward = IERC20(rewardToken).balanceOf(address(this)).div(totalSupply());
        IERC20(rewardToken).safeTransfer(msg.sender, reward);
    }

    // Get how much 1 SSCAM can be redeemed for
    function price() external view returns (uint256) {
        return IERC20(rewardToken).balanceOf(address(this)).div(totalSupply());
    }

    function transferERC20(address _token, uint256 _amount) public onlyOwner {
        require(_token != address(this), "Nice try");
        IERC20(_token).safeTransfer(owner(), _amount);
    }

    function swapHeld(uint256 _amount, address[] memory route) public onlyOwner {
        IERC20(route[0]).safeApprove(address(router), 0);
        IERC20(route[0]).safeApprove(address(router), IERC20(route[0]).balanceOf(address(this)));
        router.swapExactTokensForTokens(_amount, 0, route, address(this), block.timestamp.add(600));
    }

}