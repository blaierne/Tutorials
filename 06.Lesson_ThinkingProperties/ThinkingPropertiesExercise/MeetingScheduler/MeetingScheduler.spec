methods{
    getStateById(uint256 meetingId) returns (uint8) envfree;
    getStartTimeById(uint256 meetingId) returns (uint256) envfree;
    getEndTimeById(uint256 meetingId) returns (uint256) envfree;
    getNumOfParticipents(uint256 meetingId) returns (uint256) envfree;
}


rule StateTransition_from_UNINITIALIZED(method f, uint256 meetingId){

    uint8 MeetingStateBefore = getStateById(meetingId);
    bool MethodIsScheduleMeeting = (f.selector == scheduleMeeting(uint256,uint256,uint256).selector);
    require(MeetingStateBefore == 0);

    env e;
    calldataarg args;
    f(e,args);

    uint8 MeetingStateAfter = getStateById(meetingId);
    assert(MeetingStateAfter == 0 || MeetingStateAfter == 1,"An UNINITIALIZED Meeting transitioned to a state which is not {UNINITIALIZED,PENDING}");
    assert(MeetingStateAfter == 1 => MethodIsScheduleMeeting,"An UNINITIALIZED Meeting transitioned to a PENDING Meeting via a method which is not scheduleMeeting");
}

rule StateTransition_from_PENDING(method f, uint256 meetingId){

    uint8 MeetingStateBefore = getStateById(meetingId);
    bool MethodIsStartMeeting = (f.selector == startMeeting(uint256).selector);
    bool MethodIsCancelMeeting = (f.selector == cancelMeeting(uint256).selector);
    require(MeetingStateBefore == 1);

    env e;
    calldataarg args;
    f(e,args);

    uint8 MeetingStateAfter = getStateById(meetingId);
    assert(MeetingStateAfter == 1 || MeetingStateAfter == 2 || MeetingStateAfter == 4,"A PENDING Meeting transitioned to a state which is not {PENDING,STARTED,CANCELLED}");
    assert(MeetingStateAfter == 2 => MethodIsStartMeeting,"A PENDING Meeting transitioned to a STARTED Meeting via a method which is not startMeeting");
    assert(MeetingStateAfter == 4 => MethodIsCancelMeeting,"A PENDING Meeting transitioned to a CANCELLED Meeting via a method which is not cancelMeeting");
}

rule UnitTest_scheduleMeeting_MeetingId(uint256 meetingId1, uint256 meetingId2, uint256 arbitraryStartTime, uint256 arbitraryEndTime){
    env e;
    uint8 MeetingStateBefore = getStateById(meetingId1);
    require(MeetingStateBefore == 0);
    require(meetingId1 != meetingId2);
    scheduleMeeting(e,meetingId2,arbitraryStartTime,arbitraryEndTime);

    uint8 MeetingStateAfter = getStateById(meetingId1);
    assert(MeetingStateAfter == 0,"An UNINITIALIZED Meeting transitioned to a PENDING Meeting via scheduleMeeting with a different MeetingID");
}

rule UnitTest_scheduleMeeting_timestamp(uint256 meetingId, uint256 arbitraryStartTime, uint256 arbitraryEndTime){
    env e;
    uint8 MeetingStateBefore = getStateById(meetingId);
    require(MeetingStateBefore == 0);

    scheduleMeeting(e,meetingId,arbitraryStartTime,arbitraryEndTime);

    uint8 MeetingStateAfter = getStateById(meetingId);
    assert(MeetingStateAfter == 1 => e.block.timestamp <= arbitraryStartTime,"An UNINITIALIZED Meeting transitioned to a PENDING Meeting which starts at the past");
    assert(MeetingStateAfter == 1 => arbitraryStartTime <= arbitraryEndTime, "An UNINITIALIZED Meeting transitioned to a PENDING Meeting with illegal time"); 
}






   // uint256 arbitraryStartTime;
   // uint256 arbitraryMeetingId;
   // uint256 arbitraryEndTime;
   // bool isMethodScheduleMeeting = (f.selector == scheduleMeeting(uint256,uint256,uint256).selector);

   // MeetingStateBefore = getStateById(meetingId);
   // require(MeetingStateBefore == 0);
   // if isMethodScheduleMeeting
   // {
    //    scheduleMeeting(arbitraryMeetingId,arbitraryStartTime,arbitraryEndTime);
    //} 
   // else
   // {
    //    calldataarg arg;
    //    f(e,args);
    //}
    //MeetingStateAfter = getStateById(meetingId);
    //assert(MeetingStateAfter == 0 || MeetingStateAfter == 1,"An UNINITIALIZED Meeting transitioned to a state which is not {UNINITIALIZED,PENDING}");
    //assert(MeetingStateAfter == 1 => isMethodScheduleMeeting ,"An UNINITIALIZED Meeting transitioned to a PENDING Meeting by calling a method other then scheduleMeeting");
    //assert((MeetingStateAfter == 1 && isMethodScheduleMeeting) => (arbitraryMeetingId == meetingId),"An UNINITIALIZED Meeting transitioned to a PENDING Meeting by calling a scheduleMeeting on another MeetingID");
    
  // EDIT: ThAll these rules are covered by previous rule
  //  assert(MeetingStateAfter == 1 => meetingId != zeroAddress, "An UNINITIALIZED Meeting transitioned to a PENDING Meeting with an illegal address"); 
  //  assert(MeetingStateAfter == 1 => 0<arbitraryStartTime, "An UNINITIALIZED Meeting transitioned to a PENDING Meeting with illegal time"); 
  //  assert(MeetingStateAfter == 1 => arbitraryStartTime <= arbitraryEndTime, "An UNINITIALIZED Meeting transitioned to a PENDING Meeting with illegal time"); 
    //assert(MeetingStateAfter == 1 => e.block.timestamp <= arbitraryStartTime,"An UNINITIALIZED Meeting transitioned to a PENDING Meeting which starts at the past");



