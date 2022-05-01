methods {
	getCurrentManager(uint256 fundId) returns (address) envfree
	getPendingManager(uint256 fundId) returns (address) envfree
	isActiveManager(address a) returns (bool) envfree
}



rule uniqueManagerAsRule(uint256 fundId1, uint256 fundId2, method f) {
	// assume different IDs
	require fundId1 != fundId2;
	// assume different managers
	require getCurrentManager(fundId1) != getCurrentManager(fundId2);
	
	// hint: add additional variables just to look at the current state

	bool activeFundsBeforeCall1 = isActiveManager(getCurrentManager(fundId1));			
	bool activeFundsBeforeCall2 = isActiveManager(getCurrentManager(fundId2));	
	address managerAddressBeforeCall1 = getCurrentManager(fundId1);
	address managerAddressBeforeCall2 = getCurrentManager(fundId2);

	env e;
	calldataarg args;
	f(e,args);
	
	bool activeFundsAfterCall1 = isActiveManager(getCurrentManager(fundId1));			
	bool activeFundsAfterCall2 = isActiveManager(getCurrentManager(fundId2));
	address managerAddressAfterCall1 = getCurrentManager(fundId1);
	address managerAddressAfterCall2 = getCurrentManager(fundId2);

	// verify that the managers are still different 
	assert getCurrentManager(fundId1) != getCurrentManager(fundId2), "managers not different";
}


// /* A version of uniqueManagerAsRule as an invariant */
// invariant uniqueManagerAsInvariant(uint256 fundId1, uint256 fundId2)
// 	fundId1 != fundId2 => getCurrentManager(fundId1) != getCurrentManager(fundId2) 
