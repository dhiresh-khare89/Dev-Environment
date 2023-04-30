public class ListViewButtonDemo {
    public List<Lead> opportunities{get;private set;}
    public ListViewButtonDemo(ApexPages.StandardSetController stdSetController){
        // Returns all selected records
        opportunities = (List<Lead>) stdSetController.getSelected();
    }
    
    public PageReference save(){
        // Some fancy stuff here.
        try{
         update opportunities;
        } catch(Exception e){
            System.debug('Exception: ' + e);
        }
        return null;
    }
}