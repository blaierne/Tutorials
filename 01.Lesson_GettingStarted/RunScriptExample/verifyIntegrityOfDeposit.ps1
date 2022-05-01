$msg=$args[0]
certoraRun BankLesson1/Bank.sol:Bank --verify Bank:BankLesson1/IntegrityOfDeposit.spec --solc solc7.6 --rule integrityOfDeposit --msg "$msg"


