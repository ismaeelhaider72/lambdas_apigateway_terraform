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
    errors=[]
    resp={
    "success":False ,
    "StatusCode":400 ,
    "message":""
    }
    if not event :
        resp["message"]=' invalid input reque'
        errors.append( 'errormessage : No events Found ') 
    else:    
        IndexOfRegno=list(event.keys()).index("regno")
        event.update({list(event.keys())[IndexOfRegno]:list(event.values())[IndexOfRegno].upper()})
    
        regno = event.get('regno', None)
        if regno==None or not regno:
            resp["message"]=' Registration Number is Primary Key must be Entered First'
            errors.append( 'errormessage : Invalid registration number ')
            errors.append( 'errormessage : Registration Number is not Entered ')
            
            
        else:
            if(check_if_item_exist(regno)):
                response = table.delete_item(
                    Key={
                        'regno' : regno
                        })
                resp["success"]=True
                resp["StatusCode"]=200
                resp["message"]='Date Deleted Successfully '
                
                      
    
            else: 
                resp["message"]='Data not found '
                errors.append('errormessage : Data not match with any primary key ') 
            
             
    if not errors:
           resp["errors"]=None
    else:
            resp["errors"]=errors
    return resp 