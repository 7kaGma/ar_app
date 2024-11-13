using UnityEngine;

public class RenameObject : MonoBehaviour
{
    public GameObject arObject; // XROrigin にインスタンスされている AR オブジェクトをアタッチ

    void Start()
    {
        if (arObject != null)
        {
            arObject.name = "ArModel"; // 新しい名前に変更
            Debug.Log("ARオブジェクトの名前を変更しました: " + arObject.name);
        }
        else
        {
            Debug.LogError("ARオブジェクトが指定されていません。");
        }
    }
        
}