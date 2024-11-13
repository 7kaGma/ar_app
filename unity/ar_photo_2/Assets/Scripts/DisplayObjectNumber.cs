using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisplayObjectNumber : MonoBehaviour
{
    public int displayObjectNumber;
    
    private void Start() {
        displayObjectNumber = 0;
    }

    public void UpdateDisplayObjectNumber(string message){
        int value;
        if(int.TryParse(message,out value)){
            displayObjectNumber = value;
        }else{
            Debug.Log("Invalid message format");
        }
    
    }
}

