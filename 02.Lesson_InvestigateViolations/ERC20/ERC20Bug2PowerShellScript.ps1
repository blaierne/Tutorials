#certoraRun 02.Lesson_InvestigateViolations/ERC20/ERC20Bug2.sol:ERC20 --verify ERC20:02.Lesson_InvestigateViolations/ERC20/ERC20.spec --solc solc8.2 --optimistic_loop
# => Failure in totalSupplyNotLessThanSingleUserBalance (because the rule is faulty) and in integrityOfTransfer
certoraRun 02.Lesson_InvestigateViolations/ERC20/ERC20Bug2.sol:ERC20 --verify ERC20:02.Lesson_InvestigateViolations/ERC20/ERC20.spec --solc solc8.2 --optimistic_loop --rule integrityOfTransfer
# Problem is integer underFlow