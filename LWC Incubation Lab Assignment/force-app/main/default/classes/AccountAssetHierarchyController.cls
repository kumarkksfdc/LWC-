/*
 *Name: AccountAssetHierarchyController
 *Date: 07-02-2022
 *Author:
 *Desc: These class is use to show all the Asset Related with the Account.
*/
public with sharing class AccountAssetHierarchyController {
    //These method is use to fetch all the asset realted to the account.
	@AuraEnabled(cacheable=true)
    public static List < HierarchyWrapper > fetchAccountAssetHierarchy( String accountId ) {
        try{
            List < HierarchyWrapper > listWrap = new List < HierarchyWrapper >();
            List<Asset> currentAsset = [ SELECT Id, RootAssetId FROM Asset WHERE AccountId =: accountId ];
            Set<Id> rootAssetIds = new Set<Id>();
            for(Asset ast : currentAsset) {//todo soql for loop
                if(ast.RootAssetId != null) {//todo  use isnotblank 
                    rootAssetIds.add(ast.RootAssetId);
                }
            }
            List < Asset > listAssets = new List < Asset >();
            if(!rootAssetIds.isEmpty()) {
                listAssets = [ SELECT Id, Name, Product2.Name,ProductFamily,ProductCode, ParentId FROM Asset WHERE RootAssetId IN : rootAssetIds ORDER BY ParentId NULLS FIRST ];
            }
            for(Asset rootAsset : [ SELECT Id, RootAssetId, Name, Product2.Name,ProductFamily,ProductCode FROM Asset WHERE Id IN : rootAssetIds ]) {
                HierarchyWrapper rootAssetWrap = new HierarchyWrapper();
                rootAssetWrap.Name = rootAsset.Name;
                rootAssetWrap.ProductName = rootAsset.Product2.Name;
                rootAssetWrap.ProductCode = rootAsset.ProductCode;
                rootAssetWrap.ProductFamily = rootAsset.ProductFamily;
                rootAssetWrap.children = findRelations( listAssets, rootAsset.RootAssetId );
                listWrap.add( rootAssetWrap );
            }
            return listWrap;
        }catch(Exception ex){
           //System.debug('Éxception Occured : '+ex.getMessage());
        }
        return null;
    }
    //These method is use to find the child realtions between the Asset it self.
    public static List < HierarchyWrapper > findRelations( List < Asset > listAssets, Id rootAssetId ) {
        try{
        List < HierarchyWrapper > listWrap = new List < HierarchyWrapper >();
        for ( Asset objAsset : listAssets ) {
            if ( objAsset.ParentId == rootAssetId ) {
                HierarchyWrapper wrap = new HierarchyWrapper();
                wrap.Name = objAsset.Name;
                wrap.ProductName = objAsset.Product2.Name;
                wrap.ProductCode = objAsset.ProductCode;
                wrap.ProductFamily = objAsset.ProductFamily;
                wrap.children = findRelations( listAssets, objAsset.Id );
                listWrap.add( wrap );
            }
        }
        if ( !listWrap.isEmpty() )
            return listWrap;
        else 
            return null;
        }catch(Exception ex){
            //System.debug('Éxception Occured : '+ex.getMessage());
        }
        return null;
    }
}