# certoraRun 02.Lesson_InvestigateViolations/ERC20/ERC20Bug4.sol:ERC20 --verify ERC20:02.Lesson_InvestigateViolations/ERC20/ERC20.spec --solc solc8.2  --optimistic_loop
# Failure of three rules: integrityOfIncreaseAllowance, integrityOfTransferFrom, totalSupplyNotLessThanSingleUserBalance. 
# The third  is due to the rule being problematic. So we only deal with the first two. 

# certoraRun 02.Lesson_InvestigateViolations/ERC20/ERC20Bug4.sol:ERC20 --verify ERC20:02.Lesson_InvestigateViolations/ERC20/ERC20.spec --solc solc8.2  --optimistic_loop --rule integrityOfIncreaseAllowance
# There's a 9* in _approve that shouldn't be there

# certoraRun 02.Lesson_InvestigateViolations/ERC20/ERC20Bug4.sol:ERC20 --verify ERC20:02.Lesson_InvestigateViolations/ERC20/ERC20.spec --solc solc8.2  --optimistic_loop --rule integrityOfTransferFrom
# Same problem with _approve