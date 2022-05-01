certoraRun 02.Lesson_InvestigateViolations/ERC20/ERC20Bug3.sol:ERC20 --verify ERC20:02.Lesson_InvestigateViolations/ERC20/ERC20.spec --solc solc8.2  --optimistic_loop
# Faled balanceChangesFromCertainFunctions with methods approve(address,uint256), decreaseAllowance(address,uint256), and increaseAllowance(address,uint256)
certoraRun 02.Lesson_InvestigateViolations/ERC20/ERC20Bug3.sol:ERC20 --verify ERC20:02.Lesson_InvestigateViolations/ERC20/ERC20.spec --solc solc8.2 --rule balanceChangesFromCertainFunctions --optimistic_loop
# Bug: 'function _approve' changes '_balances' for some reason
