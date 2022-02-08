public class HierarchyWrapper {
    
    @AuraEnabled
    public String Name;
    @AuraEnabled
    public String ProductName;
    @AuraEnabled
    public String ProductCode;
    @AuraEnabled
    public String ProductFamily;
    @AuraEnabled
    public List < HierarchyWrapper > children;

}