#certoraRun 02.Lesson_InvestigateViolations/Borda/BordaBug3.sol:Borda --verify Borda:02.Lesson_InvestigateViolations/Borda/Borda.spec --solc solc7.6
# Only problem in rule contendersPointsNondecreasing with method vote(address,address,address)
certoraRun 02.Lesson_InvestigateViolations/Borda/BordaBug3.sol:Borda --verify Borda:02.Lesson_InvestigateViolations/Borda/Borda.spec --solc solc7.6 --rule contendersPointsNondecreasing
# Problem is integer overflow in voteTo
# Note that if we remove the ''require pointsBefore > 0 => registeredBefore;'' statement we get another method failing, namely registerContender because it can now 
# reduce the number of points a contenders has...