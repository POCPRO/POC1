/*
# Created by............: CSS
# Created Date..........: 5/17/2013 
# Last Modified by......: CSS
# Last Modified Date....: 8/30/2013
   
    Case VF Page
    Based on the contact details page should be loaded
    This class is used for Case Create, Edit, View, Clone, Save,Reopen, View Response and Cancel
*/
public with sharing class PNcCase {
    
    public boolean surveyResponseFlag {get;set;}
    public contact contactObj {get;set;} 
    public case caseObj {get;set;}
    public User loggedInUser{get;set;}
    public string viewResponseURL {get;set;}
    public string printCaseURL {get;set;}    
    public string activeURL {get;set;}
    public string inActiveURL {get;set;}
   // public case getcaseObj(){return caseObj;}
    public  string selectedasset {get;set;}
    public string serviceContractList {get;set;}
    list <ContractLineItem> contractlineItemList;
    public List<Asset> lstAsset{get;set;}
    public List<ServiceContract> lstServiceContract{get;set;}
    public List<SelectOption> lstSecOpt{get;set;}
    id accountId;
    public boolean serviceContractFlag ;
    public String selectedSerCot{get;set;}
    public boolean entitlementflag{get;set;}
    map <id,string> serviceContractStatus = new map <ID,string> ();
    public boolean showSpecialInstructionPane {get; set;}
    public string changeUrl {get;set;}
    public boolean queueFlag {get;set;}
    public String BaseURL ;
    public boolean intialEntitlementflag {get;set;}
    public boolean caseStatusFlag {get;set;}
    public boolean saveFlag {get;set;}

    public string currentuser {get;set;}
    public string caseowner {get;set;}
    id caseID;      
    case caserec;
    public  Contact partnerContact {get;set;}
    MAp <string,id> servicecontract = new map <string,id> ();
    Boolean editflag;
    string caseAction;
    string closeStatusValue ;
    string openCaseStatusValue;
    public boolean cloneflag {get;set;}
    public boolean isRequired{get;set;}
    public string getcloseStatusValue ()
    {
        return closeStatusValue;
    }
    public void setcloseStatusValue (string testing)
    {
        this.closeStatusValue = testing;
    }
    public string getopenCaseStatusValue()
    {
        return openCaseStatusValue;
    }
    public void setopenCaseStatusValue(string opencasestatus)
    {
        this.openCaseStatusValue = opencasestatus;
    }
    public List<SelectOption> getStatus() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Closed','Closed'));
        return options;
    }
    public List<SelectOption> getOpenCaseStatus() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Open','Open'));
        options.add(new SelectOption('In Progress','In Progress'));
        options.add(new SelectOption('Pending','Pending'));
        options.add(new SelectOption('Monitoring','Monitoring'));
        options.add(new SelectOption('Closed','Closed'));
        return options;
    }
    
    
   public PNcCase(ApexPages.StandardController  controller)  
   {
        try{
            loggedInUser = [Select Username, UserType, UserRoleId,  UserPermissionsKnowledgeUser From User Where id = : UserInfo.getUserId()];
            serviceContractList = null;
            isRequired = true;
           system.debug('---constructor--');
            //intialEntitlementflag = false;
            caseObj = new case();
            surveyResponseFlag = false;
            caseAction ='';
            caseStatusFlag = false;
            saveFlag = true;
            editflag = false;
        cloneflag = false;
        showSpecialInstructionPane =false;
        queueFlag = false;
        BaseURL =  URL.getSalesforceBaseUrl().toExternalForm() ;
        activeURL = BaseURL+'img/entitlement/active_entitlement_status.png';
        inActiveURL = BaseURL+'img/entitlement/expired_entitlement_status.png';
        caserec = (case)controller.getRecord();
        
        caseID =caserec.id;             
        caseAction  = ApexPages.currentPage().getParameters().get('action');
        
        // Clone Case Action
        if(caseAction == 'clone'){
            System.debug('Called the clone action');
            Case cloneCaseVal = [Select isRMA__c, Why_Calling__c, Type, SuppliedPhone, SuppliedName, SuppliedEmail, SuppliedCompany, Subject, Sub_Status__c, Status, Site__c, Severity__c, Service_Contract__c, Same_Day_Closure__c, Resolution_Code__c, Regression__c, RecordTypeId, Reason, RMA__c, RMA_Count__c, RCA_Required__c, ProductId, Priority, Partner_Owns_Case__c, Partner_Contact__c, Partner_Case__c, Partner_Account__c, ParentId, Origin, OS_Version__c, OS_Build__c, Next_Action__c,  KB_Article_Status__c, IsVisibleInSelfService, IsDeleted, IsClosed, Id, Hot_Case__c, HasSelfServiceComments, HasCommentsUnreadByOwner, H_W_Platform__c, H_W_Component__c, GeoZone__c, EntitlementId, Description, Critical_Acct_Desc__c, ContactId, Commit_Date__c, Category_2__c, Category_1__c, Case_Accepted_By__c, BusinessHoursId, Bug__c, Bug_Status__c, AssetId, AccountId From Case Where id =: caserec.id];
            
            caseObj = new Case();
            caseObj.ContactId = cloneCaseVal.ContactId;
            loadContactDetails();
            caseObj.GeoZone__c = cloneCaseVal.GeoZone__c;
            system.debug('---case object-------'+caseObj.GeoZone__c);
            caseObj.AssetId = cloneCaseVal.AssetId;
            //caseObj.Bug__c = cloneCaseVal.Bug__c;
            //caseObj.Bug_Status__c = cloneCaseVal.Bug_Status__c;
            //caseObj.BusinessHoursId = cloneCaseVal.BusinessHoursId;
            //caseObj.Case_Accepted_By__c = cloneCaseVal.Case_Accepted_By__c;
            caseObj.Why_Calling__c = cloneCaseVal.Why_Calling__c;
            caseObj.Category_1__c = cloneCaseVal.Category_1__c;
            caseObj.Category_2__c = cloneCaseVal.Category_2__c;
            caseObj.H_W_Platform__c = cloneCaseVal.H_W_Platform__c;
            caseObj.H_W_Component__c = cloneCaseVal.H_W_Component__c;
            caseObj.Status = 'Open';
            //caseObj.Sub_Status__c = cloneCaseVal.Sub_Status__c;
            caseObj.Subject = cloneCaseVal.Subject;
            caseObj.Severity__c = cloneCaseVal.Severity__c;
            caseObj.Priority = cloneCaseVal.Priority;
            caseObj.OS_Build__c = cloneCaseVal.OS_Build__c;
            caseObj.OS_Version__c = cloneCaseVal.OS_Version__c;
            caseObj.Origin = cloneCaseVal.Origin;
            caseObj.Partner_Owns_Case__c = cloneCaseVal.Partner_Owns_Case__c;
            caseObj.Partner_Account__c = cloneCaseVal.Partner_Account__c;
            caseObj.Partner_Contact__c= cloneCaseVal.Partner_Contact__c;
            caseObj.Partner_Case__c = cloneCaseVal.Partner_Case__c;
            serviceContractList = cloneCaseVal.Service_Contract__c;
            selectedasset = cloneCaseVal.AssetId;
            selectedSerCot = cloneCaseVal.Service_Contract__c;
            getLoadAssets();
            //Partner_Owns_Case__c
            //ParentId
            //caseObj.Partner_Contact__c = cloneCaseVal.Partner_Contact__c;
            //loadPartnerAccount();
             editflag = true;
             system.debug('-------clone--');
           viewclone(); 
           //checkRequired();
           return; 
        }else{           
            caseObj = caserec;     
        }
    
        if(caseID == null){
            caseObj = new case();
            serviceContractFlag = false;
            entitlementflag = false;
        }else
        {
            
           viewResponse();
            case editCase = [select id,contactId,status from case where id = :caseObj.ID];
            if(editcase.status == 'closed')
            {
                caseStatusFlag = true;
            }
            else
            {
                caseStatusFlag = false;
            }
            if(caseAction == 'Edit' || caseAction == 'view' || caseAction=='Print')
            {               
                editflag = true;
                caseObj = editcase;
                
                loadContactDetails();
                system.debug('-----------load contact details '+caseObj);
                //loadPartnerAccount();
               
               system.debug('------------edit flag--'+editflag);
            }
            
            // Case View
            // Check whether the case belongs to queue or not 
        
            Map<id,id> queueMap =new map <id,id>();
            for(QueueSobject queueObj:[select QueueId,id from QueueSobject where SobjectType = 'Case'])
            {
                queueMap.put(queueObj.QueueId,queueObj.id);
            }
                        
            changeUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/'+caseID+'/a?retURL='+caseID;
            caseObj = [Select  c.isRMA__c, c.css_csat_v1_0__Survey_Sent_Date__c, c.css_csat_v1_0__Survey_Received_Date__c, c.css_csat_v1_0__Set_Parameter_ID__c, 
                            c.css_csat_v1_0__Reason__c, c.css_csat_v1_0__Is_Survey_Mail_Sent__c, c.css_csat_v1_0__Custom_Closed_Date__c,
                             c.css_csat_v1_0__Category__c, c.css_csat_v1_0__Bug_ID__c, c.css_csat_v1_0__Area__c,c.Why_Calling__c, c.Type, c.SystemModstamp, 
                                c.SuppliedPhone, c.SuppliedName, c.SuppliedEmail, c.SuppliedCompany, c.Subject, c.Sub_Status__c, c.Status, c.Site__c, c.Severity__c, c.Service_Contract__c,
                                c.Same_Day_Closure__c, c.Resolution_Code__c, c.Regression__c, c.RecordTypeId, c.Reason, c.RMA__c, c.RMA_Count__c, 
                                c.RCA_Required__c, c.ProductId, c.Priority, c.Partner_Owns_Case__c, c.Partner_Contact__c, c.Partner_Case__c, 
                                c.Partner_Account__c, c.ParentId, c.OwnerId,c.Owner.name, c.Origin, c.OS_Version__c, c.OS_Build__c, c.Next_Action__c, 
                                c.LastModifiedDate, c.LastModifiedById, c.KB_Article_Status__c, c.IsVisibleInSelfService, c.IsDeleted, c.IsClosed, 
                                c.Id, c.Hot_Case__c, c.HasSelfServiceComments, c.HasCommentsUnreadByOwner, c.H_W_Platform__c, c.H_W_Component__c, 
                                c.GeoZone__c, c.EntitlementId,c.Entitlement.name, c.Description, c.Days_Open__c, c.Days_Count__c, c.Critical_Acct_Desc__c,
                                 c.CreatedDate, c.CreatedById, c.ContactId, c.Commit_Date__c, c.ClosedDate, c.Category_2__c, c.Category_1__c,  
                                 c.Case_Accepted_By__c, c.CaseNumber, c.BusinessHoursId, c.Bug__c, c.Bug_Status__c, c.AssetId, c.AccountId,c.contact.phone,
                                 c.contact.email,c.Service_Contract__r.name From Case c   where id=:caseID];
                                 system.debug('------'+caseObj);
            
             system.debug('-----'+caseObj);
             if(caseAction == 'edit'){
                    selectedasset = caseObj.assetId;
                    serviceContractList = caseObj.Service_Contract__c;
                    getLoadAssets();
             }
             
            system.debug('--------selected assert'+selectedasset);
               //serviceContractList =caseObj.Service_Contract__c;
               
              //contactObj.site__r.GeoZone__c = caseObj.GeoZone__c;
               system.debug(selectedSerCot+'-------contract---'+serviceContractList);
           
            if(queueMap.containsKey(caseObj.OwnerId))
            {
                    
                 queueFlag = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please accept the case by clicking \'Accept Case\' button above to grab the case.');
                ApexPages.addMessage(myMsg);
                queueViewCasePage();
                return;
            }
            else
            {
                queueFlag = false;
            }
            system.debug('*****'+caseObj.contactid);
            if(caseObj.contactid != null){
            contactObj = [select lastName,firstName,MobilePhone,phone,DoNotCall,account.id,Account.name,Account.GeoZone__c,site__r.GeoZone__c,site__r.name,Account.Special_Instructions__c, Account.Type from contact 
                            where id = :caseObj.contactid];
                            system.debug('--------'+contactObj);
                            
                            if(contactObj.Account.Special_Instructions__c != null)
                            {
                                 showSpecialInstructionPane = true;
                            }
                            else
                            {
                                 showSpecialInstructionPane = false;
                            }
            }
            checkRequired();
            
        }
        loadPartnerAccount();
           system.debug('--------casei'+viewResponseURL);
            //value from customsettings for CSAT url
            List<CSATURL__c> csat = CSATURL__c.getall().values();
            String csatUrl = URL.getSalesforceBaseUrl().toExternalForm();
            if(csat != null && csat.size() >0 ){
                csatUrl = csat[0].surveyResponseURL__c;
            }        
            
            viewResponseURL = csatUrl +'/apex/caseViewResponse?id='+caseID;
           // viewResponseURL = 'https://css-csat-v1-0.cs15.visual.force.com/apex/caseViewResponse?id='+caseID;
            printCaseURL = BaseURL+'/apex/PNvViewCase_Print?id='+caseID+'&action=print';
        }
        catch (exception ex)
        {
           // system.debug(ex.getcause());
            
        }
        //loadContactDetails();         
   }
    
    public PageReference  viewclone()
    {
    
         system.debug('--------testing the codwe----');
          PageReference clonePage = new PageReference(BaseURL+'/apex/PNvCase?id='+caseObj.id+'&action=clone');
             clonePage.setRedirect(true); 
             return clonePage;
    }
  /* public void setcaseObj(case caseObject)
    {
        this.caseObj = caseObject;
    } */
    
    // Load Contact Details
    public void loadContactDetails()
    {   
        try
        {
                
            serviceContractList = null;
            lstSecOpt = new List<SelectOption>();
            system.debug('---------CONTACT--*****-'+caseObj.contactid);
            contactObj = [select lastName,firstName,MobilePhone,phone,donotcall,account.id,Account.name,Account.GeoZone__c,site__r.GeoZone__c,site__r.name,Account.Special_Instructions__c, Account.Type from contact where id = :caseObj.contactid];
            system.debug('---show -------'+contactObj.Account.Special_Instructions__c);
            caseObj.Site__c = contactObj.Site__c;
            caseObj.AccountId = contactObj.AccountId;            
            if(caseAction == 'clone'){            
                cloneflag = true;
            }
            else
            {
                caseObj.GeoZone__c = contactObj.site__r.GeoZone__c;
                cloneflag = false;
            }
            system.debug('-----clone flag '+cloneflag);
            
            
            system.debug(caseObj.site__r.GeoZone__c +'----------'+contactObj.site__r.GeoZone__c);
            if(contactObj.Account.Special_Instructions__c != null)
            {               
                showSpecialInstructionPane = true;
             }
             else
             {
                showSpecialInstructionPane = false;
             }
            system.debug('----------panel --'+showSpecialInstructionPane);
            accountId = contactObj.account.id;
            lstServiceContract = new List<ServiceContract>();
            lstServiceContract = [Select id, Name, Sales_Order__c, AccountId From ServiceContract Where AccountId=:accountId];
            list<ContractLineItem> activeServiceContractList =[ Select AssetId,Asset.name,ServiceContractID,ServiceContract.name From ContractLineItem where  AssetId!= null and ServiceContract.accountId =:accountId];
           // list<ServiceContract> activeServiceContractList = [Select Name,status From ServiceContract  where  AccountId = :accountId and status='active'];
            if(lstServiceContract.size() == 0)
            {
                saveFlag = false;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'There is no service contract available for the chosen customer');
                ApexPages.addMessage(myMsg);
                return ;
            }
            else
            {
                    saveFlag = true;
            }
            
            
            
            list<ServiceContract> serviceContactList = [Select Name, status From ServiceContract  where  AccountId = :accountId];
            for(ServiceContract sc:serviceContactList){
                serviceContractStatus.put(sc.id,sc.status);}
            system.debug('-------line items '+serviceContactList);
            contractlineItemList =[ Select AssetId,Asset.name,Asset.SerialNumber,ServiceContractID,ServiceContract.name From ContractLineItem where ServiceContractID IN :serviceContactList and AssetId!= null and ServiceContract.accountId =:accountId];
           
            system.debug('---------'+accountId);
            if(caseAction != 'Edit' && caseAction != 'Print' && caseAction != 'clone'){
                caseObj.Status = 'Open';
                caseObj.Priority = '<SET>';
                caseObj.Hot_Case__c = 'No';
                caseObj.Site__c = contactObj.Site__c; 
                caseObj.Origin = 'Manual'; 
            }
            getLoadAssets();
                        
        }
        catch (exception ex)
        {
            system.debug(ex.getcause());
        }
        
        
        //return null;
    }
    
    public List<SelectOption> getcontractLineItemList()
    {
            list<SelectOption> options = new List<SelectOption>();
            map <id,string> assetMap = new map <id,string> ();
        try
        {           
            if(contractlineItemList.size() > 0){
                for(ContractLineItem contractline:contractlineItemList)
                {
                    system.debug('-********------'+contractline.assetId+'----------'+contractline.asset.name);
                    if(!assetmap.containsKey(contractline.assetId))
                    {
                        assetMap.put(contractline.assetId,contractline.asset.name);
                    }
                
                    //options.add(new SelectOption(contractline.AssetId,contractline.asset.name));    
                }
                
                //ADDED THE CODE TO AVOID THE DUPLICATION
                for(id assetId:assetMap.keyset())
                {
                    options.add(new SelectOption(assetId,assetMap.get(assetId)));    
                }
                serviceContractFlag = true;
            
            }
            system.debug('-----ASSET MAP --'+assetMap);
        }
        catch (exception ex)
        {
            system.debug(ex.getcause());
            
        }
        system.debug('----------OPTIONS --'+options);
        return options;
    }
    public void test()
    {
            system.debug('-------asset '+selectedasset);
    }
    
    public pagereference verifyEntitlementStatus()
    {
        
        id servicecontractId = serviceContractList;
        if(serviceContractStatus.get(servicecontractId) == 'active'){
            entitlementflag = true;
        }
        else
        {
            entitlementflag = false;
        }
        system.debug('------flag------'+entitlementflag);
        return null;
    }
   
    public List<SelectOption> getServiceContractLineItemList()
    {
        
        list<SelectOption> options = new List<SelectOption>();      
        try
        {        //Select c.ServiceContractId, c.AssetId,c.ServiceContract.name From ContractLineItem c where c.AssetId ='02ie0000000Ka31'               
                //system.debug('---account id'+accountId+'----------'+selectedasset);
               //if(selectedasset == null){
               
               //     selectedasset =contractlineItemList[0].assetid;
               //     system.debug('--------line 241  '+selectedasset+'----acc');
               //}
               
                //if(selectedasset != null){
                lstServiceContract = new List<ServiceContract>();
                lstServiceContract = [Select id, Name, Sales_Order__c, AccountId From ServiceContract Where AccountId=:accountId];
                    for(ServiceContract serviceCont:lstServiceContract){
                        system.debug('--------'+serviceCont.Id+'----------'+serviceCont.Name);
                        options.add(new SelectOption(serviceCont.Id,serviceCont.Name)); 
                        servicecontract.put(serviceCont.Name,serviceCont.Id); 
                    }                       
                //}           
        }
        catch (exception ex)
        {
            system.debug(ex.getcause());
        }
        return options;
    }
    public void loadGeoZone(){
        if(caseObj.site__c != null){
            account acc = [select GeoZone__c from account where id =:caseObj.site__c];
            caseObj.GeoZone__c = acc.GeoZone__c;
        }
    }


    // Case ViewResponse Action
  public void viewResponse()
  {

     String URL;
 PageReference surveyResponsePage;   
        currentuser  = Userinfo.getUserId(); 
        case caseobjRec = [Select OwnerId, Id From Case Where Id =: caseID];
        List<ViewResponsePermission__c> vRes = ViewResponsePermission__c.getall().values();
        List<String> lstGroupName = new List<String>();
        if(vRes != null && vRes.size() > 0){
            String groupNames = vRes[0].Public_Group_Names__c;
            System.debug('groupNames ::: '+groupNames);
            
            if(groupNames != null && groupNames != ''){
                String[] strGrpNm = groupNames.split(',');
                System.debug('strGrpNm ::: '+strGrpNm);
                if(strGrpNm != null && strGrpNm.size() > 0){
                    for(String gpN : strGrpNm){
                        lstGroupName.add(gpN);
                    }
                }
            }
        }
        List<GroupMember> lstPublicGroupMember = [SELECT GroupId, Id, UserOrGroupId FROM GroupMember where Group.Name IN: lstGroupName];
        System.debug('lstPublicGroupMember ::: '+lstPublicGroupMember);
        Set<Id> groupMemberIdSet = new Set<Id>();
        if(lstPublicGroupMember != null && lstPublicGroupMember.size() >0){
            for(GroupMember grpm : lstPublicGroupMember){
                if(!groupMemberIdSet.contains(grpm.UserOrGroupId)){
                    groupMemberIdSet.add(grpm.UserOrGroupId);
                }
            }
        }
        if(!groupMemberIdSet.contains(caseobjRec.OwnerId)){
            groupMemberIdSet.add(caseobjRec.OwnerId);
        }
     if(groupMemberIdSet.contains(currentuser)){

        surveyResponseFlag =true;
        
        //surveyResponsePage =new PageReference('https://css-csat-v1-0.cs15.visual.force.com/apex/caseViewResponse?id='+caseObj.id);
        //surveyResponsePage.setRedirect(true); 


        system.debug('UserID and Case Owner are Same');
        
      }
      else
      {
          surveyResponseFlag = false;
      }
      

       
         //return surveyResponsePage;
   }
     
     // Case Save Action
    public Pagereference  savecaseTest()
    {
        PageReference nextPage;
        System.debug('caseObj.Status ::: '+caseObj.Status);
        System.debug('caseObj.Sub_Status__c ::: '+caseObj.Sub_Status__c);
         try{           
                
               system.debug('******382********'+caseObj.Site__c);
                if(!editflag)
                {
                    //caseObj.GeoZone__c = contactObj.site__r.GeoZone__c;//create case    
                }
              
                system.debug('----------testing '+caseObj.Partner_Owns_Case__c+'*********'+caseObj.Partner_Account__c+'--'+caseObj.Partner_Contact__c+'---'+caseObj.Partner_Owns_Case__c+'---------'+caseObj.Partner_Case__c);
             if(caseObj.Partner_Owns_Case__c != 'Yes' && (caseObj.Partner_Account__c != null ||  caseObj.Partner_Contact__c != null || caseObj.Partner_Case__c != null))
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please select \'Partner Owns Case\' as Yes.');
                    ApexPages.addMessage(myMsg);
                    return nextPage;
                }
                if(caseObj.Partner_Owns_Case__c == 'Yes' && (caseObj.Partner_Account__c == null ||  caseObj.Partner_Contact__c == null || caseObj.Partner_Case__c == null))
                {
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,' Please fill up Partner Contact and Partner Case number.');
                    ApexPages.addMessage(myMsg);
                    return nextPage;
                }
                //caseObj.Site__c = contactObj.Site__c;
                id serviceId = servicecontract.get(serviceContractList);               
                caseObj.AssetId = selectedasset;
                caseObj.Service_Contract__c = serviceContractList;
                //caseObj.GeoZone__c = contactObj.site__r.GeoZone__c;
                if(caseAction == 'Clone') {
                /*case insCloneCase = new case();
                insCloneCase.Site__c = */
                
                    insert caseObj;
                } else {    
                    system.debug('-------------'+caseObj.Site__c+'--------'+caseObj);                              
                    upsert caseObj;
                }               

                nextPage = new PageReference(BaseURL+'/apex/PNveditCase?id='+caseObj.id+'&action=edit');

                nextPage.setRedirect(true); 
         }
         catch (exception ex)
         {
                /* string error= string.valueOf(ex.getMessage());
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,error);
                    ApexPages.addMessage(myMsg);*/
               
                system.debug(ex.getcause());
         }
         return nextPage;
    }


    public pagereference loadSurveyResponse()
    {
       system.debug('---view response');
        PageReference surveyResponsePage;   
        List<CSATURL__c> csat = CSATURL__c.getall().values();
        string csatUrl = csat[0].surveyResponseURL__c;
        
        surveyResponsePage =new PageReference(csatUrl+'//apex/caseViewResponse?id='+caseObj.id);
        //surveyResponsePage.setRedirect(true); 
        return surveyResponsePage;
    
    }
    
     public pagereference CancelCase()
    {
       system.debug('---view response');
       PageReference CancelCasePage= new PageReference(BaseURL+'/500/o');
       return CancelCasePage;
    }
    
    public pagereference acceptCaseForUnassignedQueue()
    {
        PageReference caseViewPage;
        try{            
            String currentUserName = UserInfo.getName();  
                
                 String sObjectName, recordTypeName, mode, linkRefName, BaseUrl;
            sObjectName = 'Case';
            //System.Debug('caseID:  ' +caseID  +'\t\t retURL:  ' +retURL +'\t\t RecordTypeId: ' +recordTypeId +'\t\t ent:  ' +ent  +'\n\n params trough URL: ' +params);
            System.debug('>>>>Updating owner with:  '+ UserInfo.getUserId());
            //System.Debug('c.OwnerId.Name  before chnaging the Owner: ' +currentCase.Owner.Name);
            
            Case currentCaseBeforeAccept = [Select RecordType.Name, RecordTypeId, Owner.Name, OwnerId, Id, CaseNumber From Case Where Id =: caseID FOR UPDATE];
            System.Debug('*******currentCaseBeforeAccept.Owner.Name: ' +currentCaseBeforeAccept.Owner.Name  +'\n\t\t ******currentCaseBeforeAccept.RecordType.Name: ' +currentCaseBeforeAccept.RecordType.Name);

            currentCaseBeforeAccept.OwnerId = UserInfo.getUserId();
            currentCaseBeforeAccept.Case_Accepted_By__c = currentUserName; // currentUserName;
            currentCaseBeforeAccept.Status = 'Open';
            currentCaseBeforeAccept.Sub_Status__c = 'Assigned';
            update currentCaseBeforeAccept;
                        
            Case currentCaseAfterAccept = [Select RecordType.Name, RecordTypeId, Owner.Name, OwnerId, Id, CaseNumber From Case Where Id =: caseID FOR UPDATE];  
            System.Debug('*******currentCaseAfterAccept.Owner.Name: ' +currentCaseAfterAccept.Owner.Name  +'\n\t\t ******currentCaseAfterAccept.RecordType.Name: ' +currentCaseAfterAccept.RecordType.Name);
                
                    string caseURL =  URL.getSalesforceBaseUrl().toExternalForm() ;
                caseViewPage = new PageReference(caseURL+'/apex/PNveditCase?id='+caseObj.id+'&action=edit');

                system.debug('-------case view page '+caseViewPage);
                caseViewPage.setRedirect(true); 
            
        }   //RecordType.Name, RecordTypeId
        catch (exception ex)
        {
            system.debug(ex.getcause());
        }
        return caseViewPage;
    }
    
    public  pagereference editcase()
    {
        
        PageReference editPage = new PageReference(BaseURL+'/apex/PNveditCase?id='+caseObj.id+'&action=edit');
        editPage.setRedirect(true); 
        return editPage;
    }
    
      public  pagereference printCase()
    {
        
        PageReference editPage = new PageReference(BaseURL+'/apex/PNvprintCase?id='+caseObj.id+'&action=print');
        editPage.setRedirect(true); 
        return editPage;
    }
    
    public pagereference closeCase()
    {
            PageReference closeCase = new PageReference(BaseURL+'/apex/PNvCloseCase?id='+caseObj.id);
            closeCase.setRedirect(true);    
            return closeCase;
    
    }
    public pagereference cloneCase()
    {
        case cloneCaseObj = new case();
        cloneCaseObj = caseObj.clone();
        
        //upsert cloneCaseObj;
        system.debug('--clone'+caserec+'---'+cloneCaseObj);
        PageReference clonePage = new PageReference(BaseURL+'/apex/PNvCase?id='+caseObj.id+'&action=clone');
        clonePage.setRedirect(true);    
        return clonePage;
        
    }
    /*public pagereference cloneCasetest()
    {
        case cloneCaseObj = new case();
        cloneCaseObj = caseObj.clone();
        //upsert cloneCaseObj;
        system.debug('--clone'+caserec+'---'+cloneCaseObj);
        //PageReference clonePage = new PageReference(BaseURL+'/apex/PNveditCase?id='+cloneCaseObj.id+'&action=edit');
        //clonePage.setRedirect(true);    
        return cloneCaseObj ;
        
    } */ 
    
    public pagereference loadPartnerAccount() {
        try{
            id partnercontactId;
            system.debug('----------'+caseObj.id+'--------'+editflag);               
            
            if(caseObj.Partner_Contact__c == null && editflag == false){
                //Contact cnt = [Select id, Name From Contact Where Name = 'Dave Miller' limit 1];
                //partnercontactId = cnt.id;
                //caseObj.Partner_Contact__c = cnt.id;
                //caseObj.Partner_Owns_Case__c = 'Yes';
            }else{
                partnercontactId = caseObj.Partner_Contact__c;
                partnerContact = [select id,name,phone,email,accountid,account.name from contact where id = :partnercontactId and Account.RecordType.Name = 'Partner Account'];
                caseObj.Partner_Account__c =partnerContact.accountid;
            }    
            system.debug('---&&&&&--'+partnercontactId);           
            system.debug('-----'+partnercontactId);         
            //partnerContact = [select id,name,phone,email,accountid,account.name from contact where id = :partnercontactId and Account.RecordType.Name = 'Partner Account'];
            //caseObj.Partner_Account__c =partnerContact.accountid;            
        } catch (exception ex){
            system.debug('Exception in PNcCase - loadPartnerAccount'+ex.getMessage());
            system.debug('Exception in PNcCase - loadPartnerAccount'+ex.getStackTraceString());
        }
        return null;
    }
    
    public pagereference reopenCase()
    {       
        caseObj.status = 'Open';
        upsert caseObj;
        PageReference editPage = new PageReference(BaseURL+'/apex/PNveditCase?id='+caseObj.id+'&action=edit');
        editPage.setRedirect(true); 
        return editPage;
        
    }
     public pagereference savecloseCase()
    {       
        PageReference caseViewPage ;
        try{
            
            caserec.status =closeStatusValue;
            upsert caserec;
            caseViewPage = new PageReference(BaseURL+'/apex/PNveditCase?id='+caserec.id+'&action=Edit'); 
            caseViewPage.setRedirect(true);     
            
            }
            catch (exception ex)
            {
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,' Priority should be changed from <SET> to another value.');
                ApexPages.addMessage(myMsg);
                //system.debug(ex.getcause());
            }
        return caseViewPage;
    }
    

    
    public PageReference cancel() {
        
        if(caserec.id == null){
            PageReference caseViewPage = new PageReference(BaseURL+'/500/o'); 
            system.debug('--base url --'+BaseURL+'/500/o');  
            caseViewPage.setRedirect(true);     
            return caseViewPage;}
        else
        {
             PageReference caseViewPage = new PageReference(BaseURL+'/apex/PNveditCase?id='+caserec.id+'&action=edit'); 
            caseViewPage.setRedirect(true);     
            return caseViewPage;
        }
    return null;
    }
    
    
    
     public PageReference canceledit() {
         PageReference caseViewPage = new PageReference(BaseURL+'/apex/PNvViewCase?id='+caserec.id); 
        caseViewPage.setRedirect(true);     
        return caseViewPage;
    }
    
    public  PageReference save() {
        
        system.debug('------can cel -');
         return null;
    
    }
    
    public PageReference checkRequired(){
        System.debug('caseObj.Status ::: '+caseObj.Status);
        System.debug('caseObj.Sub_Status__c ::: '+caseObj.Sub_Status__c);
        if(caseObj.Sub_Status__c == 'Unsupported'){
            isRequired = false;
        }else{
            isRequired = true;
        }
        return null;    
    }
    
     public PageReference  queueViewCasePage(){
         PageReference caseViewPage = new PageReference(BaseURL+'/apex/PNvViewCase?id='+caserec.id); 
        caseViewPage.setRedirect(true);     
        return caseViewPage;
        
     }
     public void getLoadAssets(){
        try{
            System.debug('serviceContractList ::: '+serviceContractList);
            if(serviceContractList == null && lstServiceContract != null && lstServiceContract.size() > 0){
                serviceContractList = lstServiceContract[0].Id;
            }
            System.debug('serviceContractList ::: '+serviceContractList);
            ServiceContract scVal = [Select id, Name, Sales_Order__c, Sales_Order_ASSET__c From ServiceContract Where id=:serviceContractList];
            lstAsset = new List<Asset>();
            lstSecOpt = new List<SelectOption>();
            if(scVal.Sales_Order_ASSET__c != null){
                lstAsset = [Select id, Name, Sales_Order__c, Sales_Order_RevAdv__c From Asset Where Sales_Order_RevAdv__c =:scVal.Sales_Order_ASSET__c];                
                for(Asset ast:lstAsset){
                    lstSecOpt.add(new SelectOption(ast.Id, ast.Name));
                }
            }
            
        }catch(Exception ex){
            System.debug('Exception ex :::'+ex.getStackTraceString());
        }
     }
     public PageReference redirectToAssetList(){
        PageReference pageRef = new PageReference('/apex/PNvRMACreation?id='+caseId);
        pageRef.setRedirect(true);
        return pageRef;
     }  
}
