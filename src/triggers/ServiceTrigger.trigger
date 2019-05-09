/* * Created by ociszek001 on 02.05.2019.*/

trigger ServiceTrigger on Service__c (after insert, after update, after delete) {
ServiceTriggerHandler handle = new ServiceTriggerHandler(trigger.new);

    if(Trigger.isAfter){
        if (trigger.isInsert) handle.afterInsert();
        if (trigger.isUpdate) handle.afterUpdate();
        if (trigger.isDelete) handle.afterDelete();
    }
}