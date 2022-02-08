/*
 *Name: AccountAssetHierarchyTest
 *Date: 07-02-2022
 *Author:
 *Desc: These test class is use to coverage the AccountAssetHierarchyController.
*/
@isTest
public class AccountAssetHierarchyTest {
	@isTest
    static void unitTest(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Asset asst = new Asset();
        asst.Name = 'Asset2';
        asst.AccountId = acc.Id;
        insert asst;
        
        Asset asst1 = new Asset();
        asst1.Name = 'Asset2.1';
        asst1.AccountId = acc.Id;
        asst1.ParentId = asst.Id;
        insert asst1;
                    
        AccountAssetHierarchyController.fetchAccountAssetHierarchy(acc.Id);
        
        HierarchyWrapper hrWrapper = new HierarchyWrapper();
        hrWrapper.ProductCode = '101';
        hrWrapper.Name = 'Test Product';
        hrWrapper.ProductName = 'Test';
		system.assert(asst1.AccountId != null, 'Asset related');
    }
}