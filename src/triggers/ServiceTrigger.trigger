/**
 * Created by ociszek001 on 02.05.2019.
 */

trigger ServiceTrigger on Service__c (after insert, after update, after delete) {
    for(Service__c service : Trigger.New){

    }
}