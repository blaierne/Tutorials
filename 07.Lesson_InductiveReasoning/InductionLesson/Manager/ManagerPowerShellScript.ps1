# Run the original .spec script on the the original version
# certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/Manager.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/Manager.spec --solc solc8.2  --optimistic_loop

# Run the partial solution on the the original version
# certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/Manager.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerPartialSolution.spec --solc solc8.2  --optimistic_loop

# Run the partial solution on the two buggy versions provided
# certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerBug1.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerPartialSolutionFixed.spec --solc solc8.2  --optimistic_loop
# certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerBug2.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerPartialSolution.spec --solc solc8.2  --optimistic_loop

# Run the Invariant Version on versions of the Manager contract with bugs inserted
# certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerBug1.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerFixedInvariant.spec --solc solc8.2  --optimistic_loop
# certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerBug2.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerFixedInvariant.spec --solc solc8.2  --optimistic_loop

# Run the Fixed Version on the original and buggy versions of the Manager contract
# certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/Manager.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerFixed.spec --solc solc8.2  --optimistic_loop
# certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerBug1.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerFixed.spec --solc solc8.2  --optimistic_loop
# certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerBug2.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerFixed.spec --solc solc8.2  --optimistic_loop


# Run the partial solution on the two buggy version provided, only this time changing only pre-condition
certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerBug1.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerPartialSolutionCorrectThePreCondition.spec --solc solc8.2  --optimistic_loop
certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerBug2.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerPartialSolutionCorrectThePreCondition.spec --solc solc8.2  --optimistic_loop

# Run the partial solution on the two buggy version provided, only this time changing only pre-condition
certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerBug1.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerPartialSolutionCorrectThePostCondition.spec --solc solc8.2  --optimistic_loop
certoraRun 07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerBug2.sol:Manager --verify Manager:07.Lesson_InductiveReasoning/InductionLesson/Manager/ManagerPartialSolutionCorrectThePostCondition.spec --solc solc8.2  --optimistic_loop
