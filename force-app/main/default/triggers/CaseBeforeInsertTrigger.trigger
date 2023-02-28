trigger CaseBeforeInsertTrigger on Case (before insert) {
    new CaseTriggerHandler().run();
}