 //******************************************************************
 //* IMPORTS/SETUP                                                  *
 //******************************************************************
//*   Recall: An `envfree` method is one that is -
//*   (1) non-payable (msg.value must be 0)
//*   (2) does not depend on any environment variable


methods{
    getTotalFeesEarnedPerShare() returns (uint) envfree
    assetsOf(address) returns (uint) envfree
    feesCollectedPerShareOf(address) returns(uint) envfree
    RewardsOf(address) returns (uint) envfree
    totalSupply() returns (uint) envfree
    balanceOf(address user) returns (uint) envfree
}



 //******************************************************************
// * USEFUL CONSTRUCTS.                                             *
 //******************************************************************
// advanced use for SMT speedup with ghosts - not needed here
// ....
// GHOSTS which are uninterpreted SMT functions, useful for describing contract state
// ....

ghost GhostFees (address) returns uint
{
  init_state axiom forall address user. GhostFees(user) == 0;
}

// a way to interact with state changes in the contract via storage
// reads and writes
// ....

hook Sstore accounts[KEY address user].(offset 0) uint256 new_feesCollected (uint256 old_feesCollected) STORAGE {
    havoc GhostFees assuming GhostFees@new(user) == GhostFees@old(user) + new_feesCollected - old_feesCollected;
}

// encapsulation of some commonly reused computation in CVL function declarations
// ....




//******************************************************************
// * THE ACTUAL SPEC                                        *
//******************************************************************
// rules

rule totalFeesEarnedPerShare_changes_correctly(method f){
    uint totalFeesEarnedPerShare_before = getTotalFeesEarnedPerShare();
    env e;
    calldataarg arg;
    f(e,arg);
    uint totalFeesEarnedPerShare_after = getTotalFeesEarnedPerShare();
    if (f.selector == OwnerDoItsJobAndEarnsFeesToItsClients().selector) {
        assert totalFeesEarnedPerShare_after == totalFeesEarnedPerShare_before +1;
    } else {
        assert totalFeesEarnedPerShare_after == totalFeesEarnedPerShare_before;
    }
}

rule rewards_is_never_negative(address user){
        assert RewardsOf(user) >= 0;
}

rule integrity_of_deposit(){
    env e;
    uint amount = e.msg.value;
    address user = e.msg.sender;
    address user2;

    uint total_supply_before = totalSupply();
    uint user_balance_before = balanceOf(user2);

    deposit(e);

    uint total_supply_after = totalSupply();
    uint user_balance_after = balanceOf(user2);
    
    if (user == user2){
        assert  total_supply_after ==  total_supply_before +amount, "total supply did not increase correctly";
        assert  user_balance_after ==  user_balance_before + amount, "user balance did not increase correctly";
    } else {
        assert  user_balance_after ==  user_balance_before , "user balance changed by another user";
    }
    //assert true;
}

rule integrity_of_withdraw(){
    env e;
    uint amount;
    address user = e.msg.sender;
    address user2;
    require(user != user2);

    uint total_supply_before = totalSupply();
    uint user_balance_before = balanceOf(user);
    uint user2_balance_before = balanceOf(user2);

    withdraw@withrevert(e,amount);
    bool withdraw_failed = lastReverted;

    assert amount > user_balance_before => withdraw_failed, " withdraw did not revert as it should while user withdrawing more funds then it has"; // Of course, withdraw can revert for other reasons...

    uint total_supply_after = totalSupply();
    uint user_balance_after = balanceOf(user);
    uint user2_balance_after = balanceOf(user2);

    if !withdraw_failed{
        assert  total_supply_after ==  total_supply_before -amount, "total supply did not decrease correctly";
        assert  user_balance_after ==  user_balance_before - amount, "user balance did not decrease correctly";
    }
    assert user2_balance_after ==  user2_balance_before, "the balance of another user was effected";
}

rule no_method_other_then_deposit_withdraw_transfer_transferFrom_changes_balance_or_total_supply(){
    env e;
    method f;
    require(f.selector != deposit().selector && 
            f.selector != withdraw(uint).selector && 
            f.selector != transfer(address,uint256).selector && 
            f.selector != transferFrom(address,address,uint256).selector
            );
    calldataarg arg;
    address user;
    uint total_supply_before = totalSupply();
    uint user_balance_before = balanceOf(user);

    f(e,arg);

    uint total_supply_after = totalSupply();
    uint user_balance_after = balanceOf(user);

    assert  total_supply_after ==  total_supply_before, "total supply was changed correctly";
    assert  user_balance_after ==  user_balance_before, "user balance was changed correctly";
}


// invariants

invariant fee_per_share_is_never_negative()
        forall address user. getTotalFeesEarnedPerShare() >= GhostFees(user)







