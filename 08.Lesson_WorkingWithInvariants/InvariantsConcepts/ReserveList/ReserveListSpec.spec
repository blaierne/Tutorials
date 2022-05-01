methods{
    getTokenAtIndex(uint256 index) returns (address) envfree;
    getIdOfToken(address token) returns (uint256) envfree;
    getReserveCount() returns (uint256) envfree;
    addReserve(address token, address stableToken, address varToken, uint256 fee) returns();
    removeReserve(address token) returns();
}


// Property: Both lists are correlated - If we use the id of a token in reserves to retrieve a token in underlyingList, we get the same token.

// invariant BothListsAreCorrelated1(address token, uint256 index)
  //  (index !=0 && token != 0) => ((getIdOfToken(token) == index) <=> (token == getTokenAtIndex(index)))

//invariant BothListsAreCorrelated2(address token)
 //   (getTokenAtIndex(0) == token) => (getIdOfToken(token) == 0)


//  Property: Id of assets is injective (i.e. different tokens should have distinct ids).
//invariant IdOfAssetsIsInjective(address token1, address token2)
  //  (token1 != token2) <=> (getIdOfToken(token1) != getIdOfToken(token2))


// Property:  Each non-view function changes reservesCount by +1 or -1.
// Property:  Every view function does not change reservesCount.

rule reservesCount_ChangesCorrectly(method f){
   uint256 ReserveCountBefore = getReserveCount();
    bool NonViewFunctionFlag = (f.selector == addReserve(address, address, address, uint256).selector || f.selector == removeReserve(address).selector);

    env e;
    calldataarg args;
    f(e,args);

    uint256 ReserveCountAfter = getReserveCount();

    if f.selector == addReserve(address, address, address, uint256).selector {
        assert ReserveCountAfter == ReserveCountBefore +1;
    } 
    else if f.selector == removeReserve(address).selector {
        assert ReserveCountAfter  == ReserveCountBefore - 1;
    } 
    else
    {
        assert ReserveCountAfter == ReserveCountBefore;
    }
}




