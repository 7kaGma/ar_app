using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using FlutterUnityIntegration;

public class SetScene : MonoBehaviour
{   
    private UnityMessageManager Manager;
    void Start(){
        Manager = GetComponent<UnityMessageManager>();
    }
    void setScene(string sceneName)
    {
        SceneManager.LoadScene(sceneName);
    }

}
