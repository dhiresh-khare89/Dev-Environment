/*

CreatedBy :Rohitash Mourya
Create Date: 17-APR-2023
Last Modified Date: 17-APR-2023
Description:This class is used for updating created by name for system generated task's

*/
public class TaskTriggerHandler {
    public static void IsBeforeInsert(List<Task> taskList){
        try{
            user linkretaUser=[Select id,Name from User where Name='Linkreta GT' Limit 1];
            List<String> taskNameList=new List<string>();
            taskNameList.add('Enrichment of Segmentation Details of New Client');
            taskNameList.add('New Client Owner based on NSL discussion');
            taskNameList.add('NSL Discussion Pending');
            taskNameList.add('Next steps & actions discussed with NSL');
            taskNameList.add('Client Engagement');
            taskNameList.add('Client Take-On Preparation Deck');
            taskNameList.add('Client Council Takeaways');
            
            
            
            For(Task taskRecord:taskList){
                if(taskNameList.contains(taskRecord.Subject) && linkretaUser.Id!=''){
                    taskRecord.CreatedById=linkretaUser.Id;
                }
                
            }
        }catch(exception e){
            
        }
        
    }
    
}