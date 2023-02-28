trigger CaseBeforeUpdateTrigger on Case (before update, after update) {

    Boolean requestSentToExternalSystem = false;
    Integer i=0;

    new CaseTriggerHandler().run();

}