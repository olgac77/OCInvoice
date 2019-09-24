global class ReminderProcessorScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc){
        ReminderProcessor rp = new ReminderProcessor(); 
        database.executebatch(rp);
        
    }

}