import { LightningElement, wire, api, track } from 'lwc';
import fetchAccountAssetHierarchy from '@salesforce/apex/AccountAssetHierarchyController.fetchAccountAssetHierarchy'; 
export default class AccountAssetHeirarchy extends LightningElement {

    @api recordId; //use to store account id

    //this is use to show the all column in the table
    @track gridColumns = [{
        type: 'text',
        fieldName: 'Name',
        label: 'Name'
    },
    {
        type: 'text',
        fieldName: 'ProductName',
        label: 'Product'
    },{
        type: 'text',
        fieldName: 'ProductCode',
        label: 'Product Code'
    },{
        type: 'Picklist',
        fieldName: 'ProductFamily',
        label: 'Product Family'
    }];
    
    @track gridData; //this is use to show all the data
    
    @wire(fetchAccountAssetHierarchy, { accountId: '$recordId' })  
    AccountAssetRecords( { error, data } ) {  
  
        
        if ( data ) {  
            this.gridData = JSON.parse( JSON.stringify( data ).split( 'children' ).join( '_children' ) );
        } else if ( error ) {
            
        }
    } 

    //this method is use to handle Expand All functionality
    clickToExpandAll( e ) {
        const grid =  this.template.querySelector( 'lightning-tree-grid' );
        grid.expandAll();
    }

    //this method is use to handle Collapse All functionality
    clickToCollapseAll( e ) {
        const grid =  this.template.querySelector( 'lightning-tree-grid' );
        grid.collapseAll();
      
    }
}