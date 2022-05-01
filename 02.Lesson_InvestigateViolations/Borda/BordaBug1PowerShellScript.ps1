#certoraRun 02.Lesson_InvestigateViolations/Borda/BordaBug1.sol:Borda --verify Borda:02.Lesson_InvestigateViolations/Borda/Borda.spec --solc solc7.6
# Only Found bug in correctPointsIncreaseToContenders

certoraRun 02.Lesson_InvestigateViolations/Borda/BordaBug1.sol:Borda --verify Borda:02.Lesson_InvestigateViolations/Borda/Borda.spec --solc solc7.6  --rule correctPointsIncreaseToContenders
# Added variables, found bug - vote function increases every choice by 3 points