# Run of the two buggy versions

# certoraRun 08.Lesson_WorkingWithInvariants/InvariantsConcepts/ReserveList/ReserveListBug1.sol:ReserveList --verify ReserveList:08.Lesson_WorkingWithInvariants/InvariantsConcepts/ReserveList/ReserveListSpec.spec --solc solc8.13  --short_output --optimistic_loop
# certoraRun 08.Lesson_WorkingWithInvariants/InvariantsConcepts/ReserveList/ReserveListBug2.sol:ReserveList --verify ReserveList:08.Lesson_WorkingWithInvariants/InvariantsConcepts/ReserveList/ReserveListSpec.spec --solc solc8.13  --short_output --optimistic_loop

# Run of the fixed version
certoraRun 08.Lesson_WorkingWithInvariants/InvariantsConcepts/ReserveList/ReserveListFixed.sol:ReserveList --verify ReserveList:08.Lesson_WorkingWithInvariants/InvariantsConcepts/ReserveList/ReserveListSpec.spec --solc solc8.13  --short_output --optimistic_loop 