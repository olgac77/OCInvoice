({
    doInit: function(component, event, helper) {
        helper.getFile(component,event);        
    },
    
	handleUploadFinished : function(component, event, helper) {        
      	var recordId = component.get("v.recordId");
      	var uploadedFile = event.getParam("files");
	 	var existingFiles = component.get("v.files") || [];
        var newFiles = [];      
        var documentId = uploadedFile[0].documentId;       
      	
        var action = component.get("c.validateLogo");
      	action.setParams({"sellerId": recordId, "documentId":documentId});
      	action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = response.getReturnValue();
            if (state === "SUCCESS") {               
                if(responseValue.Successful===false){
                    var message = responseValue.Message;
                    helper.handleErrors(message, $A.get("$Label.c.ErrorLabel"), "error");
                }else{
                    uploadedFile.forEach(function(file) {
                        newFiles.push({
                            ContentDocumentId: file.documentId
                        });
        			})
                    existingFiles.forEach(function(file) {
                        newFiles.push({
                            ContentDocumentId: file.ContentDocumentId
                        });
                    })
        			component.set("v.files", newFiles);
					console.log(message);                    
                    helper.handleErrors(responseValue.Message, $A.get("$Label.c.SuccessLabel"), "success");
                }
            }else{
                	var errors = response.getError(); 
                	helper.handleErrors(errors[0].message,$A.get("$Label.c.ErrorLabel"), "error");                  
            	}
           });       
        	$A.enqueueAction(action);        
 		},
    
    deleteFile: function(component, event, helper) {
        if(confirm($A.get("$Label.c.ConfirmationLabel"))) {
        	helper.deleteFile(component, event);
        }
    }   
})