using FlutterUnityIntegration;
using UnityEngine;
using UnityEngine.UIElements.Experimental;
// 初期化

public class SwitchModel:MonoBehaviour{

    private UnityMessageManager Manager;
    [SerializeField]
    public GameObject parentObject;

    private GameObject ArObject;
    private GameObject[] childObject;

    

    //初期化関数
    void Start(){
        Manager = GetComponent<UnityMessageManager>();

        // ARモデルを格納しているArObjectの取得
        ArObject = parentObject.transform.Find("ArObject").gameObject;

        // childObjectに子要素を配列形式で格納
        int childCount = ArObject.transform.childCount;
        Debug.Log(childCount);
        childObject = new GameObject[childCount];
        
        for(int i = 0; i < childCount; i++){
            childObject[i] = ArObject.transform.GetChild(i).gameObject;
        }

        // 表示を初期化
        HideAllObjects();
        GameObject referenceObject = GameObject.Find("Scripts");
        DisplayObjectNumber reference = referenceObject.GetComponent<DisplayObjectNumber>();
        int index = reference.displayObjectNumber;

        if (childObject.Length > 0){
            Debug.Log("最後のif文動いてるよ");
            childObject[index].SetActive(true);
        }  
    }


    //表示の切り替える関数(public)
    public void SwitchObject(){
        GameObject referenceObject = GameObject.Find("Scripts");
        DisplayObjectNumber reference = referenceObject.GetComponent<DisplayObjectNumber>();
        int index = reference.displayObjectNumber;

        if (index < childObject.Length){
            HideAllObjects();
            childObject[index].SetActive(true);
        }else{
            Debug.Log("Invalid index"); 
        }
    }

    /*==========
    関数群
    ==========*/
    // 全てのオブジェクトを非表示にする関数
    void HideAllObjects(){
        foreach(GameObject element in childObject){
            element.SetActive(false);
            Debug.Log("オブジェクト消しました");
        }
    }
}





