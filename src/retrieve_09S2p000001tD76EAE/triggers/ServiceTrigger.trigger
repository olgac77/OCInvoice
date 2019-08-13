/* * Created by ociszek001 on 02.05.2019.*/

trigger ServiceTrigger on Service__c (after insert, after update, after delete, before insert, before update, before delete) {
ServiceTriggerHandler handle = new ServiceTriggerHandler(trigger.new, trigger.old);

    if(Trigger.isAfter){
        if (trigger.isInsert) handle.afterInsert();
        if (trigger.isUpdate) handle.afterUpdate();
        if (trigger.isDelete) handle.afterDelete();
    }
    if(Trigger.isBefore){
        if (trigger.isInsert) handle.beforeInsert();
        if (trigger.isUpdate) handle.beforeUpdate();
        if (trigger.isDelete) handle.beforeDelete();
    }
}