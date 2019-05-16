/**
 * Created by ociszek001 on 15.05.2019.
 */

trigger ContentTrigger on ContentDocumentLink (before insert) {
    ContentTriggerHandler handle = new ContentTriggerHandler(trigger.new);

    if(Trigger.isBefore){
        if(Trigger.isInsert)handle.beforeInsert();
    }
}