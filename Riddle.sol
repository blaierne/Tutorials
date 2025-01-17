// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.12;

interface ERC20 {
    // We only need these functions, the rest don't matter
    function balanceOf(address account) external view returns (uint256);
    function transfer(address receiver, uint256 amount) external returns (bool);
    function transferFrom(address sender, address receiver, uint256 amount) external returns (bool);
}

contract Dexploit {
    uint256 private constant ONE = 10**18;

    address public admin;

    uint256 public adminFee;
    uint256 private accruedLiquiditySinceLastClaim;
    uint256 public nextFeeClaimTimestamp;

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    uint256 constant private unlocked = 1;
    uint256 constant private locked = 0;
    uint256 private lock = unlocked;
    // Slap this bad boy on all external functions because why not
    modifier nonReentrant() {
        require(lock == unlocked);
        lock = locked;
        _;
        lock = unlocked;
    }

    constructor(address tokenA, address tokenB) {
        admin = msg.sender;
        adminFee = 0.01 * 10**18;
        liquidityFee = 0.01 * 10**18;

        underlyingA = ERC20(tokenA);
        underlyingB = ERC20(tokenB);
    }

    event AdminFeeChanged(uint256 indexed oldFee, uint256 indexed newFee);
    function changeAdminFees(uint256 newAdminFee) external onlyAdmin nonReentrant {
        emit AdminFeeChanged(retireOldAdminFee(), setNewAdminFee(newAdminFee));
    }
    function retireOldAdminFee() internal returns (uint256) {
        // Claim admin fee before changing it
        _claimAdminFees();
        // Let people withdraw their funds if they don't like the new fee
        nextFeeClaimTimestamp = block.timestamp + 7 days;

        return adminFee;
    }
    function setNewAdminFee(uint256 newAdminFee) internal returns (uint256) {
        adminFee = newAdminFee;
        return newAdminFee;
    }

    event AdminFeeClaimed(address indexed receiver, uint256 feeAmount);
    function claimAdminFees() external onlyAdmin nonReentrant {
        _claimAdminFees();
    }
    function _claimAdminFees() internal {
        require(block.timestamp >= nextFeeClaimTimestamp, "You must wait a week after changing fees to claim.");
        // Refund :D
        nextFeeClaimTimestamp = 0;

        uint256 amountAccrued = accruedLiquiditySinceLastClaim;
        if (amountAccrued == 0) return;

        uint256 _balanceA = balanceA;
        uint256 _balanceB = balanceB;

        // Can only claim in balanced proportions
        uint256 feeAmount = (amountAccrued * adminFee) / ONE;
        uint256 liquidity = geometricMean(_balanceA, _balanceB);
        uint256 amountA = (feeAmount * _balanceA) / liquidity;
        uint256 amountB = (feeAmount * _balanceB) / liquidity;

        // Update balances
        accruedLiquiditySinceLastClaim = 0;
        balanceA = _balanceA - amountA;
        balanceB = _balanceB - amountB;

        // Transfer funds out
        transferFundsOut(underlyingA, amountA);
        transferFundsOut(underlyingB, amountB);

        emit AdminFeeClaimed(admin, feeAmount);
    }

    // +----------------------------+
    // | External Public Operations |
    // +----------------------------+

    ERC20 public immutable underlyingA;
    ERC20 public immutable underlyingB;

    uint256 public balanceA;
    uint256 public balanceB;

    uint256 public totalSupply;
    uint256 public liquidityFee;

    mapping(address => uint256) public balances;

    function trade(uint256 amountIn, bool fromUnderlyingB) external nonReentrant returns (uint256) {
        ERC20 underlyingFrom = underlyingA;
        ERC20 underlyingTo = underlyingB;
        uint256 balanceFrom = balanceA;
        uint256 balanceTo = balanceB;

        if (fromUnderlyingB) {
            (underlyingFrom, underlyingTo) = (underlyingTo, underlyingFrom);
            (balanceFrom, balanceTo) = (balanceTo, balanceFrom);
        }

        // Transfer amount in
        uint256 receivedAmount = transferFundsIn(underlyingFrom, amountIn);
        
        // Constant product formula
        // Invariants:
        // balanceFrom * balanceTo = newToBalance * newFromBalance
        // balanceFrom + receivedAmount = newFromBalance
        uint256 product = balanceFrom * balanceTo;
        uint256 newFromBalance = balanceFrom + receivedAmount;
        uint256 newToBalance = product / newFromBalance;
        uint256 amountOut = balanceTo - newToBalance;

        // Charge fees
        uint256 feeAmount = (amountOut * liquidityFee) / ONE;
        newToBalance += feeAmount;
        amountOut -= feeAmount;

        // Remember liquidity increase for admin fees later
        uint256 liquidityBefore = geometricMean(balanceFrom, balanceTo);
        uint256 liquidityAfter = geometricMean(newFromBalance, newToBalance);
        uint256 liquidityIncrease = liquidityAfter - liquidityBefore;
        accruedLiquiditySinceLastClaim += liquidityIncrease;

        // Update balances
        if (fromUnderlyingB) {
            (newFromBalance, newToBalance) = (newToBalance, newFromBalance);
        }
        balanceA = newFromBalance;
        balanceB = newToBalance;

        // transfer amount out
        transferFundsOut(underlyingTo, amountOut);

        return amountOut;
    }

    // Note: Currently, you can add liquidity underlyingA, then remove liquidity of underlyingB to avoid trading fees
    function addLiquidity(uint256 amountA, uint256 amountB) external nonReentrant returns(uint256) {
        uint256 _balanceA = balanceA;
        uint256 _balanceB = balanceB;
        uint256 _totalSupply = totalSupply;

        // Transfer funds in
        uint256 amountAIn = amountA == 0 ? 0 : transferFundsIn(underlyingA, amountA);
        uint256 amountBIn = amountB == 0 ? 0 : transferFundsIn(underlyingB, amountB);

        // Calculate change in liquidity and totalSupply
        uint256 liquidityBefore = geometricMean(_balanceA, _balanceB);
        uint256 liquidityAfter = geometricMean(_balanceA + amountAIn, _balanceB + amountBIn);

        uint256 totalSupplyAfter;
        if (_totalSupply == 0) {
            totalSupplyAfter = liquidityAfter;
        } else {
            totalSupplyAfter = (_totalSupply * liquidityAfter) / liquidityBefore;
        }
        uint256 totalSupplyIncrease = totalSupplyAfter - _totalSupply;

        // Update balances
        balances[msg.sender] += totalSupplyIncrease;
        totalSupply = totalSupplyAfter;
        balanceA = _balanceA + amountAIn;
        balanceB = _balanceB + amountBIn;

        return totalSupplyIncrease;
    }

    // Note: Currently it's almost impossible to withdraw entire deposited funds
    function removeLiquidity(uint256 amountA, uint256 amountB) external nonReentrant returns(uint256) {
        uint256 _balanceA = balanceA;
        uint256 _balanceB = balanceB;
        uint256 _totalSupply = totalSupply;

        // Calculate change in liquidity and totalSupply
        uint256 liquidityBefore = geometricMean(_balanceA, _balanceB);
        uint256 liquidityAfter = geometricMean(_balanceA - amountA, _balanceB - amountB);

        uint256 totalSupplyAfter = (_totalSupply * liquidityAfter) / liquidityBefore;
        uint256 totalSupplyDecrease = _totalSupply - totalSupplyAfter;

        // Make sure sender has enough balance
        uint256 senderBalance = balances[msg.sender];
        require(senderBalance >= totalSupplyDecrease, "Not enough balance");

        // Update balances
        balances[msg.sender] = senderBalance - totalSupplyDecrease;
        totalSupply = totalSupplyAfter;
        balanceA = _balanceA - amountA;
        balanceB = _balanceB - amountB;

        // Transfer funds out
        if (amountA > 0) {
            transferFundsOut(underlyingA, amountA);
        }
        if (amountB > 0) {
            transferFundsOut(underlyingB, amountB);
        }
        
        return totalSupplyDecrease;
    }

    function getLiquidity() external view returns(uint256) {
        return geometricMean(balanceA, balanceB);
    }

    function transferFundsIn(ERC20 underlying, uint256 amount) internal returns(uint256) {
        uint256 balanceBefore = underlying.balanceOf(address(this));

        require(underlying.transferFrom(msg.sender, address(this), amount), "TransferFrom failed");

        uint256 balanceAfter = underlying.balanceOf(address(this));
        uint256 receivedAmount = balanceAfter - balanceBefore;

        return receivedAmount;
    }

    function transferFundsOut(ERC20 underlying, uint256 amount) internal {
        require(underlying.transfer(msg.sender, amount), "Transfer failed");
    }
    
    // +------------+
    // | Math stuff |
    // +------------+

    function geometricMean(uint256 x, uint256 y) internal pure returns(uint256) {
        return sqrt(x * y);
    }

    function sqrt(uint256 x) internal pure returns(uint256) {
        if (x == 0) return 0;

        // guess: 2^(log(x) / 2)
        uint256 guess = 1 << (approxLogBase2(x) >> 1);
        // 5 newton iterations because they're cheap
        // guess is provably always > 0
        guess = (guess * guess + x) / (2 * guess);
        guess = (guess * guess + x) / (2 * guess);
        guess = (guess * guess + x) / (2 * guess);
        guess = (guess * guess + x) / (2 * guess);
        guess = (guess * guess + x) / (2 * guess);
        return guess;
    }

    // sqrt(2) ≈ 886731088897/627013566048
    uint256 private constant sqrt2Numerator = 886731088897;
    uint256 private constant sqrt2Denominator = 627013566048;
    // Returns the whole number closest to the actual log base 2 of x
    function approxLogBase2(uint256 x) internal pure returns(uint256) {
        // log2(x * sqrt(2)) = log2(x) + 0.5, so truncating gives rounded value
        x = (x * sqrt2Numerator) / sqrt2Denominator;
        // highestBit is floor(log2(x))
        return highestBit(x);
    }

    // Returns the position of the highest set bit in x
    function highestBit(uint256 x) internal pure returns(uint256) {
        uint256 log = 0;
        while (0 != (x >>= 1)) {
            unchecked {
                // will never exceed 256, unchecked is fine
                log++;
            }
        }
        return log;
    }
}
