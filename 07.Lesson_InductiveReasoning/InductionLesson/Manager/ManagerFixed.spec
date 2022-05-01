methods {
	getCurrentManager(uint256 fundId) returns (address) envfree
	getPendingManager(uint256 fundId) returns (address) envfree
	isActiveManager(address a) returns (bool) envfree
}

definition zeroAddress() returns address = 0x0000000000000000000000000000000000000000;
rule uniqueManagerAsRule(uint256 fundId1, uint256 fundId2, method f) {

	// hint: add additional variables just to look at the current state

	bool fundIsActivelyManagedBeforeCall1 = isActiveManager(getCurrentManager(fundId1));			
	bool fundIsActivelyManagedBeforeCall2 = isActiveManager(getCurrentManager(fundId2));	
	address managerAddressBeforeCall1 = getCurrentManager(fundId1);
	address managerAddressBeforeCall2 = getCurrentManager(fundId2);
    bool isManagerAddressBeforeCallNotTheZeroAddress1 = managerAddressBeforeCall1 != zeroAddress();
    bool isManagerAddressBeforeCallNotTheZeroAddress2 = managerAddressBeforeCall2 != zeroAddress(); 
	// Check initial state is correct
	// assume different IDs
	require fundId1 != fundId2;
	// assume different managers
    require managerAddressBeforeCall1 != managerAddressBeforeCall2;
    // assume that if fund has a manager, we have set the 'isActiveManager' flag correctly
    require isManagerAddressBeforeCallNotTheZeroAddress1 <=> fundIsActivelyManagedBeforeCall1;
    require isManagerAddressBeforeCallNotTheZeroAddress2 <=> fundIsActivelyManagedBeforeCall2;

	env e;
	if (f.selector == claimManagement(uint256).selector)
	{
		uint256 id;
		require id == fundId1 || id == fundId2;
		claimManagement(e, id);  
	}
	else {
		calldataarg args;
		f(e,args);
	}

	bool fundIsActivelyManagedAfterCall1 = isActiveManager(getCurrentManager(fundId1));			
	bool fundIsActivelyManagedAfterCall2 = isActiveManager(getCurrentManager(fundId2));
	address managerAddressAfterCall1 = getCurrentManager(fundId1);
	address managerAddressAfterCall2 = getCurrentManager(fundId2);
    bool isManagerAddressAfterCallNotTheZeroAddress1 = managerAddressAfterCall1 != zeroAddress();
    bool isManagerAddressAfterCallNotTheZeroAddress2 = managerAddressAfterCall2 != zeroAddress(); 	

	// verify that the managers are still different 
	assert managerAddressAfterCall1 != managerAddressAfterCall2, "managers not different";
	// verify that if fund has a manager, we have set the 'isActiveManager' flag correctly
	assert isManagerAddressAfterCallNotTheZeroAddress1 <=> fundIsActivelyManagedAfterCall1, "isActiveManager Flag was set incorrectly";
	assert isManagerAddressAfterCallNotTheZeroAddress2 <=> fundIsActivelyManagedAfterCall2, "isActiveManager Flag was set incorrectly";	
}


// /* A version of uniqueManagerAsRule as an invariant */
// invariant uniqueManagerAsInvariant(uint256 fundId1, uint256 fundId2)
// 	fundId1 != fundId2 => getCurrentManager(fundId1) != getCurrentManager(fundId2) 
