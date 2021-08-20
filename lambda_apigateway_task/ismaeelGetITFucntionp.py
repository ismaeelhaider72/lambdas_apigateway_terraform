import json
import boto3
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ismaeelDB')


def check_if_item_exist(item):
    response = table.get_item(
        Key={
            'regno': item
        }
    )
    return True if ('Item' in response) else False



def lambda_handler(event, context):
    resp={
    "success":False ,
    "StatusCode":400 ,
    "message":""
    }
    errors=[]
    if not event :
        resp["message"]=' invalid input request'
        errors.append( 'errormessage : No events Found ') 
    else:    
        IndexOfRegno=list(event.keys()).index("regno")
        aa=event.update({list(event.keys())[IndexOfRegno]:list(event.values())[IndexOfRegno].upper()})
        
        regno=event.get('regno', None)
        if ( not regno) :
            resp["message"]=' Registration Number is Primary Key must be Entered First'
            errors.append( 'errormessage : Invalid registration number ')
            errors.append( 'errormessage : Registration Number is not Entered ')  
    
    
        else:
            if(check_if_item_exist(regno)):        
                response = table.get_item(Key={'regno': regno})
                items=response["Item"]
                if 'section' in items:
                    del items['section']
                    resp["success"]=True
                    resp["StatusCode"]=200
                    resp["message"]=' Data Get Successfully'
                    resp["data"]=items
                else:    
                    resp["success"]=True
                    resp["StatusCode"]=200
                    resp["message"]=' Data Get Successfully'
                    resp["data"]=items
      
    
            else:
 
                resp["message"]=' Data is not present'
                errors.append( 'errormessage : Data not found / registration no does not match the any data primary key')
                
                
        
    if not errors:
           resp["errors"]=None
    else:
            resp["errors"]=errors             
        
    return resp


  