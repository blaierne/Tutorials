methods{
    getTotalFeesEarnedPerShare() returns(uint) envfree
}

rule totalFeesEarnedPerShareIntegrity(method f){
    uint totalFeesEarnedPerShareBefore = getTotalFeesEarnedPerShare();
    env e;
    calldataarg args;
    f(e,args);
    uint totalFeesEarnedPerShareAfter= getTotalFeesEarnedPerShare();

    assert totalFeesEarnedPerShareBefore == totalFeesEarnedPerShareAfter;
}

