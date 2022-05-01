#certoraRun 02.Lesson_InvestigateViolations/Borda/BordaBug2.sol:Borda --verify Borda:02.Lesson_InvestigateViolations/Borda/Borda.spec --solc solc7.6
# Only bug in rule onceBlackListedNotOut

#certoraRun 02.Lesson_InvestigateViolations/Borda/BordaBug2.sol:Borda --verify Borda:02.Lesson_InvestigateViolations/Borda/Borda.spec --solc solc7.6 --rule onceBlackListedNotOut
# Bug found - function registerVoter confused _contenders check with _votes check